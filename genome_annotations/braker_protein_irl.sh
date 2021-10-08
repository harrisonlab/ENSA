#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=48G
#SBATCH --cpus-per-task=20



export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate brakerenv


export DATA=/scratch/projects/illorens

cd ${DATA}

#run ProtHints

~/bin/prothint.py $i example/input/proteins.fasta


braker.pl --genome genome.fa --prot_seq proteins.fa --softmasking /
 --GENEMARK_PATH=/home/illorens/bin/ProtHint/dependencies/GeneMarkES /
 --ALIGNMENT_TOOL_PATH=/home/illorens/bin/ProtHint/dependencies --epmode


 conda deactivate
 exit



braker.pl --genome=../../data/genomes_available/Rubus_ellipticus.final.fasta  --softmasking /
 --hints=./ProtHint_out/Rubell_out/prothint_augustus.gff /
 --GENEMARK_PATH=/home/illorens/bin/ProtHint/dependencies/GeneMarkES /
 --ALIGNMENT_TOOL_PATH=/home/illorens/bin/ProtHint/dependencies --epmode


# Wed Nov 11 12:33:23 2020: Log information is stored in file /scratch/projects/illorens/genome_annotation/out/braker/braker.log
#Use of uninitialized value $evidence_hints in concatenation (.) or string at /home/illorens/miniconda3/envs/brakerenv/bin/braker.pl line 6174.
#ERROR in file /home/illorens/miniconda3/envs/brakerenv/bin/braker.pl at line 6179
#Could not open file /scratch/projects/illorens/genome_annotation/out/braker/prothint.gff!

