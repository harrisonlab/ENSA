#!/usr/bin/env bash

#SBATCH --partition=short
#SBATCH --time=0-03:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=12


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 

export DATA=../../projects/ensa/plants/D_glom/rna-seq/rnaseq_pairend/

cd ${DATA}


#Preprocess rnaseq data downloaded from SRA for annotating the Datisca genome

DATE=fastqc_results$(date +%y%m%d)
mkdir ${DATE}


#Run FASTQ on trimmed samples


echo "Run FastQC"

fastqc --threads 12 *.gz --outdir ${DATE}

conda deactivate

