#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=48G
#SBATCH --cpus-per-task=8



export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate brakerenv


export DATA=../../projects/ensa/plants/D_glom/bam

cd ${DATA}


wd=braker_restart
oldDir=braker

if [ -d $wd ]; then
    rm -r $wd
fi

if [ ! -d $oldDir ] ; then
  echo "ERROR: Directory (with contents) of old BRAKER run $oldDir does not exist"
  
else
    species=$(cat $oldDir/braker.log | perl -ne 'if(m/AUGUSTUS parameter set with name ([^.]+)\./){print $1;}')
    ( time braker.pl --genome=GCA_003255025.1_ASM325502v1_genomic_simpleheader.fna \
    --hints=$oldDir/hintsfile.gff --skipAllTraining --species=$species \
    --etpmode --softmasking --GENEMARK_PATH=/home/illorens/bin/gmes_linux_64 \
    --makehub --email=Ivan.Llorens@niab.com --workingdir=$wd --cores 8 ) &> braker_restart.log
fi



#braker.pl --genome GCA_003255025.1_ASM325502v1_genomic_simpleheader.fna \
 #--bam SRR6384561.sam.bam,SRR6384562.sam.bam,SRR6384565.sam.bam,SRR6384566.sam.bam,SRR6384567.sam.bam,SRR6384568.sam.bam \
 #--softmasking --GENEMARK_PATH=/home/illorens/bin/gmes_linux_64 --cores 8 --UTR=on --makehub --email=Ivan.Llorens@niab.com


 conda deactivate
 exit


