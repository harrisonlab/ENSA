#!/usr/bin/env bash 


#SBATCH --partition=long
#SBATCH --mem=50G
#SBATCH --cpus-per-task=30


d=$1

export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate maskingenv  

export DATA=~/../../projects/ensa/plants/final_assemblies_080920

cp -r ${DATA}/${d}/ ~/../../tmp/

cd ~/../../tmp/${d}/


BuildDatabase -name ${d}.DB -engine rmblast *.fasta

echo "database built IRL"
RepeatModeler -database ${d}.DB -engine ncbi -pa 30

echo "RepeatModeler done IRL"
# I had an error because some databases were not included during the installation 
#had to install them manually and run RepeatClassifier manually using the following parameters

RepeatClassifier -pa 30  -consensi RM_*/consensi.fa -stockholm RM_*/families.stk

ln -s RM_*/consensi.fa.classified

echo "linking consensi.fa.classified"
RepeatMasker -pa 30 -xsmall -gff -lib consensi.fa.classified *.fasta

mv  ~/../../tmp/${d} ${DATA}/output_masker
conda deactivate 
exit

