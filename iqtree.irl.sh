#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate iqtreeenv

#export DATA=../../scratch/projects/illorens/phylogenomics/out/iqtree_out
export DATA=../../scratch/projects/illorens/Motif_search/NINbe/NIN4
cd ${DATA}
#full location
INPUT=$1
OUTPUT=$2
GENE=$3
#Preprocess rnaseq data downloaded from SRA for annotating the Datisca genome

#mkdir ${GENE}

muscle -in ${INPUT} -out ${GENE}/${OUTPUT}
iqtree -s ${GENE}/${OUTPUT} -T AUTO -mem 32G -B 1000 -bnni -redo

conda deactivate

'''example.phy.iqtree: the main report file that is self-readable. You should look at this file to see the computational results. 
    It also contains a textual representation of the final tree (see below).
example.phy.treefile: the ML tree in NEWICK format, which can be visualized by
   any supported tree viewer programs like FigTree or iTOL.
example.phy.log: log file of the entire run (also printed on the screen).
 To report bugs, please send this log file and the original alignment file to the authors.'''