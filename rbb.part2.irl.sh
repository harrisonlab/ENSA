#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate crb-blastenv

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/LBD16



#GENOME_LOC=$1  #full path
#GENE=$2 #YUCCA, LBD16 etc
cd ${DATA}
#cd ${DATA}/${GENE}
#cat ${GENOME_LOC} |while read out genome;

for i in ./*/
do
echo $i
output=`basename ${i}`
cd ${i}

#do
#output=`basename ${out}`
#echo ${output}
#cd ${output}

#https://morphoscape.wordpress.com/2020/08/18/reciprocal-best-hits-blast-rbhb/

##Input query blast results file
queryPath="blast.outfmt6"
#Input DB reciprocal blast results file
dbPath="blast_reciprocal.outfmt6"

#Usage ex: bash findRBH.sh blast.outfmt6 blast_reciprocal.outfmt6
#Final output files
outFileRBH=${output}.blast_RBH.txt
outFileSummary=${output}.blast_RBH_summary.txt
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

#
#awk -F','  'NR>1{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' *.blast_RBH.txt |sort -k1,2 -k7,7n| \
#awk '{if ( $7 > $8 ) {print $1"\t"$7"\t" $8"\t""-""\t"$2"\t"$9"\t"$10} else {print $1"\t"$7"\t" $8"\t""+""\t"$2"\t"$9"\t"$10}}' > ${output}.RBH.bed

