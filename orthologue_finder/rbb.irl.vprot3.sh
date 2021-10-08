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


cat ${GENOME_LOC} |while read key proteome;

do

#sbatch ./scripts/rbb.irl.vprot3.sh ~/../../scratch/projects/illorens/Motif_search/NINbe/proteomes/prot_workingdataset.txt YUCCA

cd ${key}
echo ${key}
Basename=$(echo $key)
# 
#Convert promoter into sl promoter
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${Basename}.gene_5kbprom.fasta | sed "s/>/>${Basename}_/" > ${Basename}.sl.prom.fasta

#makeblastdb -in ${Basename}.gene_3kbprom.fasta -dbtype nucl -out ${Basename}_nucl
makeblastdb -in ${Basename}_gene.fasta -dbtype nucl -out ${Basename}_nucl

tblastn -query ../../proteomes/${proteome} -db ${Basename}_nucl -max_target_seqs 1 -outfmt 6 -evalue 1e-3  > ${Basename}.prot.blast.outfmt6
#Switch query and search paths for reciprocal search
#blastx -query ${Basename}.gene.fasta -db ../../proteomes/${key} -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 20 > ${Basename}.prot.blast_reciprocal.outfmt6
# Try making blast to Datglo.gene_2.5kbprom.fasta instead so that annotations match later on
blastx -query ${Basename}.gene_5kbprom.fasta -db ../../proteomes/${key} -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > ${Basename}.prot.blast_reciprocal.outfmt6

#Output end status message

##Input query blast results file
queryPath="${Basename}.prot.blast.outfmt6"
#Input DB reciprocal blast results file
dbPath="${Basename}.prot.blast_reciprocal.outfmt6"

#Usage ex: bash findRBH.sh blast.outfmt6 blast_reciprocal.outfmt6
#Final output files

outFileRBH=${Basename}.prot.blast_RBH.txt
outFileSummary=${Basename}.prot.blast_RBH_summary.txt
#Add headers to output RBH files
echo queryHit$'\t'dbHit > $outFileRBH

#,percentage,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore"

echo "queryHits,dbHits,bestHits" > $outFileSummary
#Output start status message
echo "Recording RBH..."
#Loop over query blast results
while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
do
#Determine RBH to DB blast results
if grep -q "$f2"$'\t'"$f1"$'\t' $dbPath; then 
#echo "$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$f10,$f11,$f12" >> $outFileRBH
echo $f1$'\t'$f2 >> $outFileRBH

fi
done < $queryPath
#Output summary of RBH
queryHits=$(wc -l "$queryPath" | cut -d ' ' -f 1)
dbHits=$(wc -l "$dbPath" | cut -d ' ' -f 1)
bestHits=$(($(wc -l "$outFileRBH" | cut -d ' ' -f 1)-1))

echo "$queryHits","$dbHits","$bestHits" >> $outFileSummary
#Output end status message
echo "Finished recording RBH!"

#add blast results to a single file

sed  1d ${key}.prot.blast_RBH.txt > prot.blast_RBH.tmp.txt
awk -v var=${key} '{print var"\t"$0}' prot.blast_RBH.tmp.txt |uniq >> ~/../../scratch/projects/illorens/Motif_search/NINbe/${GENE}/${GENE}.prot.blast.anno.txt

#filter out genes with low scores but keep everything even if its not reciprocal. 
awk '$3>=95' ${key}.prot.blast.outfmt6 |sort -u -k1,2  > prot.blast_RBH.tmp.txt
awk -v var=${key} '{print var"\t"$1"\t"$2}' prot.blast_RBH.tmp.txt |uniq >> ~/../../scratch/projects/illorens/Motif_search/NINbe/${GENE}/${GENE}.summary2.blast.txt
rm prot.blast_RBH.tmp.txt

cd ..
done

#retrieve the aminoacid sequences 
cat ${GENE}.summary2.blast.txt |while read key protein promoter

do
echo $key
cd ${key}
grep ${protein} ../../proteomes/${key}.sl.proteome.fasta -A 1 | sed "s/>/>${key}_/"  >> ../${GENE}.proteins.fasta
cd ..
done

#do a blast search against blast db to remove poor candidates for tree building. 

#blastp –db nr –query ${GENE}.proteins.fasta -out ${GENE}.blast.results.out -remote -max_target_seqs 1 -outfmt 6 -evalue 1e-3 

#uniprot  blast to remove genes 
blastp -db ~/../../scratch/projects/illorens/Motif_search/NINbe/blast_db/uniprot -query  ${GENE}.proteins.fasta -max_target_seqs 1 -outfmt 6 > ${GENE}.uniprot.blast.out


conda deactivate

#manually look for the desired hits and select them by: 
#grep "LBD" LBD16_2.proteins.3.blast.out | awk '{print $1}' > LBD16_filtered.txt
#cat LBD16_filtered.txt|while read protein ; do grep ${protein} LBD16_2.proteins.3.fasta -A 1 >> LBD16_filtered.aa.fasta; done
#run iqtree on this! 
