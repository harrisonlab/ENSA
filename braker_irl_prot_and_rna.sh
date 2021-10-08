#!/bin/bash
#SBATCH --cpus-per-task=40
#SBATCH --mem 50G
#SBATCH --nodelist=triticum
#SBATCH --partition=himem

#export PERL5LIB="/home/annew/perl5/lib/perl5"
#export PERL5LIB="/home/illorens/miniconda3/envs/braker2.irl.env/bin/perl"
#export PERL5LIB="/home/gomeza/miniconda3/envs/gene_pred/bin/perl"
##export GENEMARK_PATH=~/../../scratch/software/GeneMark-EX_04Jan2021/gmes_linux_64
#export PROTHINT_PATH=~/ProtHint/bin
#export MYCONDAPATH=/home/illorens/miniconda3
#source ${MYCONDAPATH}/bin/activate braker2.irl.env

#change_path_in_perl_scripts.pl "/home/illorens/miniconda3/envs/braker2.irl.env/bin/perl"
#export PERL5LIB="/home/annew/perl5/lib/perl5"
#export PERL5LIB="/home/illorens/perl5/lib/perl5"
#export GENEMARK_PATH="/home/illorens/bin/gmes_linux_64"
#

export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate aw.braker.env

#aw.braker.env
#braker2.irl.env


#export DATA=/scratch/projects/illorens
#cd ${DATA}

#assembly=$1
#proteins=$2
#species=$3      # can't be used twice.
#outdir=$4
#rnaseqdir=$5
#rna=($rnaseqdir/*.bam)
#printf -v joined '%s,' ${rna[@]}



#braker.pl --species=$species \
#--genome=$assembly \
#--etpmode \
#--prot_seq=$proteins \
#--bam=${joined%,} \
#--gff3 \
#--cores 40 \
#--workingdir=$outdir \
#--verbosity 4 \
#--softmasking \
#--PYTHON3_PATH=/scratch/software/miniconda3/bin \
#--GENEMARK_PATH="/scratch/software/GeneMark-EX_04Jan2021/gmes_linux_64" \
#--ALIGNMENT_TOOL_PATH="/scratch/software/GeneMark-EX_26March2020/gmes_linux_64/ProtHint/bin" 

export DATA=~/bin/BRAKER/example
cd ${DATA}

outdir=$1
##
#srun /scratch/software/BRAKER-2.1.5/scripts/braker.pl --genome=genome.fa --prot_seq=proteins.fa \
#       --hints=RNAseq.hints --etpmode --softmasking \
#       --PYTHON3_PATH=/scratch/software/miniconda3/bin \
#       --workingdir=$outdir \
#       --ALIGNMENT_TOOL_PATH="/scratch/software/GeneMark-EX_26March2020/gmes_linux_64/ProtHint/bin" \
#       --GENEMARK_PATH="/scratch/software/GeneMark-EX_04Jan2021/gmes_linux_64" 
##
#srun /scratch/software/BRAKER-06october2021/scripts/braker.pl --genome=genome.fa --prot_seq=proteins.fa \
#       --hints=RNAseq.hints --etpmode --softmasking \
#       --workingdir=$outdir \
#       --GENEMARK_PATH="/scratch/software/genemark-ES_18_May_2021/gmes_linux_64" \
#       --ALIGNMENT_TOOL_PATH="/scratch/software/genemark-ES_18_May_2021/gmes_linux_64/ProtHint/bin/" \
#       --AUGUSTUS_BIN_PATH="/usr/bin/augustus" \
#       --AUGUSTUS_SCRIPTS_PATH="/usr/share/augustus/scripts" \
#       --AUGUSTUS_CONFIG_PATH="/usr/share/augustus/config"


     /scratch/software/BRAKER-06october2021/scripts/braker.pl --genome=genome.fa --prot_seq=proteins.fa \
     --hints=RNAseq.hints --etpmode --softmasking \
     --PYTHON3_PATH=/scratch/software/miniconda3/bin \
     --workingdir=$outdir \
     --ALIGNMENT_TOOL_PATH="/home/illorens/bin/gmes_linux_64/ProtHint/bin" \
     --GENEMARK_PATH="/home/illorens/bin/gmes_linux_64" \
     --PROTHINT_PATH="/home/illorens/bin/ProtHint/bin" \
     --DIAMOND_PATH="/home/bin"
