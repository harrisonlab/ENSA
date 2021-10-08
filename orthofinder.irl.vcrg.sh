#!/usr/bin/env bash

#SBATCH --partition=himem
#SBATCH --mem=100G
#SBATCH --cpus-per-task=30

#ulimit -n 2404
#ulimit -Sn
export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate orthofinder_env

export DATA=../../scratch/projects/illorens/data/proteomes/

cd ${DATA}

orthofinder -f proteomes_2 -a 10 -t 30

conda deactivate