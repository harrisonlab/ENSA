#!/bin/bash

export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate irl_rnaseq


#Code to run Salmon: Fast, accurate and bias-aware transcritp quantification from RNAseq data
#based on: https://combine-lab.github.io/salmon/getting_started/

for f in 61 62 65 66 67 68; 
do
 salmon quant -i ../../annotations/D_glo/Datglo_index --libType A  -1 SRR63845${f}_1.fastq.gz -2 SRR63845${f}_2.fastq.gz \
 -p 10 --validateMappings -o quants/${f}_quant
 done
