#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=70G
#SBATCH --cpus-per-task=30

#Use blastp to search a database
genome="Fragaria_vesca_v4.0.a1.ns.fasta"
out="Mt_Defense"

Basename=$(echo $out)
Basegenome=$(echo $genome)


blastp -query ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -db Mt_defense -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > p.blast.outfmt6
blastp -query JP.defense_response.fasta -db ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > p.blast_reciprocal.outfmt6


#Output end status message
echo "Finished reciprocal BLAST!"

##Input query blast results file
queryPath="p.blast.outfmt6"
#Input DB reciprocal blast results file
dbPath="p.blast_reciprocal.outfmt6"

#Usage ex: bash findRBH.sh blast.outfmt6 blast_reciprocal.outfmt6
#Final output files
outFileRBH=${out}.p.blast_RBH.txt
outFileSummary=${out}.p.blast_RBH_summary.txt
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


# get the proteins 
#grep "FvH4_4g09950.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
#grep "FvH4_4g19120.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
#grep "FvH4_4g22100.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
#grep "FvH4_4g25110.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
#grep "FvH4_4g30640.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
#grep "FvH4_2g40300.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
#grep "FvH4_2g39360.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
#grep "FvH4_3g07510.1" ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/Fraves.sl.proteome.fasta -A 1 >> ~/data/JP_blast/MtFv.defense.fasta
