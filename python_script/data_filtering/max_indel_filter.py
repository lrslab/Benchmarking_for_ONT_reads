"""
filtering the reads from bam file accoding to the max length of indel setted. 
"""

import re
import pysam
import argparse

parser = argparse.ArgumentParser(description="python max_indel_filter.py -i ../example/test.bam -o out -I 100 -S 10")
parser.add_argument("-i", "--input", type=str, metavar="", required=True, help="input the bam file")
parser.add_argument("-o", "--output", type=str, metavar="", required=True, help="name of output file")
parser.add_argument("-I", "--num_max_indel", type=int, metavar="", required=True, help="max length of indel")
parser.add_argument("-S", "--skin_percentage", type=int, metavar="", required=True, help="max proportion of clip length (clip_length / read_length)")
args = parser.parse_args()

def max_num(num_1, num_2):

    return(max(num_1, num_2))

def filter_I_D_S(input_file, output_file, N_max_indel, N_skin_percentage):

	bamfile = pysam.AlignmentFile(input_file, 'rb')
	outfile_1 = pysam.AlignmentFile(output_file + ".bam", "wb", template=bamfile)
	outfile_2 = pysam.AlignmentFile(output_file + "_filered.bam", "wb", template=bamfile)

	for reads in bamfile:

		total_mat_num = 0; max_value = 0; N_ins = 0
		max_ins = 0; N_del = 0; max_del = 0; N_skin = 0

		pairs_string = ""
		ID = reads.qname
		cigar = reads.cigarstring
		pairs = reads.get_aligned_pairs(matches_only=True,with_seq=True)

		for i in pairs:
			pairs_string += str(i[-1])

		pairs_string_mat = re.findall("[A, T, G, C]", pairs_string)
		pairs_string_snp = re.findall("[a, t, g, c]", pairs_string)

		N_mat = len(pairs_string_mat)
		N_snp = len(pairs_string_snp)

		cigar_ins = re.findall(r"\d+[I]+", cigar)
		cigar_del = re.findall(r"\d+[D]+", cigar)
		cigar_skin = re.findall(r"\d+[S, H]+", cigar)

		for i in cigar_ins:
			max_ins = max_num(max_ins, int(i[:-1]))
			N_ins += int(i[:-1])

		for i in cigar_del:
			max_del = max_num(max_del, int(i[:-1]))
			N_del += int(i[:-1])

		for i in cigar_skin:
			N_skin += int(i[:-1])

		N_all = N_mat + N_snp + N_ins + N_skin
		P_skin = 100 * N_skin / N_all

		if (max_ins <= N_max_indel) and (max_del <= N_max_indel) and (P_skin <= N_skin_percentage):
			outfile_1.write(reads)
		else:
			outfile_2.write(reads)

	bamfile.close()
	outfile_1.close()
	outfile_2.close()

if __name__=="__main__":
    filter_I_D_S(args.input, args.output, args.num_max_indel, args.skin_percentage)