"""
filtering the reads mapped to the reference fragment which contains N base. 
"""

import pysam
import re
import argparse

parser = argparse.ArgumentParser(description="python N_base_in_ref_filter.py -i ../example/test.bam ")
parser.add_argument("-i", "--input", type=str, metavar="", required=True, help="input the bam file")
args = parser.parse_args()

def filter_bam(inputfile):

    bamfile = pysam.AlignmentFile(inputfile, 'rb')
    outfile_1 = pysam.AlignmentFile("clean_non_N_sort.bam", "wb", template=bamfile)
    outfile_2 = pysam.AlignmentFile("filtered_N_sort.bam", "wb", template=bamfile)

    for read in bamfile:

        N = "no"
        pairs = read.get_aligned_pairs(matches_only=True,with_seq=True)

        for base in pairs:

            if base[2] == "n" or base[2] == "N":
                N = "yes"
                break

        if N == "yes":
            outfile_2.write(read)

        else:
            outfile_1.write(read)                

    bamfile.close()
    outfile_1.close()
    outfile_2.close()

if __name__=="__main__":
    filter_bam(args.input)