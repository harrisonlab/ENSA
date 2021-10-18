#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=6G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate testenv 

#Script for trimming and run fastqc for QC of RNAseq data. 
#script searchs for all fq files in each folder, runs FASTQC before trimming.
#FASTQC results go to an OUTDIR named by the date. 
#After that, it uses bbduk for trimming creating a new file *.clean.*.fq.gz for the fwd and reverse sample. 
#FASTQC is run again on the *clean* samples. 

export DATA=~/../../projects/ensa/plants/RNAseq/raw_data

cd ${DATA}


for i in ./*/
do

f=`basename $i`
echo $f

cd $i

#Run FASTQ before trimming and aligning

DATE=fastqc_results_${f}$(date +%y%m%d)
mkdir ${DATE}
fastqc --threads 20 ${f}_1.fq.gz \
${f}_2.fq.gz --outdir ${DATE}

#trim 

bbduk.sh  in1=${f}_1.fq.gz in2=${f}_2.fq.gz \
out1=${f}.clean_1.fq.gz out2=${f}.clean_2.fq.gz \
ref=~/bin/bbmap/resources/adapters.fa k=23 ktrim=r useshortkmers=t mink=11 qtrim=r trimq=10 minlength=20 ftl=15 ftr=73 t=12


#Run FASTQ on trimmed samples

echo "Run FastQC"

fastqc --threads 20 ${f}.clean_1.fq.gz \
${f}.clean_2.fq.gz --outdir ${DATE}

cd ..
done

conda deactivate


