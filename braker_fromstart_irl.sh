#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=48G
#SBATCH --cpus-per-task=20



export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate brakerenv


#export DATA=../../projects/ensa/plants/D_glom/bam
export DATA=../../scratch/projects/illorens

cd ${DATA}


braker.pl --genome GCA_003255025.1_ASM325502v1_genomic_simpleheader.fna \
 --bam SRR6384561.sam.bam,SRR6384562.sam.bam,SRR6384565.sam.bam,SRR6384566.sam.bam,SRR6384567.sam.bam,SRR6384568.sam.bam \
 --softmasking --GENEMARK_PATH=/home/illorens/bin/gmes_linux_64 --cores 8 --UTR=on --makehub --email=Ivan.Llorens@niab.com


 conda deactivate
 exit


