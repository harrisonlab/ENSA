#!/usr/bin/env bash 


#SBATCH --partition=long
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4


#bulk download of SRA files for RNAseq

export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate irl_rnaseq 

export DATA=~/../../projects/ensa/plants/RNAseq

cd ${DATA}



echo "pre-fetching:"
#modify this part accordingly adding the sra ids

#prefetch SRR638456${SLURM_ARRAY_TASK_ID}
#SRR5349563


prefetch SRR9623${SLURM_ARRAY_TASK_ID}

#parallel-fastq-dump --sra-id SRR638456${SLURM_ARRAY_TASK_ID} --threads 6 --outdir ${DATA}rna-seq/ --split-files --gzip
parallel-fastq-dump --sra-id SRR9623${SLURM_ARRAY_TASK_ID} --threads 4 --outdir ${DATA}/rnaseq_course --split-files --gzip
conda deactivate

exit
#




