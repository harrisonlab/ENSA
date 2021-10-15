#!/bin/bash
#SBATCH --cpus-per-task=10
#SBATCH --mem 20G
#SBATCH --partition=long

#This is a test script for braker2 made under Anne's settings. It requires
#a name for the outdir, a file for a genome, the RNAseq.hints and protein hits
# (all provided when downloaded braker)

export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate aw.braker.env

export PATH="/scratch/software/cdbfasta/:$PATH"
export DATA=~/bin/BRAKER/example
cd ${DATA}

outdir=$1
#

     srun /scratch/software/BRAKER-06october2021/scripts/braker.pl --genome=genome.fa --prot_seq=proteins.fa \
     --hints=RNAseq.hints \
     --etpmode \ 
     --softmasking \
     --nocleanup \
     --PYTHON3_PATH=/scratch/software/miniconda3/bin \
     --workingdir=$outdir \
     --GENEMARK_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/" \
    --ALIGNMENT_TOOL_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/" \
    --PROTHINT_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/ProtHint/bin/" 




