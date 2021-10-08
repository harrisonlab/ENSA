#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=6G
#SBATCH --cpus-per-task=10


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 


#export DATA=../../projects/ensa/plants/D_glom/rna-seq/rnaseq_pairend/
#export DATA=~/../../projects/ensa/plants/RNAseq/
export DATA=~/../../projects/ensa/plants/novogene/20210907_rna/X204SC21073493-Z01-F001/raw_data

cd ${DATA}

key=$1
#key is a common Identifier for running slurm jobs a.i SRR5349

#Preprocess rnaseq data downloaded from SRA for annotating the Datisca genome

#Run FASTQ before trimming and aligning

DATE=fastqc_results_${key}${SLURM_ARRAY_TASK_ID}$(date +%y%m%d)
mkdir ${DATE}
fastqc --threads 12 ${key}${SLURM_ARRAY_TASK_ID}_1.fastq.gz \
${key}${SLURM_ARRAY_TASK_ID}_2.fastq.gz --outdir ${DATE}

#trim 

bbduk.sh  in1=${key}${SLURM_ARRAY_TASK_ID}_1.fastq.gz in2=${key}${SLURM_ARRAY_TASK_ID}_2.fastq.gz \
out1=${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz out2=${key}${SLURM_ARRAY_TASK_ID}.clean_2.fastq.gz \
ref=~/bin/bbmap/resources/adapters.fa k=23 ktrim=r useshortkmers=t mink=11 qtrim=r trimq=10 minlength=20 ftl=15 ftr=73 t=12


#Run FASTQ on trimmed samples

echo "Run FastQC"

fastqc --threads 12 ${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz \
${key}${SLURM_ARRAY_TASK_ID}.clean_2.fastq.gz --outdir ${DATE}

conda deactivate


