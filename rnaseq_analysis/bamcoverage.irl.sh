#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=8G
#SBATCH --cpus-per-task=20


#taken and modified from the bioinformaticsworkbook tutorial. 
#after trimming the rnaseq data, run this script to align it to the masked genome 

#note variable DBDIR does not need a "/" at the end. 
#There is a problem with samtools on my conda env so its better to conda deactivate before running samtools

#sh runAlignConvertSortStats.sh 20 sequence_1.fastq seqeunce_2.fastq 
#/work/GIF/remkv6/files genome.fa

export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 

export DATA=../../projects/ensa/plants/RNAseq/Casgla

cd ${DATA}


GENOME=$1


hisat2-build ${GENOME} ${GENOME%.*}
hisat2 -p 20 -x ${GENOME} -1 SRR534922${SLURM_ARRAY_TASK_ID}.clean_1.fastq.gz -2 SRR534922${SLURM_ARRAY_TASK_ID}.clean_2.fastq.gz -S SRR534922${SLURM_ARRAY_TASK_ID}.sam 


conda deactivate
#Convert sam to bam, and sort
samtools view -@ 20 -bS SRR534922${SLURM_ARRAY_TASK_ID}.sam| samtools sort -o SRR534922${SLURM_ARRAY_TASK_ID}.bam
for i in *.bam; do  bamCoverage -b $i -o ${i}.fwd.out --filterRNAstrand forward -bs 10 -of bedgraph;  bamCoverage -b $i -o ${i}.rev.out --filterRNAstrand reverse -bs 10 -of bedgraph; done


#Use this is if you have already generated a bam file. No need to make an index, alignment etc again.
#samtools index SRR51456${SLURM_ARRAY_TASK_ID}.bam -@20 
#bamCoverage -b SRR51456${SLURM_ARRAY_TASK_ID}.bam -o SRR51456${SLURM_ARRAY_TASK_ID}.bedgraph -bs 10 -of bedgraph;
#conda deactivate
