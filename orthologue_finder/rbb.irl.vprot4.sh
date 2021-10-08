#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=20G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate bedtools_env

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/

GENOME_LOC=$1
GENE=$2

cd ${DATA}/${GENE}


#retrieve the aminoacid sequences 
cat ../${GENE}.summary2.blast.txt |while read key protein promoter

do
echo $key
cd ${key}
grep ${protein} ../../proteomes/${key}.sl.proteome.fasta -A 1 | sed "s/>/>${key}_/"  >> ../${GENE}.proteins.fasta
cd ..
done

#do a blast search against blast db to remove poor candidates for tree building. 

#blastp –db nr –query ${GENE}.proteins.fasta -out ${GENE}.blast.results.out -remote -max_target_seqs 1 -outfmt 6 -evalue 1e-3 

#uniprot  blast to remove genes 
blastp -db ~/../../scratch/projects/illorens/Motif_search/NINbe/blast_db/uniprot -query test.blast.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-3 

conda deactivate

