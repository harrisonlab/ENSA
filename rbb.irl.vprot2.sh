#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=4G
#SBATCH --cpus-per-task=10


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate bedtools_env

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/

GENOME_LOC=$1

cd ${DATA}

#cat ${GENOME_LOC} |while read key;

#do

cd ${GENOME_LOC}
#sbatch ./scripts/rbb.part3.irl.sh ~/data/genomes_key29042021.txt 
#cd ${key}
#echo ${key}
#Basename=$(echo $key)
Basename=$(echo $GENOME_LOC)


#makeblastdb -in ${Basename}.augustus.hints.aa -dbtype prot -out ${Basename}_prot
makeblastdb -in ${Basename}.proteome.fasta -dbtype prot -out ${Basename}_prot
makeblastdb -in ${Basename}.gene.fasta -dbtype nucl -out ${Basename}_nucl


#tblastn -query ${Basename}.augustus.hints.aa -db ${Basename}_nucl -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 10 > ${Basename}.blast.outfmt6
tblastn -query ${Basename}.proteome.fasta -db ${Basename}_nucl -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 10 > ${Basename}.blast.outfmt6
#Switch query and search paths for reciprocal search
blastx -query ${Basename}.gene.fasta -db ${Basename}_prot -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 10 > ${Basename}.blast_reciprocal.outfmt6
#Output end status message

##Input query blast results file
queryPath="${Basename}.blast.outfmt6"
#Input DB reciprocal blast results file
dbPath="${Basename}.blast_reciprocal.outfmt6"

#Usage ex: bash findRBH.sh blast.outfmt6 blast_reciprocal.outfmt6
#Final output files

outFileRBH=${Basename}.blast_RBH.txt
outFileSummary=${Basename}.blast_RBH_summary.txt
#Add headers to output RBH files
echo "queryHit,dbHit,percentage,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore" > $outFileRBH
echo "queryHits,dbHits,bestHits" > $outFileSummary
#Output start status message
echo "Recording RBH..."
#Loop over query blast results
while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
do
#Determine RBH to DB blast results
if grep -q "$f2"$'\t'"$f1"$'\t' $dbPath; then 
echo "$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$f10,$f11,$f12" >> $outFileRBH
fi
done < $queryPath
#Output summary of RBH
queryHits=$(wc -l "$queryPath" | cut -d ' ' -f 1)
dbHits=$(wc -l "$dbPath" | cut -d ' ' -f 1)
bestHits=$(($(wc -l "$outFileRBH" | cut -d ' ' -f 1)-1))
echo "$queryHits","$dbHits","$bestHits" >> $outFileSummary
#Output end status message
echo "Finished recording RBH!"

cd ..

done

conda deactivate
