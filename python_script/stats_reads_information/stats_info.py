import re
import pysam
import argparse

parser = argparse.ArgumentParser(description="python stats_info.py -i ../example/test.bam -r 1 > chr1_reads.info")
parser.add_argument("-i", "--input", type=str, metavar="", required=True, help="input the bam file")
parser.add_argument("-r", "--chromosome", type=str, metavar="", required=True, help="For one chromosome, eg. 1 refer to your ref; or ALL, eg. ALL")
args = parser.parse_args()


def max_num(num_1, num_2):

    return(max(num_1, num_2))

def stats_info_bam(input_file, chro):

        bamfile = pysam.AlignmentFile(input_file, 'rb')

        print("ID\tMat\tSNV\tIns\tDel\tmax_Ins\tmax_Del\tSkip\tmapq")

        if chro == "ALL":

                bam_file = bamfile
        else:
                bam_file = bamfile.fetch(str(chro))

        for reads in bam_file:

                reads_mapq = reads.mapping_quality

                total_mat_num = 0; max_value = 0; N_ins = 0
                max_ins = 0; N_del = 0; max_del = 0; N_skip = 0

                pairs_string = ""
                ID = reads.qname
                cigar = reads.cigarstring
                pairs = reads.get_aligned_pairs(matches_only=True,with_seq=True)

                # calculate the number of match and snp by get_aligned_pairs
                for i in pairs:
                        pairs_string += str(i[-1])

                pairs_string_mat = re.findall("[A, T, G, C]", pairs_string)
                pairs_string_snp = re.findall("[a, t, g, c]", pairs_string)

                N_mat = len(pairs_string_mat)
                N_snp = len(pairs_string_snp)

                # calculate the number of indel and the max by cigarstring

                cigar_ins = re.findall(r"\d+[I]+", cigar)
                cigar_del = re.findall(r"\d+[D]+", cigar)
                cigar_skip = re.findall(r"\d+[S, H]+", cigar)

                for i in cigar_ins:
                        max_ins = max_num(max_ins, int(i[:-1]))
                        N_ins += int(i[:-1])

                for i in cigar_del:
                        max_del = max_num(max_del, int(i[:-1]))
                        N_del += int(i[:-1])

                for i in cigar_skip:
                        N_skip += int(i[:-1])

                print(str(ID) + "\t" + str(N_mat) + "\t" + str(N_snp) + "\t" + str(N_ins) + "\t" + str(N_del) + \
                        "\t" + str(max_ins) + "\t" + str(max_del) + "\t" + str(N_skip) + "\t" + str(reads_mapq))

if __name__=="__main__":

    stats_info_bam(args.input, args.chromosome)

