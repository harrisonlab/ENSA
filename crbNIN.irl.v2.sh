#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=8G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate crb-blastenv

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/

cd ${DATA}

GENOME_LOC=$1
TARGET=$2

cat ${GENOME_LOC} |while read output genome;

do

mkdir ${output}

cd ${output}
crb-blast --query ~/../../scratch/projects/illorens/data/genomes_available/${genome} \
--target  ~/data/extraNINs/${TARGET} \
--threads 20 \
--split \
--output ~/../../scratch/projects/illorens/Motif_search/NINbe/${output}/${output}.txt

cd ..

done

conda deactivate




