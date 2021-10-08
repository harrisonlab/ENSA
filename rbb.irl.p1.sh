#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=himem
#SBATCH --mem=100G    
#SBATCH --cpus-per-task=30

#sometimes mem won't be enough so you also need to adjust
export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate bedtools_env

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/ #The folder where files are localized, adapt to your needs.

#example:
#sbatch ./scripts/rbb.irl.p1.sh ~/data/genomes_key_test.txt  ~/../../scratch/projects/illorens/Motif_search/NINbe/NIN.test/ninnlp.targets.test.fasta NIN.test

#Requirements:

GENOME_LOC=$1 # A *.txt file containing the key and genome file values in FULL PATH
TARGET=$2 # A fasta file containing the target protein sequences for blast FULL PATH
GENE=$3 #YUCCA| LBD16 |RPG

#A blast_db pre-made for each query genome. To make a blast db for a particular genome type: makeblastsb -in $genome -dbtype nucl -out ${genome}

cd ${DATA}/${GENE}

#make protein blast db

makeblastdb -in ${TARGET} -dbtype prot -out ${GENE}
#the blas_db for the genomes was done and its localised in: ~/../../scratch/projects/illorens/Motif_search/NINbe/blast_db/

cat ${GENOME_LOC} |while read output genome;

do
mkdir ${output}
echo ${output}
cd ${output}

out=`basename ${output}`
Basename=$(echo $output)
Basegenome=$(echo $genome)
#This part was mostly taken from:
#https://morphoscape.wordpress.com/2020/08/18/reciprocal-best-hits-blast-rbhb/

#Usage: bash runRBLAST.sh PATH/TO/QUERY/FILE PATH/TO/DB/FILE PATH/TO/OUTPUTS

#Output start status message
echo "Beginning reciprocal BLAST..."

#Use blastp to search a database
blastx -query ~/../../scratch/projects/illorens/data/genomes_available/${genome} -db ../${GENE} -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 30 > blast.outfmt6
#Switch query and search paths for reciprocal search
tblastn -query ${TARGET} -db ~/../../scratch/projects/illorens/Motif_search/NINbe/blast_db/${genome} -max_target_seqs 1 -outfmt 6 -evalue 1e-3  > blast_reciprocal.outfmt6

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

bedtools merge -i ${Basename}.RBH.bed  -d 1000 -c 4,5,6 -o distinct,collapse,distinct > ${Basename}.RBH.gene.bed
#
##Make a chr.sizes file for each genome!
# make sure you have an index for the genome. samtools faidx 
cut -f 1,2 ~/../../scratch/projects/illorens/data/genomes_available/${genome}.fai > ${Basename}.chr.sizes 
###use bedtools to extract the whole gene and 3 kb of the promoter
#
bedtools slop -i ${Basename}.RBH.gene.bed -g ${Basename}.chr.sizes -l 5000 -r 0 -s > ${Basename}.tmp.gene.prom.bed
##
#repeat bedtools merge to fuse those exons that are more than 3000 bp apart
bedtools merge -i ${Basename}.tmp.gene.prom.bed  -c 4,5,6 -o distinct,collapse,distinct > ${Basename}.gene.prom.bed

###use bedtools to extract the fasta file containinig promoter and gene. 
bedtools getfasta -fi ~/../../scratch/projects/illorens/data/genomes_available/${Basegenome} -bed ${Basename}.gene.prom.bed -s -fullHeader > ${Basename}.gene_5kbprom.fasta

#I shouldn't be needing this one if I'm gonna extract the gene using seqkit.
#bedtools getfasta -fi ~/../../scratch/projects/illorens/data/genomes_available/${Basegenome} -bed ${Basename}.RBH.gene.bed -s -fullHeader > ${Basename}.gene.fasta

###once I had the promoters with coding sequence I'm using seqkit to extract only fractions of promoter sequences
seqkit subseq -r 1:5500 ${Basename}.gene_5kbprom.fasta > ${Basename}_5kbprom.0.5cds.fasta

# use seqkit to extract only the gene part but keep the fasta header annotation. This should be
# used to make the blastdb for blasting against proteomes. 
seqkit subseq -r -5000:-1 ${Basename}.gene_5kbprom.fasta > ${Basename}_gene.fasta


cd ..

done

conda deactivate
