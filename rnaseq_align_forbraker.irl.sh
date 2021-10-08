#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=20G
#SBATCH --cpus-per-task=30


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 

export DATA=~/../../projects/ensa/plants/RNAseq/raw_data


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


