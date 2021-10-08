#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=10G
#SBATCH --cpus-per-task=16


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 



#Run repeat modeler before repeat masker on the genome. According to the tutorial
# A genome of >1gb could take about 96 hrs to run on a 16 cpu node

# "GCA_003255025.1_ASM325502v1_genomic.fna"

#make up a name for your database, choose your search engine, the number of threads, and the  genome file

BuildDatabase -name GCA_003255025.1_ASM325502v1.DB -engine rmblast GCA_003255025.1_ASM325502v1_genomic.fna
RepeatModeler -database GCA_003255025.1_ASM325502v1.DB -engine ncbi -pa 16 


conda deactivate





