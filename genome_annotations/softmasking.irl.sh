#!/usr/bin/env bash 


#SBATCH --partition=long
#SBATCH --mem=70G
#SBATCH --cpus-per-task=30

#Script to mask a genome $d. It uses repeat Modeler and repeat Masker to do so. The output is a softmasked genome. 
# The settings can be modified to get a hardmasked genome. However it is recommended to use a softmasked one for annotation. 

d=$1

export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate masking_env2 

export DATA=~/../../projects/ensa/plants/final_assemblies_080920

cp -r ${DATA}/${d}/ ~/../../tmp/

cd ~/../../tmp/${d}/


BuildDatabase -name ${d}.DB -engine ncbi *.fasta

echo "database built IRL"
RepeatModeler -database ${d}.DB -engine ncbi -pa 30

echo "RepeatModeler done IRL"
# Sometimes you can have an error due to some databases not being included during the installation 
#had to install them manually and run RepeatClassifier manually using the following parameters

{
    if [ ! -f RM_*/consensi.fa.classified ]
 then 
    RepeatClassifier  -consensi RM_*/consensi.fa -stockholm RM_*/families.stk
fi
}


ln -s RM_*/consensi.fa.classified
echo "linking consensi.fa.classified"
RepeatMasker -pa 30 -xsmall -gff -lib consensi.fa.classified *.fasta

mv  ~/../../tmp/${d} ${DATA}/output_masker
conda deactivate 
exit

