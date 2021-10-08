#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate bedtools_env

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/

GENOME_LOC=$1 #full path
GENE=$2 #YUCCA, LBD16 etc


cd ${DATA}/${GENE}

cat ${GENOME_LOC} |while read key genome;

do

#divide them and see if they crash!! 

#sbatch ./scripts/rbb.part3.irl.sh ~/data/genomes_key31032021.txt YUCCA
cd ${key}
echo ${key}

Basename=$(echo $key)
Basegenome=$(echo $genome)

#Convert the output of RBH into a bed file. 
#awk -F','  'NR>1{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' ${key}.blast_RBH.txt |sort -k1,2 -k7,7n| \
#awk '{if ( $7 > $8 ) {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""-"} else {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""+"}}' > ${key}.RBH.bed
awk -F','  'NR>1{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' ${key}.blast_RBH.txt |sort -k1,2 -k7,7n| \
awk '{if ( $7 > $8 ) {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""-"} else {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""+"}}' | \
awk '{OFS="\t"; if ($6=="+") {print} else {print $1,$3,$2,$4,$5,$6}}' > ${key}.RBH.bed
#

#merge all the hits for each chromosome. -d needs to be set to overlap the whole gene. 

bedtools merge -i ${Basename}.RBH.bed  -d 5000 -c 4,5,6 -o distinct,collapse,distinct > ${Basename}.RBH.gene.bed
#
##To make exons for new peptides I need to extract the fasta files and then merge them somehow. use seqkit
#
##Make a chr.sizes file for each genome!
#
cut -f 1,2 ~/../../scratch/projects/illorens/data/genomes_available/${genome}.fai > ${Basename}.chr.sizes 
###use bedtools to extract the whole gene and 2.5 kb of the promoter
#
bedtools slop -i ${Basename}.RBH.gene.bed -g ${Basename}.chr.sizes -l 2500 -r 0 -s > ${Basename}.gene.prom.bed
##
###use bedtools to extract the fasta file containinig promoter and gene. 
bedtools getfasta -fi ~/../../scratch/projects/illorens/data/genomes_available/${Basegenome} -bed ${Basename}.gene.prom.bed -s -fullHeader > ${Basename}.gene_2.5kbprom.fasta
bedtools getfasta -fi ~/../../scratch/projects/illorens/data/genomes_available/${Basegenome} -bed ${Basename}.RBH.gene.bed -s -fullHeader > ${Basename}.gene.fasta

###once I had the promoters with coding sequence I'm using seqkit to extract only fractions of promoter sequences
seqkit subseq -r 1:3000 ${Basename}.gene_2.5kbprom.fasta > ${Basename}_2.5kbprom.0.5cds.fasta
#for 2.5kb plus 500 cds 
#
cd ..
#
done

conda deactivate

#


