## methylation_filter_false_positive.py

This script helps to remove the false positive CpG methylation site(s) in Human sample, especially the whole-genomes sequencing (WGS) .

### Dependent

To apply this script, you will need the **pandas**, a python package, in your environment. The following command can help to install.

```shell
pip install pandas
```

### Usage

To apply the script in your data with default arguments, you can use the command

```shell
python methylation_filter_false_positive.py -i <methylation_table> -db <false_positive_sites_database> -o <output_table>
```

A description of these arguments are as follows:

1. <methylation_table> - The result of [megalodon](https://github.com/nanoporetech/megalodon) (modified_bases.5mC.bed/modified_bases.5hmC.bed), or you can re-define your input type with four required columns, including Chromosome, Start, End, and Percentage. Please use the tab ("\t") to gap the column instead of the space (" ").

```shell
# megalodon resulte
1	10468	10469	.	1	+	10468	10469	0,0,0	1	100.0
1	10470	10471	.	0	+	10470	10471	0,0,0	0	0.0
1	10483	10484	.	1	+	10483	10484	0,0,0	1	0.0
1	10488	10489	.	1	+	10488	10489	0,0,0	1	0.0
1	10492	10493	.	1	+	10492	10493	0,0,0	1	0.0
1	10496	10497	.	2	+	10496	10497	0,0,0	2	0.0

# bed file type
1	10468	10469	100.0
1	10470	10471	0.0
1	10483	10484	0.0
1	10488	10489	0.0
1	10492	10493	0.0
1	10496	10497	0.0
```

2. <false_positive_sites_database> - This is false positive database. The databases including 5mC (Nanopore R10.4 and R9.4.1) and 5hmC (Nanopore R10.4 and R9.4.1) are available (https://figshare.com/account/home#/projects/167018).
3. <output_table>  - Any name you want for result.



To re-define the cutoff of false positive level, you can use the command

```shell
python methylation_filter_false_positive.py -i <methylation_table> -db <false_positive_sites_database> -o <output_table> -m <methylation_proportion>
```

-m / --methods, this is the argument to define the cutoff of false positive level. The default cutoff is *M2S* (Mean + 2* Standard Deviation) that *M* is mean of  total CpG sites methylation proportion in database, while *S* is the standard deviation of those data. You can choose the cutoff from 1 to 100 to create your specially  database which is more suitable to your data based on biological background and statistics.

### Test data

Here we show a sample demo to display the CpG sites (filtered and unfiltered) in human mitochondrial DNA with default argument sequenced by R10.4 flow cell. More details can be found in result part of article. 

![Image text](https://github.com/lrslab/Benchmarking_for_ONT_reads/blob/main/demo_picture/Rplot01_WGS_R10.4_MT_5mC.jpg) 
