#!/usr/bin/env bash
#SBATCH -J busco
#SBATCH --partition=long
#SBATCH --mem=25G
#SBATCH --cpus-per-task=40

#Script to run BUSCO on a list of genomes. It requires a txt file $QUERY_LOC that contains:
# output name and
# genome file
# It will iterate from the list and run busco on each genome. 

export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate buscoenv

export DATA=~/../../scratch/projects/illorens/phylogenomics



cd ${DATA}
QUERY_LOC=$1


cat ${QUERY_LOC}|while read out genomes
do
    busco -m genome -i $genomes -o $out -c 10 -f -l eudicots_odb10

done



