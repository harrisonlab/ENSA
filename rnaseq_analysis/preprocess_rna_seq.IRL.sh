#!/usr/bin/env bash

#SBATCH --partition=short
#SBATCH --time=0-03:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 



#Preprocess rnaseq data downloaded from SRA

#Run FASTQ before trimming and aligning


#fastqc --threads 12 ../../projects/ensa/plants/D_glom/rna-seq/SRR638456* --outdir ./data/fastqc_results/


#trim 


R1S=(../../../projects/ensa/plants/RNAseq/Casgla/SRR5*)
x=0 

for f in ${R1S[@]};
do

echo ${f}

bbduk.sh  in=${f} out=${f::-6}.clean.fastq ref=../bin/bbmap/resources/adapters.fa k=23 ktrim=r useshortkmers=t mink=11 qtrim=r trimq=10 minlength=20 ftl=15 ftr=73 t=20


x=$(expr $x + 1);
done


#Run FASTQ on trimmed samples

echo "Run FastQC"

fastqc --threads 20 ../../../projects/ensa/plants/RNAseq/Casgla/*clean.fastq --outdir ../data/fastqc_results/

conda deactivate





