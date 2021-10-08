#!/bin/bash



#conda activate irl_rnaseq
for f in 61 62 65 66 67 68; 
do
 salmon quant -i ../../annotations/D_glo/Datglo_index --libType A  -1 SRR63845${f}_1.fastq.gz -2 SRR63845${f}_2.fastq.gz \
 -p 10 --validateMappings -o quants/${f}_quant
 done
