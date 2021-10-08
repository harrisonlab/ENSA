#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=8G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 

export DATA=../../scratch/projects/illorens/data/genomes_available

cd ${DATA}


GENOME=$1
INDEX=$2

hisat2-build ${GENOME} ./indexes/hisat_indexes/${INDEX}

conda deactivate
