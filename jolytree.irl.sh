#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem-per-cpu=16G
#SBATCH --cpus-per-task=20

export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate phyloenv

export DATA=~/../../scratch/projects/illorens

cd ${DATA}

~/bin/JolyTree/JolyTree.sh -i data/genomes_available -b actino_clade3 -t 20 -s 1.0

conda deactivate
