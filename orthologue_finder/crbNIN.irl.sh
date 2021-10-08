#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=8G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate crb-blastenv

export DATA=~/../../scratch/projects/illorens/data/genomes_available

cd ${DATA}

GENOME_LOC=$1
TARGET=$2
OUTPUT=$3

crb-blast --query ${GENOME_LOC} \
--target  ~/data/extraNINs/${TARGET} \
--threads 20 \
--split \
--output ~/../../scratch/projects/illorens/Motif_search/NINbe/${OUTPUT}.txt

conda deactivate


cd ${DATA}

GENOME_LOC=$1
QUERY_LOC=$2



cat ${QUERY_LOC}|while read  tf genes
do
echo $genes

cat ${GENOME_LOC} |while read output genome;

do

crb-blast --query ${GENOME_LOC} \
--target  ~/data/extraNINs/${TARGET} \
--threads 20 \
--split \
--output ~/../../scratch/projects/illorens/Motif_search/NINbe/${OUTPUT}.txt

done

done




