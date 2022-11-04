"""
!/usr/bin/env python
-*- coding: utf-8 -*-
@Date: 2022-10-26
@Author: Xudong, xudongliu98@gmail.com
"""


import csv
import argparse
import sys
import pandas as pd


def create_false_positive_db(input_methods, input_db):
    header = ["chr", "start", "end", "strandedness", "coverage", "percentage"]
    db = pd.read_csv(input_db, header=None, sep="\t", names=header, low_memory=False)
    if input_methods == "M2S":
        mean = db['percentage'].mean()
        sd = db['percentage'].std()
        db = db[db["percentage"] >= float(mean) + 2 * float(sd)]
        db.iloc[:, :3].to_csv("false_positive_site.db",
                              index=False, header=False, quoting=csv.QUOTE_NONE, sep="\t")
    else:
        db = db[db["percentage"] >= float(input_methods)]
        db.iloc[:, :3].to_csv("false_positive_site.db",
                              index=False, header=False, quoting=csv.QUOTE_NONE, sep="\t")


def load_false_positive_db(input_file):
    Dir = {}
    with open(input_file, 'r') as ff:
        for line in ff.readlines():
            line = line.replace("\n", "")
            line = line.split("\t")
            Dir[line[0] + "_" + line[1] + "_" + line[2]] = 1
    return (Dir)


def main(input_methods, input_db, input_file, output_file):
    create_false_positive_db(input_methods, input_db)
    print("[Step1] False positive sites were detected!")
    db = load_false_positive_db("false_positive_site.db")
    print("[Step2] The database of false positive sites was loaded!")
    result = open(output_file, "w")

    with open(input_file, 'r') as ff:
        for l in ff.readlines():
            sub_l = l.split("\t")
            if sub_l[0] + "_" + sub_l[1] + "_" + sub_l[2] not in db.keys():
                result.write(str(l))
    result.close()
    print("[Step3] The false positive sites were filtered!")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="A script to help remove the false positive methylation site(s)")
    parser.add_argument("-m", "--methods", type=str, metavar="", required=False, default="M2S",
                        help="M2S (default) or false positive methylation level (from 1 to 100 percentage)")
    parser.add_argument("-i", "--input_table", type=str, metavar="", required=True,
                        help="raw methylation table (result of megalodon)")
    parser.add_argument("-db", "--database", type=str, metavar="", required=True,
                        help="reference of scWGA methylation database")
    parser.add_argument("-o", "--output", type=str, metavar="", required=True,
                        help="name of your final output")
    args = parser.parse_args()
    main(args.methods, args.database, args.input_table, args.output)
