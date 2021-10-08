#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=8G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 

export DATA=~/../../projects/ensa/plants/RNAseq/raw_data

GENOME_LOC=$1

cd ${DATA}

cat ${GENOME_LOC} |while read key species tissue genome;

do

hisat2-build ~/../../scratch/projects/illorens/data/genomes_available/Colletia_paradoxa.softmasked.fasta ~/../../projects/ensa/plants/RNAseq/raw_data/Colpar
hisat2-build ~/../../scratch/projects/illorens/data/genomes_available/Cercocarpus_montanus.softmasked.fasta ~/../../projects/ensa/plants/RNAseq/raw_data/Cermon
hisat2-build ~/../../scratch/projects/illorens/data/genomes_available/Ceanothus_thyrsiflorus.softmasked.fasta ~/../../projects/ensa/plants/RNAseq/raw_data/Ceathy
hisat2-build ~/../../scratch/projects/illorens/data/genomes_available/Colletia_ulcina.softmasked.fasta ~/../../projects/ensa/plants/RNAseq/raw_data/Coluli
hisat2-build ~/../../scratch/projects/illorens/data/genomes_available/Filipendula_ulmaria.softmasked.fasta ~/../../projects/ensa/plants/RNAseq/raw_data/Filulm
hisat2-build ~/../../scratch/projects/illorens/data/genomes_available/Rubus_ellipticus.softmasked.fasta ~/../../projects/ensa/plants/RNAseq/raw_data/Rubell


conda deactivate
