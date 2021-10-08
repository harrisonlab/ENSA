#!/bin/bash
#SBATCH --cpus-per-task=40
#SBATCH --mem 50G
#SBATCH --nodelist=triticum
#SBATCH --partition=himem

export PATH="/scratch/software/cdbfasta/:$PATH"
#export PERL5LIB="/home/annew/perl5/lib/perl5"
export PERL5LIB="/home/gomeza/miniconda3/envs/gene_pred/bin/perl"

export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate brakerenv
export DATA=/scratch/projects/illorens

cd ${DATA}

assembly=$1
proteins=$2
species=$3      # can't be used twice.
outdir=$4
rnaseqdir=$5
rna=($rnaseqdir/*.bam)
printf -v joined '%s,' ${rna[@]}


srun /scratch/software/BRAKER-2.1.5/scripts/braker.pl --species=$species \
--genome=$assembly \
--etpmode \
--prot_seq=$proteins \
--bam=${joined%,} \
--gff3 \
--cores 40 \
--workingdir=$outdir \
--verbosity 4 \
--softmasking \
--PYTHON3_PATH=/scratch/software/miniconda3/bin \
--GENEMARK_PATH="/scratch/software/GeneMark-EX_04Jan2021/gmes_linux_64" \
--ALIGNMENT_TOOL_PATH="/scratch/software/GeneMark-EX_26March2020/gmes_linux_64/ProtHint/bin" 
#--GENEMARK_PATH="~/../../scratch/software/genemark-ES_18_May_2021/gmes_linux_64" \

