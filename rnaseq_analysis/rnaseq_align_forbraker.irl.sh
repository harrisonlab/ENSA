#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=20G
#SBATCH --cpus-per-task=30


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 

export DATA=~/../../projects/ensa/plants/RNAseq/raw_data

# This is the script for aligning the RNAseq data to generate the *.bam files required for braker.  
# This script reads from a txt file containing  "key, species, tissue and genome" 
# For example: 

# "rnaseq_assembly_list16092021.txt"

#Cp  Colpar  Cp_LS   Colletia_paradoxa.softmasked.fasta
#Cp  Colpar  Cp_R    Colletia_paradoxa.softmasked.fasta
#Cm  Cermon  Cm_L    Cercocarpus_montanus.softmasked.fasta
#Ct  Ceathy  Ct_L    Ceanothus_thyrsiflorus.softmasked.fasta
#Ct  Ceathy  Ct_S    Ceanothus_thyrsiflorus.softmasked.fasta 
#Cu  Coluli  Cu_LS   Colletia_ulcina.softmasked.fasta
#Fu  Filulm  Fu_L    Filipendula_ulmaria.softmasked.fasta
#Fu  Filulm  Fu_R    Filipendula_ulmaria.softmasked.fasta
#Fu  Filulm  Fu_S    Filipendula_ulmaria.softmasked.fasta
#Re  Rubell  Re_L    Rubus_ellipticus.softmasked.fasta
#Re  Rubell  Re_R    Rubus_ellipticus.softmasked.fasta
#Re  Rubell  Re_S    Rubus_ellipticus.softmasked.fasta

#This is fed in the variable GENOME_LOC.

GENOME_LOC=$1

cd ${DATA}

cat ${GENOME_LOC} |while read key species tissue genome;

do


cd ${tissue}
echo ${tissue}
Basename=$(echo $tissue)

hisat2 -p 30 -x ../${species} -1 ${tissue}.clean_1.fq.gz -2 \
${tissue}.clean_2.fq.gz -S ${tissue}.sam 

#Convert sam to bam, and sort
samtools view -@ 30 -bS ${tissue}.sam| samtools sort -o ${tissue}.bam

rm  ${tissue}.sam

cd ..
done

conda deactivate


