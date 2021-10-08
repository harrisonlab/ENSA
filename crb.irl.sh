#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=20G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate crb-blastenv

export DATA=~/../../projects/ensa/plants/

cd ${DATA}

GENOME_LOC=$1
QUERY_LOC=$2



cat ${QUERY_LOC}|while read  tf genes
do
echo $genes

cat ${GENOME_LOC} |while read output genome;

do

crb-blast --query $genes \
--target $genome \
--threads 20 \
--split \
--output ${output}_${tf}.txt

done

done



