#!/bin/bash
#SBATCH --cpus-per-task=40
#SBATCH --mem 25G
#SBATCH --partition=long


export PATH="/scratch/software/cdbfasta/:$PATH"
export PERL5LIB="/home/annew/perl5/lib/perl5"

export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate brakerenv

export DATA=/scratch/projects/illorens

cd ${DATA}

assembly=$1
proteins=$2
species=$3      # can't be used twice.
outdir=$4

srun /scratch/software/BRAKER-2.1.5/scripts/braker.pl --species=$species \
--genome=$assembly \
--epmode \
--prot_seq=$proteins \
--gff3 \
--cores 40 \
--workingdir=$outdir \
--verbosity 4 \
--softmasking \
--PYTHON3_PATH=/scratch/software/miniconda3/bin \
--GENEMARK_PATH="~/../../scratch/software/GeneMark-EX_04Jan2021/gmes_linux_64" \
--ALIGNMENT_TOOL_PATH="/scratch/software/GeneMark-EX_26March2020/gmes_linux_64/ProtHint/bin" 
