#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=8G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 


# Before alignning the RNAseq data, you need to make a hisat2 index for each genome. 
# This script does that, by reading from a txt file containing  "key, species, tissue and genome" 
# For example: 

# "rnaseq_assembly_list16092021.txt"

#Cp  Colpar  Cp_LS   Colletia_paradoxa.softmasked.fasta
#Cp  Colpar  Cp_R    Colletia_paradoxa.softmasked.fasta
#Cm  Cermon  Cm_L    Cercocarpus_montanus.softmasked.fasta
#Ct  Ceathy  Ct_L    Ceanothus_thyrsiflorus.softmasked.fasta
#Ct  Ceathy  Ct_S    Ceanothus_thyrsiflorus.softmasked.fasta 
#Cu  Coluli  Cu_LS   Colletia_ulcina.softmasked.fasta
#Fu  Filulm  Fu_L    Filipendula_ulmaria.softmasked.fasta
#Fu  Filulm  Fu_R    Filipendula_ulmaria.softmasked.fasta
#Fu  Filulm  Fu_S    Filipendula_ulmaria.softmasked.fasta
#Re  Rubell  Re_L    Rubus_ellipticus.softmasked.fasta
#Re  Rubell  Re_R    Rubus_ellipticus.softmasked.fasta
#Re  Rubell  Re_S    Rubus_ellipticus.softmasked.fasta

export DATA=~/../../projects/ensa/plants/RNAseq/raw_data

GENOME_LOC=$1

cd ${DATA}

cat ${GENOME_LOC} |while read key species tissue genome;

do

hisat2-build ~/../../scratch/projects/illorens/data/genomes_available/$genome ~/../../projects/ensa/plants/RNAseq/raw_data/$species
done

conda deactivate
