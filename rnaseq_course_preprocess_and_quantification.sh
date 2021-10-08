#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=6G
#SBATCH --cpus-per-task=10

#Intro

#The following code is intended to perform some QC on the M. truncatula
#data we downloaded from SRA. Then, after trimming we are going to use 
#the Salmon tool which is a "reference free" software tool to quantify 
#RNAseq data against a transcriptome. 


export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate testenv
export DATA=~/../../projects/ensa/plants/RNAseq/rnaseq_course

cd ${DATA}

#Step1 

#Step 1 is to perform some QC analysis on the data we downloaded from SRA.
#In this case Index is the index to map the rnaseq data. See line 61 of 
#this code for instructions into how to create an index. When setting up
#the INDEX variable state full location. 
#It is important to create the index out of this code.

# The value key is a common Identifier for running slurm jobs for example "SRR5349" 
# is a common identifier among all the samples we downloaded. 
#This is very helpful for performing tasks in batch.

#This is how the command looks when running it on the cluster:
#sbatch --array=261,263,259,260,262,257,258,256,238,237,239,232,236,211,234,235,233,209,208,207,210,206,179,205,204,183,184,182,180,181,178,176,177,131,135,133,134,130,137,136,132%5 ./scripts/rnaseq_course_preprocess.sh Medtru_index SRR9623


INDEX=$1
key=$2


#Name a variable DATA for outputing FastQC results
DATE=fastqc_results_${key}${SLURM_ARRAY_TASK_ID}_$(date +%y%m%d)
mkdir ${DATE}.out

#Run FastQC before trimming and aligning

fastqc --threads 10 ${key}${SLURM_ARRAY_TASK_ID}_1.fastq.gz \
 --outdir ${DATE}.out

#trim single end
bbduk.sh  in=${key}${SLURM_ARRAY_TASK_ID}_1.fastq.gz \
out=${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz  \
ref=~/bin/bbmap/resources/adapters.fa k=23 ktrim=r useshortkmers=t mink=11 qtrim=r trimq=10 minlength=20 ftl=15 ftr=73 t=20

#Run FASTQ on trimmed samples

echo "Run FastQC"

fastqc --threads 10 ${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz \
--outdir ${DATE}

conda deactivate

#Step 2
#Quantification. 
#For the salmon pipeline, we are going to use a transcriptome for mapping. 
#One of the benefits of performing quantification directly on the transcriptome 
#(rather than using the host genome), is that one can easily quantify assembled transcripts as well 
#(obtained via software such as StringTie for organisms with a reference or Trinity for de novo RNA-seq experiments).

# To create an index  salmon index -t TRANSCRIPTOME.fa.gz -i TRANSCRIPTOME_index
source ${MYCONDAPATH}/bin/activate irl_rnaseq

salmon quant -i ${INDEX} --libType A  -r ${key}${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz \
 -p 10 --validateMappings -o ${key}${SLURM_ARRAY_TASK_ID}_quant

conda deactivate


