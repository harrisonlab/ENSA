#!/bin/bash
#SBATCH --cpus-per-task=40
#SBATCH --mem 50G
#SBATCH --nodelist=triticum
#SBATCH --partition=himem


export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate aw.braker.env
export PATH="/scratch/software/cdbfasta/:$PATH"
# export PYTHONPATH="${PYTHONPATH}:/scratch/software/miniconda3/bin"
# export PERL5LIB="/home/annew/perl5/lib/perl5"

#aw.braker.env
#braker2.irl.env
export DATA=~/bin/BRAKER/example
cd ${DATA}

outdir=$1
#--hints=RNAseq.hints --etpmode 

     srun /scratch/software/BRAKER-06october2021/scripts/braker.pl --genome=genome.fa --prot_seq=proteins.fa \
     --softmasking \
     --nocleanup \
     --PYTHON3_PATH=/scratch/software/miniconda3/bin \
     --workingdir=$outdir \
     --GENEMARK_PATH="/scratch/software/gmes_linux_64_4.68_07oct2021/" \
     --ALIGNMENT_TOOL_PATH="/scratch/software/gmes_linux_64_4.68_07oct2021/" \
     --PROTHINT_PATH="/home/illorens/bin/ProtHint/bin" \
     --DIAMOND_PATH="/home/bin"
    #\
    #--AUGUSTUS_BIN_PATH="/usr/bin/" \
    #--PROTHINT_PATH="/scratch/software/gmes_linux_64_4.68_07oct2021/ProtHint/bin/" \
    #--AUGUSTUS_SCRIPTS_PATH="/usr/share/augustus/scripts" \
    #--AUGUSTUS_CONFIG_PATH="/home/annew/config/"





