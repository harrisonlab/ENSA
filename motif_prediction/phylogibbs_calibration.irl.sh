#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=10G
#SBATCH --cpus-per-task=12


export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate phyloenv

export PHYLOGIBS=/home/illorens/bin/phylogibbs-mp-2.0-linux64/program



t_coffee test4.fasta -mode fmcoffee
t_coffee test4.fasta 
t_coffee -seq test4.fasta -method promo_pair@EP@GOP-40@GEP0 -extend_seq

#I did three different alignments That I'm gonna use as input in phylogibbs. 

#compare between two alignments
t_coffee -other_pg aln_compare -al1 b30.aln -al2 p350.aln
# convert to fasta

t_coffee -other_pg seq_reformat -in test4.aln -output fasta_aln > test4_pr.fasta.aln
t_coffee -other_pg seq_reformat -in test4.tc.aln -output fasta_aln > test4_tc.fasta.aln
t_coffee -other_pg seq_reformat -in test4.fm.aln -output fasta_aln > test4_fm.fasta.aln

#Run phylogibbs 3 times for each alignment

for i in {1..3}
do
    for x in "pr" "fm" "tc"
    do
    ${PHYLOGIBS}/phylogibbs-mp -D 1 -F test4.fasta -l 500,100 -o test_out_${x}_${i}  -n 10,5 -L  "(Datisca:0.33740089175008314,(((Lotus:0.017147942224426282,Medicago:0.017147942224426282):0.04071592087814846,Vigna:0.05786386310257474):0.051183659423997385,Phaseolus:0.10904752252657213):0.33740089175008314);" test4_${x}.fasta.aln

done
done

