#!/bin/bash
#SBATCH --cpus-per-task=10
#SBATCH --mem 20G
#SBATCH --partition=long


export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate aw.braker.env

export PATH="/scratch/software/cdbfasta/:$PATH"

export DATA=~/bin/BRAKER/example
cd ${DATA}

outdir=$1
#--hints=RNAseq.hints --etpmode 

     srun /scratch/software/BRAKER-06october2021/scripts/braker.pl --genome=genome.fa --prot_seq=proteins.fa \
     --softmasking \
     --nocleanup \
     --PYTHON3_PATH=/scratch/software/miniconda3/bin \
     --workingdir=$outdir \
     --GENEMARK_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/" \
    --ALIGNMENT_TOOL_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/" \
    --PROTHINT_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/ProtHint/bin/" 
    #--AUGUSTUS_BIN_PATH="/usr/bin/" \
    
    #--AUGUSTUS_SCRIPTS_PATH="/usr/share/augustus/scripts" \
    #--AUGUSTUS_CONFIG_PATH="/home/annew/config/"





