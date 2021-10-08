#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=70G
#SBATCH --cpus-per-task=30


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate crb-blastenv

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/

cd ${DATA}

GENOME_LOC=$1
TARGET=$2

cat ${GENOME_LOC} |while read output genome;

do

#mkdir ${output}
echo ${output}
cd ${output}
#https://morphoscape.wordpress.com/2020/08/18/reciprocal-best-hits-blast-rbhb/

#Usage: bash runRBLAST.sh PATH/TO/QUERY/FILE PATH/TO/DB/FILE PATH/TO/OUTPUTS

#Make blastable protein DB of the input query

#This version is for genomes in which v1 didn't work. The idea is to use the denovo annotation output from braker to extract the genes and then the promoters

#makeblastdb -in ~/../../scratch/projects/illorens/data/genomes_available/${genome} -dbtype nucl -out ${genome}
#Make blastable protein DB of the target DB
#makeblastdb -in ~/data/extraNINs/${TARGET} -dbtype prot -out ${TARGET}

#Output start status message
echo "Beginning reciprocal BLAST..."

#Use blastp to search a database
blastx -query ~/../../scratch/projects/illorens/data/genomes_available/${genome} -db ${TARGET} -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > blast.outfmt6
#Switch query and search paths for reciprocal search
tblastn -query ~/data/extraNINs/${TARGET} -db ${genome} -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > blast_reciprocal.outfmt6
#Output end status message
echo "Finished reciprocal BLAST!"

#
##Input query blast results file
queryPath="blast.outfmt6"
#Input DB reciprocal blast results file
dbPath="blast_reciprocal.outfmt6"

#Usage ex: bash findRBH.sh blast.outfmt6 blast_reciprocal.outfmt6
#Final output files
outFileRBH= ${output}.blast_RBH.txt
outFileSummary=${output}.blast_RBH_summary.txt
#Add headers to output RBH files
echo "queryHit,dbHit" > $outFileRBH
echo "queryHits,dbHits,bestHits" > $outFileSummary
#Output start status message
echo "Recording RBH..."
#Loop over query blast results
while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
do
#Determine RBH to DB blast results
if grep -q "$f2"$'\t'"$f1"$'\t' $dbPath; then #RBH
echo "$f1,$f2" >> $outFileRBH
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


#process 
#awk -F ',' '{if ( $7 > $8 ) {print $1"\t"$7"\t" $8"\t""-""\t"$2"\t"$9"\t"$10} else {print $1"\t"$7"\t" $8"\t""+""\t"$2"\t"$9"\t"$10}}' Alnglu.blast_RBH.txt |sort -k1,1 -k2,2n  

#need to remove the header first. Then after running that script I need to merge with a good gap, bedtools slop for promoter extraction, bedtools getfasta and seqkit for extracting just the promoters. 
#I need to think about extracting the new hits and blast them against the proteomes to get the aminoacids for the tree. 
#The first step is to get all the NIN promoters that I can and meme the shit out of them!. Also do some phylogenetic footprinting, AME the lots. 

