#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=8G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate crb-blastenv

export DATA=~/../../scratch/projects/illorens/data/genomes_available

cd ${DATA}

GENOME=$1
TARGET=$2
OUTPUT=$3

#Make a genome size file

echo "Calculating genome size"

cat ${GENOME}| \
awk -F " " '$1 ~ ">" {if (NR > 1) {print c;} c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }'| \
awk '{print $1"\t"$NF}' > ${OUTPUT}.gs.txt ;
echo "Genome size done"


echo "Running CRB-blast"

crb-blast --query ${GENOME} \
--target  ${TARGET} \
--threads 20 \
--split \
--output ${OUTPUT}.txt


# Filters hits by percentage of identity 
# Then it takes the genomic coordinates and makes a bed file 

awk '$3>=75' *.2.blast | \
sort -k2,2 -k9,9n | \
awk '{if ( $9 > $10 ) {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""-"} else {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""+"}}'| \
sort -k 1,1 > ${OUTPUT}_exons.bed

# merge all potential exons to make transcripts. 

bedtools merge -i ${OUTPUT}_exons.bed  -c 6,6,4 -o count,distinct,collapse -delim "|"| \
awk '$4>3 {print $1"\t"$2"\t"$3"\t"$4"\t"$5\t"$6}' > ${OUTPUT}.transcripts.bed

##### FIND A WAY OF EXTRACTING THE FIRST EXON!!!!! MAYBE PICK THE ENTRY WITH THE LOWEST START ? FOR EACH CHROMOSOME?
### THEN FLANK AND EXTRACT SEQUENCES! 

#extract fasta for the exons 

bedtools getfasta -fi ${GENOME} -bed ${OUTPUT}.exons.bed > ${OUTPUT}.exons.fasta

grep -v "^>" Rubell.nlp.exons.fasta | awk 'BEGIN { ORS=""; print ">My_New_Sequence_name\n" } { print }' >Rubell.nlp.cds.fasta

#select the first exon 
#Use this to translate in the 3 frames and blastp against database?

# run bedtools flank to get an extension of 5kb
out_name='basename $OUTPUT'

bedtools flank -i ${OUTPUT}.merged.bed -g ${OUTPUT}.gs.txt -l 5000 -r 500 -s  > ${OUTPUT}.5kprom.bed

#didnt work because bedtools doesnt recognise the bash variable so I had to echo each one of them and run it as a bash file 
cat ../crb_list_out.txt |while read a b c; do for i in ${a}_${b}_first_exon.bed; do echo bedtools slop -s -i $i -g ../../genome_sizes/${a}.txt -l 5000 -r 0  \>  ${a}_${b}.5kprom.bed >> bedtools_slope.sh  ; done; done

bash bedtools_slope.sh 
#This command will remove empty files 

find . -size 0 -delete

# get the fasta files for each one of them
cat ~/data/genome_location.txt |while read  tf genes; do cat ../crb_list_out.txt |while read a b c; do for i in ${a}_${b}.5kprom.bed; do echo bedtools getfasta -fi ../../$genes -bed ${a}_${b}.5kprom.bed -fo ${a}_${b}.5kprom.fasta  >> bedtools_getfasta.sh
#manually edited because I was getting unwanted combinations

#Now I got the promoters

conda deactivate


