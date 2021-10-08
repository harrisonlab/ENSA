#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=10G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate  testenv


#export DATA=../../projects/ensa/plants/D_glom/rna-seq/rnaseq_pairend/
export DATA=~/../../projects/ensa/plants/RNAseq/Alnglu

cd ${DATA}


#key is a common Identifier for running slurm jobs a.i SRR5349
#Genome is the genome to map the rnaseq data. State full location 
# It is important to create the index out of this code.

#GENOME=$2
INDEX=$1
key=$2
#Preprocess rnaseq data downloaded from SRA for annotating genome

#Run FASTQ before trimming and aligning

DATE=fastqc_results_${key}${SLURM_ARRAY_TASK_ID}_$(date +%y%m%d)
mkdir ${DATE}
fastqc --threads 20 ncbi/${key}${SLURM_ARRAY_TASK_ID}_1.fastq.gz \
 --outdir ${DATE}


#trim single end
bbduk.sh  in=${key}${SLURM_ARRAY_TASK_ID}_1.fastq.gz \
out=${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz  \
ref=~/bin/bbmap/resources/adapters.fa k=23 ktrim=r useshortkmers=t mink=11 qtrim=r trimq=10 minlength=20 ftl=15 ftr=73 t=20


#Run FASTQ on trimmed samples

echo "Run FastQC"

fastqc --threads 20 ${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz \
--outdir ${DATE}

#hisat2-build ${GENOME} ${GENOME%.*} # This is to create the index. It should be done out of the code.

#single end reads
hisat2 -p 20 -x ${INDEX} -U ${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz ${key}${SLURM_ARRAY_TASK_ID}.sam
#Convert sam to bam, and sort
samtools view -@ 20 -bS ${key}${SLURM_ARRAY_TASK_ID}.sam| samtools sort -o ${key}${SLURM_ARRAY_TASK_ID}.bam

rm  ${key}${SLURM_ARRAY_TASK_ID}.sam

#calculate coverage for visualization

samtools index ${key}${SLURM_ARRAY_TASK_ID}.bam -@20 

bamCoverage -b  ${key}${SLURM_ARRAY_TASK_ID}.bam -o ${key}${SLURM_ARRAY_TASK_ID}.bedgraph -bs 10 -of bedgraph

conda deactivate
