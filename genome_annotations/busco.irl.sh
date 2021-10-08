#!/usr/bin/env bash
#SBATCH -J busco
#SBATCH --partition=long
#SBATCH --mem=25G
#SBATCH --cpus-per-task=40



export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate buscoenv

export DATA=~/../../scratch/projects/illorens/phylogenomics

cd ${DATA}
QUERY_LOC=$1


cat ${QUERY_LOC}|while read out genomes
do
    busco -m genome -i $genomes -o $out -c 10 -f -l eudicots_odb10

done



