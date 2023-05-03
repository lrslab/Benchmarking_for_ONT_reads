"""
minimap2 -ax map-ont ref.mmi input.fastq -t 20 --secondary=no --MD -L, please use this to map
"""

import argparse
import pysam
import re

parser = argparse.ArgumentParser(description="python homopolymer_detection.py -i ../example/test.bam -r 10 > chr10_homopolymer.info")
parser.add_argument("-in", "--input", type=str, metavar="", required=True, help="input the bam file")
parser.add_argument("-r", "--chromosome", type=str, metavar="", required=True, help="For one chromosome, eg. 1 refer to your ref; or ALL, eg. ALL")
args = parser.parse_args()

def count_indel_and_snv(str):
    dict = {}
    for i in str:
        dict[i] = dict.get(i, 0) + 1
    return dict

#remove the insertion (I) in the tail of string
def remove_I(string):
	while string[-1] == "I":
		string = string[:-1]
	return(string)

# remove soft (S) and hard (H) clip in CIGAR and return the matched pairs
def remove_clip_list(input_cigar, input_pairs, input_ID):
	remove_cigarstring = re.findall(r"\d+[S, H]+", input_cigar)
	#HH & 0H & H0 & 00
	if ((len(remove_cigarstring) == 2) and (remove_cigarstring[0][-1] == remove_cigarstring[1][-1] == "H")) or ((len(remove_cigarstring) == 1) and (remove_cigarstring[-1] == "H")) or (len(remove_cigarstring) == 0):
		valid_pairs = input_pairs
	#SS
	elif (len(remove_cigarstring) == 2) and (remove_cigarstring[0][-1] == remove_cigarstring[1][-1] == "S"):
		remove_start_site = int(remove_cigarstring[0][:-1])
		tmp_pairs = input_pairs[remove_start_site:]
		remove_end_site = int(remove_cigarstring[1][:-1])
		valid_pairs = tmp_pairs[:len(tmp_pairs)-remove_end_site]
	# 0S & HS
	elif ((len(remove_cigarstring) == 1) and (input_cigar[-1] == "S")) or (len(remove_cigarstring) == 2) and (remove_cigarstring[0][-1] == "H") and ((remove_cigarstring[1][-1] == "S")):
		remove_end_site = int(remove_cigarstring[-1][:-1])
		valid_pairs = input_pairs[:len(input_pairs)-remove_end_site]
	# S0 & SH
	elif (len(remove_cigarstring) == 1) and (input_cigar[-1] != "S") or ((len(remove_cigarstring) == 2) and (remove_cigarstring[0][-1] == "S") and (remove_cigarstring[1][-1] == "H")):
		remove_start_site = int(remove_cigarstring[0][:-1])
		valid_pairs = input_pairs[remove_start_site:]
	else:
		print(str(input_ID) + ", please recheck this CIGAR and MD!")
	return(valid_pairs)

"""
only for base A T G C
(read_position, ref_position, "ref_base")
none	√	√	Deletion(D)
√	none	none Insertion(I)
√	√	N(A,T,G,C)	Match(M)
√	√	n(a,t,g,c)	Substitution(S)
"""
def get_base_alignment(input_list): 
	map_list = ["A", "T", "G", "C"]
	result = ""
	if input_list[0] == None:
		result = "D" # D = deletion
	else:
		if input_list[1] == None:
			result = "I" # I = insertion
		else:
			if input_list[2] in map_list:
				result = "M" # M = match
			else:
				result =  "S" # S = substitution
	return result

def homopolymer_from_bam(input_bamfile, chrom):
	bamfile = pysam.AlignmentFile(input_bamfile)

	# For one chromsome or all chromosomes
	if chrom != "ALL":
		bam_file = bamfile.fetch(str(chrom))
	else:
		bam_file = bamfile

	dir_polymer = {}

	for read in bam_file:
		read_ID = read.query_name
		read_pair = read.get_aligned_pairs(matches_only=False, with_seq=True) #show (read_position, ref_position, "ref_base")
		read_cigar = read.cigarstring # get the CIGAR for each read
		read_ref_id = read.reference_name # the aligned reference chromsome id e.g chr1

		read_valid_pair = remove_clip_list(read_cigar, read_pair, read_ID) # remove the cliping, only the mapped bases were remained.
		
		homoploymer_ref = "" 
		homoploymer_read = "" 
		homoploymer_ref_pos = [] 
		dir_polymer[read_ID] = {} 
		count = 1 

		for base in read_valid_pair:
			#start
			if homoploymer_ref == "":
				if get_base_alignment(base) != "I":
					homoploymer_ref = str(base[2]).upper()
					homoploymer_read = str(get_base_alignment(base))
					homoploymer_ref_pos.append(base[1])

			else:
					if base[2] == None:
						homoploymer_read += str(get_base_alignment(base))

					else:
						if str(base[2]).upper() == homoploymer_ref[0]:
							homoploymer_ref += str(base[2]).upper()
							homoploymer_read += str(get_base_alignment(base))
							homoploymer_ref_pos.append(base[1])

						elif str(base[2]).upper() != homoploymer_ref[0]:
							
							if len(homoploymer_ref) >= 4:
					
								homoploymer_ref_pos.insert(0, str(read_ref_id))
								homoploymer_ref_pos.insert(0, str(remove_I(homoploymer_read)))
								homoploymer_ref_pos.insert(0, str(len(homoploymer_ref)) + homoploymer_ref[0])
								dir_polymer[read_ID][str(count)] = homoploymer_ref_pos.copy()
								count += 1

							del homoploymer_ref_pos[:]
							homoploymer_ref = str(base[2]).upper()
							homoploymer_read = str(get_base_alignment(base))
							homoploymer_ref_pos.append(base[1])
	bamfile.close()
	print("#chr\tstart\tend\tnum\tbase\tmat\tdel\tins\tsub\tread_ID")
	for read in dir_polymer.keys():
		for n in dir_polymer[read].keys():
			stat_info = count_indel_and_snv(str(dir_polymer[read][n][1]))

			if "M" not in stat_info.keys():
				stat_info["M"] = 0
			if "D" not in stat_info.keys():
				stat_info["D"] = 0
			if "S" not in stat_info.keys():
				stat_info["S"] = 0
			if "I" not in stat_info.keys():
				stat_info["I"] = 0


			print("chr" + str(dir_polymer[read][n][2]) + "\t" +  str(dir_polymer[read][n][3]) + "\t" + str(dir_polymer[read][n][-1]) + "\t" + # chr start end
			     str(dir_polymer[read][n][0][:-1]) + "\t" + str(dir_polymer[read][n][0][-1]) + "\t" + #  4 A
			     str(stat_info["M"]) + "\t" + str(stat_info["D"]) + "\t" + str(stat_info["I"]) + "\t" + str(stat_info["S"])  + "\t" + # map del ins sub
			     str(read))

if __name__=="__main__":
    homopolymer_from_bam(args.input, args.chromosome)

"""
dir_polymer = {'f15ee502-ff6a-404d-93a0-34d315c753d8': 
{'1': ['4A', 'DDDD', 'MT', 5809, 5810, 5811, 5812], 
'2': ['5A', 'MMMMM', 'MT', 5829, 5830, 5831, 5832, 5833], 
'3': ['4C', 'MMMM', 'MT', 5843, 5844, 5845, 5846], 
'4': ['4T', 'MMMM', 'MT', 5884, 5885, 5886, 5887], 
'5': ['5C', 'MMMMM', 'MT', 5894, 5895, 5896, 5897, 5898], 
'6': ['4C', 'DMMM', 'MT', 6152, 6153, 6154, 6155], 
'7': ['5C', 'MMMMM', 'MT', 6168, 6169, 6170, 6171, 6172], 
'8': ['4C', 'MMMM', 'MT', 6185, 6186, 6187, 6188]}}

"""
