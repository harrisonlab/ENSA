#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=70G
#SBATCH --cpus-per-task=30

#Use blastp to search a database
genome="Fraves.v4.0.a1.fasta"
out="Mt_Defense"

Basename=$(echo $out)
Basegenome=$(echo $genome)

makeblastdb -in ~/../../scratch/projects/illorens/data/genomes_available/${genome} -dbtype nucl -out ~/../../scratch/projects/illorens/Motif_search/NINbe/blast_db/${genome}

blastx -query ~/../../scratch/projects/illorens/data/genomes_available/${genome} -db Mt_defense -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > blast.outfmt6
#Switch query and search paths for reciprocal search
tblastn -query JP.defense_response.fasta -db ~/../../scratch/projects/illorens/Motif_search/NINbe/blast_db/${genome} -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > blast_reciprocal.outfmt6

#Output end status message
echo "Finished reciprocal BLAST!"

##Input query blast results file
queryPath="blast.outfmt6"
#Input DB reciprocal blast results file
dbPath="blast_reciprocal.outfmt6"

#Usage ex: bash findRBH.sh blast.outfmt6 blast_reciprocal.outfmt6
#Final output files
outFileRBH=${out}.blast_RBH.txt
outFileSummary=${out}.blast_RBH_summary.txt
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

#Convert the output of RBH into a bed file. 
awk -F','  'NR>1{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' ${out}.blast_RBH.txt |sort -k1,2 -k7,7n| \
awk '{if ( $7 > $8 ) {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""-"} else {print $1"\t"$7-1"\t"$8"\t"$2"\t"$9"_"$10"\t""+"}}' | \
awk '{OFS="\t"; if ($6=="+") {print} else {print $1,$3,$2,$4,$5,$6}}' > ${out}.RBH.bed
#

#merge all the hits for each chromosome. -d needs to be set to overlap the whole gene. 

bedtools merge -i ${Basename}.RBH.bed  -d 5000 -c 4,5,6 -o distinct,collapse,distinct > ${Basename}.RBH.gene.bed
#
##To make exons for new peptides I need to extract the fasta files and then merge them somehow. use seqkit
#
##Make a chr.sizes file for each genome!
#
cut -f 1,2 ~/../../scratch/projects/illorens/data/genomes_available/${genome}.fai > ${Basename}.chr.sizes 
###use bedtools to extract the whole gene and 2.5 kb of the promoter
#
bedtools slop -i ${Basename}.RBH.gene.bed -g ${Basename}.chr.sizes -l 2500 -r 0 -s > ${Basename}.gene.prom.bed
##
###use bedtools to extract the fasta file containinig promoter and gene. 
bedtools getfasta -fi ~/../../scratch/projects/illorens/data/genomes_available/${Basegenome} -bed ${Basename}.gene.prom.bed -s -fullHeader > ${Basename}.gene_2.5kbprom.fasta
bedtools getfasta -fi ~/../../scratch/projects/illorens/data/genomes_available/${Basegenome} -bed ${Basename}.RBH.gene.bed -s -fullHeader > ${Basename}.gene.fasta

