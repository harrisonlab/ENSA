#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=20G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate bedtools_env

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/

GENOME_LOC=$1
GENE=$2

cd ${DATA}/${GENE}


cat ${GENOME_LOC} |while read key proteome;

do

#sbatch ./scripts/rbb.irl.vprot3.1.sh ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/prot_workingdataset.txt YUCCA

cd ${key}
echo ${key}
Basename=$(echo $key)
# 

awk '$3>=95' ${key}.prot.blast.outfmt6 |sort -u -k1,2  > prot.blast_RBH.tmp.txt
awk -v var=${key} '{print var"\t"$1"\t"$2}' prot.blast_RBH.tmp.txt |uniq >> ../${GENE}.summary2.blast.txt
rm prot.blast_RBH.tmp.txt

cd ..

done

conda deactivate


