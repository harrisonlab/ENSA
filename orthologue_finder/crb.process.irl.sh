#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=20G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate crb-blastenv

export DATA=~/../../projects/ensa/plants/

cd ${DATA}

#GENOME_LOC=$1
QUERY_LOC=$1
SCORE=$2
OUTPUT_L=$3


cat ${QUERY_LOC}|while read  tf genes
do

echo $genes

#cat ${GENOME_LOC} |while read output genome;
#do

#generate a genome size list

#cat $genome | \
#awk -F " " '$1 ~ ">" {if (NR > 1) {print c;} c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }'| \
#awk '{print $1, $NF}' > crb-blast_out/${output}.txt 

#done


#Annotate  and extract promoters from known species

cat ${OUTPUT_L} |while read output target;

do


awk -v a=$SCORE -v b=$output -v c=$target, -v d=$tf 'BEGIN {$3==${SCORE} && substr($2,1,7) ~ /${output}/' ${target}_into_${tf}_*  \
|sort -k2,2 -k9,9n |awk '{if ( $9 > $10 ) {print $1"\t"$7"\t" $8"\t""-""\t"$2"_"$9":"$10} \
else {print $1"\t"$7"\t" $8"\t""+""\t"$2"_"$9":"$10}}}' > ${output}_${tf}.bed


done

done

awk -v a=$x -v b=$y -v c="$text" 'BEGIN {ans=a+b; print c " " ans}'