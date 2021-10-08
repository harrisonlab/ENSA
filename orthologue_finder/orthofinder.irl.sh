#!/usr/bin/env bash

#SBATCH --partition=himem
#SBATCH --mem=100G
#SBATCH --cpus-per-task=30

ulimit -Sn
ulimit -Hn
ulimit -n 4096
ulimit -Sn
export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate orthofinder_env

#export DATA=../../scratch/projects/illorens/Motif_search/NINbe/proteomes/slproteomes
export DATA=../../scratch/projects/illorens/phylogenomics/proteomes/slproteomes

cd ${DATA}
#cp -r ${DATA} ~/../../tmp/slproteomes

#cd ~/../../tmp/

#orthofinder -b slproteomes/OrthoFinder/Results_Jun24/WorkingDirectory  -a 15 -t 34
#orthofinder -f rosales/  -a 10 -t 20
#orthofinder -b rosales/OrthoFinder/Results_Jul02/WorkingDirectory -f rosales/rosales_added -a 10 -t 30
#orthofinder -b rosales/OrthoFinder/Results_Jul02/WorkingDirectory/OrthoFinder/Results_Jul13/WorkingDirectory -f rosales/rosales_added/rosales_added_2 -a 10 -t 20
#mv  ~/../../tmp/slproteomes/ ${DATA}
#orthofinder -f orthofinder -a 10 -t 30

#orthofinder -b orthofinder/OrthoFinder/Results_Jul26/WorkingDirectory -f orthofinder/denovo -a 10 -t 30
#
#orthofinder -b orthofinder/OrthoFinder/Results_Jul26/WorkingDirectory -f orthofinder/toadd  -t 27 -a 10

# it seems one needs to run it in two parts. One for the blasting and orthogroup reconstruction and the otherone for the tree analysis.

#orthofinder -fg orthofinder/OrthoFinder/Results_Jul26/WorkingDirectory/OrthoFinder/Results_Aug10  -a 10 -t 27
#orthofinder -fg orthofinder/OrthoFinder/Results_Jul26/WorkingDirectory/OrthoFinder/Results_Jul29_1  -a 10 -t 27
#orthofinder -fg orthofinder/OrthoFinder/Results_Jul26/WorkingDirectory/OrthoFinder/Results_Aug12  -a 10 -t 27

orthofinder -b orthofinder/OrthoFinder/Results_Jul26/WorkingDirectory -f orthofinder/toadd  -t 27 -a 10

conda deactivate
