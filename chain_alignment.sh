#!/bin/bash
#!/usr/bin/env bash

#SBATCH --partition=long
#SBATCH --mem=30G
#SBATCH --cpus-per-task=20


export MYCONDAPATH=/home/illorens/miniconda3

source ${MYCONDAPATH}/bin/activate motifenv

export DATA=~/../../scratch/projects/illorens/Motif_search/NINbe/NIN2/conservation/
cd $DATA



#
#Then, to blastz everything onto everything, in theory we could issue this command:

#lastz alignment


mkdir lav/Ceathy
mkdir lav/Cermon
mkdir lav/Colpar
mkdir lav/Coluli
mkdir lav/Datglo
mkdir lav/Distri
mkdir lav/Drydru
mkdir lav/Elaang
mkdir lav/Medtru
mkdir lav/Parand
mkdir lav/Pruavi
mkdir lav/Prumum
mkdir lav/Pruper
mkdir lav/Purtri
mkdir lav/Sagthe
mkdir lav/Zizjuj



# make a separate file for each contig in Datglo but keep the one with the two for the query. 

for i in *.fa; do faToTwoBit $i `echo $i | sed -e s/.fa/.2bit/`; done
for i in *.2bit; do twoBitInfo $i `echo $i | sed -e s/.2bit/.chr.sizes/`; done

###

#Mask medtru scaffold


for j in *.2bit; do  lastz  Lotjap.scaffold.fasta.2bit $j > lav/Lotjap/`basename Lotjap.scaffold.fasta.2bit`-`basename $j`.lav; done 
for j in *.2bit; do  lastz  Ceathy.scaffold.fasta.2bit $j > lav/Ceathy/`basename Ceathy.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Cermon.scaffold.fasta.2bit $j > lav/Cermon/`basename Cermon.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Colpar.scaffold.fasta.2bit $j > lav/Colpar/`basename Colpar.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Coluli.scaffold.fasta.2bit $j > lav/Coluli/`basename Coluli.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Distri.scaffold.fasta.2bit $j > lav/Distri/`basename Distri.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Drydru.scaffold.fasta.2bit $j > lav/Drydru/`basename Drydru.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Elaang.scaffold.fasta.2bit $j > lav/Elaang/`basename Elaang.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Parand.scaffold.fasta.2bit $j > lav/Parand/`basename Parand.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Pruavi.scaffold.fasta.2bit $j > lav/Pruavi/`basename Pruavi.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Datglo_QANY01003393.1.2bit $j > lav/Datglo/`basename Datglo_QANY01003393.1.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Datglo_QANY01009882.1.2bit $j > lav/Datglo/`basename Datglo_QANY01009882.1.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Prumum.scaffold.fasta.2bit $j  > lav/Prumum/`basename Prumum.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Pruper.scaffold.fasta.2bit $j  > lav/Pruper/`basename Pruper.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Purtri.scaffold.fasta.2bit $j  > lav/Purtri/`basename Purtri.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Sagthe.scaffold.fasta.2bit $j  > lav/Sagthe/`basename Sagthe.scaffold.fasta.2bit`-`basename $j`.lav; done
for j in *.2bit; do  lastz  Zizjuj.scaffold.fasta.2bit $j  > lav/Zizjuj/`basename Zizjuj.scaffold.fasta.2bit`-`basename $j`.lav; done

###
mkdir Lotjap/LotCeathy
mkdir Lotjap/LotCermon
mkdir Lotjap/LotColpar
mkdir Lotjap/LotColuli
mkdir Lotjap/LotDatglo
mkdir Lotjap/LotDistri
mkdir Lotjap/LotDrydru
mkdir Lotjap/LotElaang
mkdir Lotjap/LotMedtru
mkdir Lotjap/LotParand
mkdir Lotjap/LotPruavi
mkdir Lotjap/LotPrumum
mkdir Lotjap/LotPruper
mkdir Lotjap/LotPurtri
mkdir Lotjap/LotSagthe
mkdir Lotjap/LotZizjuj


#convert lav files to psl. 
for i in *.lav; do echo $i; lavToPsl $i `basename $i .lav`.psl; done; 
   

#Chaining:

#Chaininng for Lotjap fix to include the folder!!! 
  

axtChain Lotjap.scaffold.fasta.2bit-Ceathy.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Ceathy.scaffold.fasta.2bit   Lotjap.Ceathy.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Cermon.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Cermon.scaffold.fasta.2bit   Lotjap.Cermon.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Colpar.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Colpar.scaffold.fasta.2bit   Lotjap.Colpar.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Coluli.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Coluli.scaffold.fasta.2bit   Lotjap.Coluli.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Distri.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Distri.scaffold.fasta.2bit   Lotjap.Distri.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Drydru.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Drydru.scaffold.fasta.2bit   Lotjap.Drydru.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Elaang.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Elaang.scaffold.fasta.2bit   Lotjap.Elaang.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Lotjap.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Lotjap.scaffold.fasta.2bit   Lotjap.Lotjap.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Parand.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Parand.scaffold.fasta.2bit   Lotjap.Parand.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Pruavi.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Pruavi.scaffold.fasta.2bit   Lotjap.Pruavi.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Prumum.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Prumum.scaffold.fasta.2bit   Lotjap.Prumum.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Pruper.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Pruper.scaffold.fasta.2bit   Lotjap.Pruper.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Purtri.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Purtri.scaffold.fasta.2bit   Lotjap.Purtri.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Sagthe.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Sagthe.scaffold.fasta.2bit   Lotjap.Sagthe.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Zizjuj.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Zizjuj.scaffold.fasta.2bit   Lotjap.Zizjuj.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Datglo_QANY01003393.1.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Datglo_QANY01003393.1.2bit   Lotjap.DatgloQANY01003393.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Datglo_QANY01009882.1.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Datglo_QANY01009882.1.2bit   Lotjap.DatgloQANY01009882.chain -linearGap=loose -psl

#made a directory called chainMerge in which I moved all the independent folders containing all the independent chain files 
for i in ../chainMerge/*/; do cd $i; chainMergeSort *.chain | chainSplit chainMerge stdin -lump=50; cd ..; done
for i in ../chainMerge/*/; do  cd $i; ls; cd chainMerge; chainSort 017.chain srt.chain; cd ../..; done
## try chainPreNet 

#Netting
chainNet ./LotLotjap/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ./LotLotjap/Lotjap.Lotjap.net /dev/null  
chainNet ./LotZizjuj/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Zizjuj.scaffold.fasta.chr.sizes ./LotZizjuj/Lotjap.Zizjuj.net /dev/null 
chainNet ./LotSagthe/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Sagthe.scaffold.fasta.chr.sizes ./LotSagthe/Lotjap.Sagthe.net /dev/null 
chainNet ./LotPurtri/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Purtri.scaffold.fasta.chr.sizes ./LotPurtri/Lotjap.Purtri.net /dev/null 
chainNet ./LotPruper/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Pruper.scaffold.fasta.chr.sizes ./LotPruper/Lotjap.Pruper.net /dev/null 
chainNet ./LotPrumum/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Prumum.scaffold.fasta.chr.sizes ./LotPrumum/Lotjap.Prumum.net /dev/null 
chainNet ./LotPruavi/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Pruavi.scaffold.fasta.chr.sizes ./LotPruavi/Lotjap.Pruavi.net /dev/null 
chainNet ./LotParand/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Parand.scaffold.fasta.chr.sizes ./LotParand/Lotjap.Parand.net /dev/null 
chainNet ./LotElaang/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Elaang.scaffold.fasta.chr.sizes ./LotElaang/Lotjap.Elaang.net /dev/null 
chainNet ./LotDrydru/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Drydru.scaffold.fasta.chr.sizes ./LotDrydru/Lotjap.Drydru.net /dev/null 
chainNet ./LotDistri/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Distri.scaffold.fasta.chr.sizes ./LotDistri/Lotjap.Distri.net /dev/null 
chainNet ./LotDatglo/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Datglo.scaffold.fasta.chr.sizes ./LotDatglo/Lotjap.Datglo.net /dev/null 
chainNet ./LotColuli/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Coluli.scaffold.fasta.chr.sizes ./LotColuli/Lotjap.Coluli.net /dev/null 
chainNet ./LotColpar/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Colpar.scaffold.fasta.chr.sizes ./LotColpar/Lotjap.Colpar.net /dev/null 
chainNet ./LotCermon/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Cermon.scaffold.fasta.chr.sizes ./LotCermon/Lotjap.Cermon.net /dev/null 
chainNet ./LotCeathy/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Ceathy.scaffold.fasta.chr.sizes ./LotCeathy/Lotjap.Ceathy.net /dev/null 


netChainSubset ./LotLotjap/Lotjap.Lotjap.net ./LotLotjap/chainMerge/srt.chain ./LotLotjap/Lotjap.Lotjap.liftOver 
netChainSubset ./LotZizjuj/Lotjap.Zizjuj.net ./LotZizjuj/chainMerge/srt.chain ./LotZizjuj/Lotjap.Zizjuj.liftOver 
netChainSubset ./LotSagthe/Lotjap.Sagthe.net ./LotSagthe/chainMerge/srt.chain ./LotSagthe/Lotjap.Sagthe.liftOver 
netChainSubset ./LotPurtri/Lotjap.Purtri.net ./LotPurtri/chainMerge/srt.chain ./LotPurtri/Lotjap.Purtri.liftOver 
netChainSubset ./LotPruper/Lotjap.Pruper.net ./LotPruper/chainMerge/srt.chain ./LotPruper/Lotjap.Pruper.liftOver 
netChainSubset ./LotPrumum/Lotjap.Prumum.net ./LotPrumum/chainMerge/srt.chain ./LotPrumum/Lotjap.Prumum.liftOver 
netChainSubset ./LotPruavi/Lotjap.Pruavi.net ./LotPruavi/chainMerge/srt.chain ./LotPruavi/Lotjap.Pruavi.liftOver 
netChainSubset ./LotParand/Lotjap.Parand.net ./LotParand/chainMerge/srt.chain ./LotParand/Lotjap.Parand.liftOver 
netChainSubset ./LotElaang/Lotjap.Elaang.net ./LotElaang/chainMerge/srt.chain ./LotElaang/Lotjap.Elaang.liftOver 
netChainSubset ./LotDrydru/Lotjap.Drydru.net ./LotDrydru/chainMerge/srt.chain ./LotDrydru/Lotjap.Drydru.liftOver 
netChainSubset ./LotDistri/Lotjap.Distri.net ./LotDistri/chainMerge/srt.chain ./LotDistri/Lotjap.Distri.liftOver 
netChainSubset ./LotDatglo/Lotjap.Datglo.net ./LotDatglo/chainMerge/srt.chain ./LotDatglo/Lotjap.Datglo.liftOver 
netChainSubset ./LotColuli/Lotjap.Coluli.net ./LotColuli/chainMerge/srt.chain ./LotColuli/Lotjap.Coluli.liftOver 
netChainSubset ./LotColpar/Lotjap.Colpar.net ./LotColpar/chainMerge/srt.chain ./LotColpar/Lotjap.Colpar.liftOver 
netChainSubset ./LotCermon/Lotjap.Cermon.net ./LotCermon/chainMerge/srt.chain ./LotCermon/Lotjap.Cermon.liftOver 
netChainSubset ./LotCeathy/Lotjap.Ceathy.net ./LotCeathy/chainMerge/srt.chain ./LotCeathy/Lotjap.Ceathy.liftOver 
netChainSubset ./LotCasgla/Lotjap.Casgla.net ./LotCasgla/chainMerge/srt.chain ./LotCasgla/Lotjap.Casgla.liftOver 
netChainSubset ./LotGlymax/Lotjap.Glymax.net ./LotGlymax/chainMerge/srt.chain ./LotGlymax/Lotjap.Glymax.liftOver 
netChainSubset ./LotLupang/Lotjap.Lupang.net ./LotLupang/chainMerge/srt.chain ./LotLupang/Lotjap.Lupang.liftOver 
netChainSubset ./LotMedtru/Lotjap.Medtru.net ./LotMedtru/chainMerge/srt.chain ./LotMedtru/Lotjap.Medtru.liftOver 



# Remove the lines containing the ## from all the files
# change the chr name for the word chr

for i in ../chainMerge/*/ ; do  cd $i ; sed -i -e 1,6d *.liftOver; sed -i 's/BABK02039267.1/chr/g' *.liftOver; cd ..; done 
for i in ../chainMerge/*/; do 
cd $i 
cp *.liftOver ../
cd ..


#run mapGL.py

mapGL.py ../../../motifs/PACE.bed "(Lotjap:0.4629364527,(Datglo:0.3345050326)93:0.0670095201,(((Cermon:0.0280190209,Purtri:0.0117955977)64:0.0020866462,Drydru:0.0121656747)88:0.0203277333,(Pruavi:0.0367953359,(Pruper:0.0356239808,Prumum:0.0252251633)97:0.0150174236)100:0.0492705180)100:0.1408038104)" Lotjap Datglo Lotjap.Datglo.liftOver Lotjap.Cermon.liftOver Lotjap.Purtri.liftOver Lotjap.Drydru.liftOver Lotjap.Pruper.liftOver Lotjap.Prumum.liftOver Lotjap.Pruavi.liftOver  -v debug -f


#to Do:
#Get Casgla, Parand, Legumes into the analysis!!!!!!!!!
#repeat rbb for these 4 and Lotjap
#extract scaffolds promoters etc
# make a species tree including Parand, and the others 



Casgla  GCA_003255045.1_ASM325504v1_genomic.fna QAOB01002371.1
Lupang  Lupang.fna NC_032010.1
Glymax  Glymax.fna NC_038250.2
# Extract chr from M. truncatula and A. thaliana 
GCA_000219495.2_MedtrA17_4.0_genomic.fna    CM001221.2
GCF_000001735.4_TAIR10.1_genomic.fna    NC_003071.7

awk  '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/../../scratch/projects/illorens/data/genomes_available/GCA_000219495.2_MedtrA17_4.0_genomic.fna  > tmp.fasta
grep CM001221.2 tmp.fasta -A 1  >> Medtru.scaffold.fasta 
rm tmp.fasta

awk  '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/../../scratch/projects/illorens/data/genomes_available/GCF_000001735.4_TAIR10.1_genomic.fna > tmp.fasta
grep NC_003071.7 tmp.fasta -A 1  >> Aratha.scaffold.fasta 
rm tmp.fasta


awk  '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/../../scratch/projects/illorens/data/genomes_available/GCA_003255045.1_ASM325504v1_genomic.fna > tmp.fasta
grep QAOB01002371.1 tmp.fasta -A 1  >> Casgla.scaffold.fasta 
rm tmp.fasta

awk  '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/../../scratch/projects/illorens/data/genomes_available/Lupang.fna > tmp.fasta
grep NC_032010.1 tmp.fasta -A 1  >> Lupang.scaffold.fasta 
rm tmp.fasta

awk  '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/../../scratch/projects/illorens/data/genomes_available/Glymax.fna > tmp.fasta
grep NC_038250.2 tmp.fasta -A 1  >> Glymax.scaffold.fasta 
rm tmp.fasta


#at the mo I'm not including these: 
#Cicer   Cicer.fna   XM_027331609.1?
#Aradur  Aradur.fna

sbatch ./scripts/rbb.irl.v1.2.sh ~/data/genomes_key_legumes09062021.txt ~/../../scratch/projects/illorens/Motif_search/NINbe/NIN2/ninnlp.legume.targets.fasta NIN2
# need to change the blast DB for glymax lupang, cicer, etc. 

#add the corresponding proteomes
Glymax.scaffold.fasta 
Lupang.scaffold.fasta
Casgla.scaffold.fasta

faToTwoBit Glymax.scaffold.fasta Glymax.scaffold.fasta.2bit
faToTwoBit Lupang.scaffold.fasta Lupang.scaffold.fasta.2bit
faToTwoBit Casgla.scaffold.fasta Casgla.scaffold.fasta.2bit
faToTwoBit Aratha.scaffold.fasta Aratha.scaffold.fasta.2bit
faToTwoBit Medtru.scaffold.fasta Medtru.scaffold.fasta.2bit

faToTwoBit Medtru.nomask.fasta Medtru.nomask.2bit
faToTwoBit Lotjap.nomask.fasta Lotjap.nomask.2bit

twoBitInfo Glymax.scaffold.2bit Glymax.scaffold.fasta.chr.sizes
twoBitInfo Lupang.scaffold.2bit Lupang.scaffold.fasta.chr.sizes
twoBitInfo Casgla.scaffold.2bit Casgla.scaffold.fasta.chr.sizes
twoBitInfo Aratha.scaffold.fasta.2bit Aratha.scaffold.fasta.chr.sizes
twoBitInfo Medtru.scaffold.fasta.2bit Medtru.scaffold.fasta.chr.sizes

for j in Aratha.scaffold.fasta.2bit Medtru.scaffold.fasta.2bit; do
lastz Lotjap.scaffold.fasta.2bit $j > lav/Lotjap/`basename Lotjap.scaffold.fasta.2bit`-`basename $j`.lav; done

for j in Casgla.scaffold.fasta.2bit Lupang.scaffold.fasta.2bit Glymax.scaffold.fasta.2bit Medtru.scaffold.fasta.2bit; do
lastz  Lotjap.scaffold.fasta.2bit $j > lav/Lotjap/`basename Lotjap.scaffold.fasta.2bit`-`basename $j`.lav; done

lastz  Lotjap.nomask.2bit Medtru.nomask.2bit > lav/Lotjap/Lotjam.Medtru.nomask.lav




for i in *.lav; do echo $i; lavToPsl $i `basename $i .lav`.psl; done; 

axtChain Lotjap.scaffold.fasta.2bit-Casgla.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Casgla.scaffold.fasta.2bit   Lotjap.Casgla.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Glymax.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Glymax.scaffold.fasta.2bit   Lotjap.Glymax.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Lupang.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Lupang.scaffold.fasta.2bit   Lotjap.Lupang.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Medtru.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Medtru.scaffold.fasta.2bit   Lotjap.Medtru.chain -linearGap=loose -psl
axtChain Lotjap.scaffold.fasta.2bit-Aratha.scaffold.fasta.2bit.psl ../../Lotjap.scaffold.fasta.2bit ../../Aratha.scaffold.fasta.2bit   Lotjap.Aratha.chain -linearGap=loose -psl


axtChain Lotjam.Medtru.nomask.psl ../../Lotjap.nomask.2bit ../../Medtru.nomask.2bit   Lotjap.Medtru.nomask.chain -linearGap=loose -psl


#made a directory called chainMerge in which I moved all the independent folders containing all the independent chain files 
for i in ../chainMerge/LotCasgla/ ../chainMerge/LotGlymax/ ../chainMerge/LotLupang/ ../chainMerge/LotMedtru/; do cd $i; chainMergeSort *.chain | chainSplit chainMerge stdin -lump=50; cd ..; done
for i in ../chainMerge/LotCasgla/ ../chainMerge/LotGlymax/ ../chainMerge/LotLupang/ ../chainMerge/LotMedtru/; do  cd $i; ls; cd chainMerge; chainSort 017.chain srt.chain; cd ../..; done


for i in ../chainMerge/LotMedtru2/ ../chainMerge/LotAratha/; do cd $i; chainMergeSort *.chain | chainSplit chainMerge stdin -lump=50; cd ..; done
for i in ../chainMerge/LotMedtru2/ ../chainMerge/LotAratha/; do  cd $i; ls; cd chainMerge; chainSort 017.chain srt.chain; cd ../..; done
## try chainPreNet 

#Netting
chainNet ./LotCasgla/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Casgla.scaffold.fasta.chr.sizes ./LotCasgla/Lotjap.Casgla.net /dev/null  
chainNet ./LotGlymax/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Glymax.scaffold.fasta.chr.sizes ./LotGlymax/Lotjap.Glymax.net /dev/null 
chainNet ./LotLupang/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Lupang.scaffold.fasta.chr.sizes ./LotLupang/Lotjap.Lupang.net /dev/null 
chainNet ./LotMedtru/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Medtru.scaffold.fasta.chr.sizes ./LotMedtru/Lotjap.Medtru.net /dev/null 

chainNet ./LotAratha/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Aratha.scaffold.fasta.chr.sizes ./LotAratha/Lotjap.Aratha.net /dev/null 
chainNet ./LotMedtru2/chainMerge/srt.chain ../../../chrsizes/Lotjap.scaffold.fasta.chr.sizes ../../../chrsizes/Medtru.scaffold.fasta.chr.sizes ./LotMedtru2/Lotjap.Medtru2.net /dev/null 



netChainSubset ./LotCasgla/Lotjap.Casgla.net ./LotCasgla/chainMerge/srt.chain ./LotCasgla/Lotjap.Casgla.liftOver 
netChainSubset ./LotGlymax/Lotjap.Glymax.net ./LotGlymax/chainMerge/srt.chain ./LotGlymax/Lotjap.Glymax.liftOver 
netChainSubset ./LotLupang/Lotjap.Lupang.net ./LotLupang/chainMerge/srt.chain ./LotLupang/Lotjap.Lupang.liftOver 
netChainSubset ./LotMedtru/Lotjap.Medtru.net ./LotMedtru/chainMerge/srt.chain ./LotMedtru/Lotjap.Medtru.liftOver 

netChainSubset ./LotAratha/Lotjap.Aratha.net ./LotAratha/chainMerge/srt.chain ./LotAratha/Lotjap.Aratha.liftOver 
netChainSubset ./LotMedtru2/Lotjap.Medtru2.net ./LotMedtru2/chainMerge/srt.chain ./LotMedtru2/Lotjap.Medtru.liftOver 


netToAxt ./LotMedtru2/Lotjap.Medtru2.net ./LotMedtru2/chainMerge/srt.chain ../../Lotjap.nomask.2bit ../../Medtru.nomask.2bit >Lotjap.Medtru2.axt

# remove the # and rename query chr with "chr"

for i in ../chainMerge/LotCasgla/ ../chainMerge/LotGlymax/ ../chainMerge/LotLupang/ ../chainMerge/LotMedtru/; do  cd $i ; sed -i -e 1,6d *.liftOver; sed -i 's/BABK02039267.1/chr/g' *.liftOver; cd ..; done

for i in ../chainMerge/LotCasgla/ ../chainMerge/LotGlymax/ ../chainMerge/LotLupang/ ../chainMerge/LotMedtru/; do 
cd $i 
cp *.liftOver ../
cd ..


for i in ../chainMerge/LotAratha/ ../chainMerge/LotMedtru2/; do  cd $i ; sed -i -e 1,6d *.liftOver; sed -i 's/BABK02039267.1/chr/g' *.liftOver; cd ..; done

for i in ../chainMerge/LotAratha/ ../chainMerge/LotMedtru2/; do 
cd $i 
cp *.liftOver ../
cd ..
done


"(Aratha:0.7813262283,((Datglo:0.4548961592,((Parand:0.2806817859,Distri:0.1438661573):0.0463756045[77],(((Cermon:0.0278183444,Purtri:0.0118809233):0.0008765000[57],Drydru:0.0133776651):0.0387403048[100],(Pruavi:0.0346839665,(Pruper:0.0368325950,Prumum:0.0253464966):0.0155857278[98]):0.0450859467[100]):0.1043957985[100]):0.0323152472[57]):0.0228513758[49],(((Medtru:0.3622614990,Glymax:0.5436090869):0.0632934005[36],Lotjap:0.2449400189):0.0879220621[50],Lupang:0.4481162598):0.4096404794[100]):0.0574358257[80],Casgla:0.2162901167)OROOT"

mapGL.py ../../../motifs/PACE.bed \
"(((Datglo:0.4548961592,((Parand:0.2806817859,Distri:0.1438661573):0.0463756045[77],(((Cermon:0.0278183444,Purtri:0.0118809233):0.0008765000[57],Drydru:0.0133776651):0.0387403048[100],(Pruavi:0.0346839665,(Pruper:0.0368325950,Prumum:0.0253464966):0.0155857278[98]):0.0450859467[100]):0.1043957985[100]):0.0323152472[57]):0.0228513758[49],(((Glymax:0.5436090869):0.0632934005[36],Lotjap:0.2449400189):0.0879220621[50],Lupang:0.4481162598):0.4096404794[100]):0.0574358257[80],Casgla:0.2162901167)" \
Lotjap Datglo \
Lotjap.Datglo.liftOver \
Lotjap.Medtru.liftOver \
Lotjap.Aratha.liftOver \
Lotjap.Glymax.liftOver \
Lotjap.Lupang.liftOver \
Lotjap.Casgla.liftOver \
Lotjap.Cermon.liftOver \
Lotjap.Purtri.liftOver \
Lotjap.Drydru.liftOver \
Lotjap.Pruper.liftOver \
Lotjap.Prumum.liftOver \
Lotjap.Pruavi.liftOver \
Lotjap.Parand.liftOver \
Lotjap.Distri.liftOver -v debug -f

mapGL.py ../../../motifs/PACE.bed \
"(Aratha:0.7813262283,((Datglo:0.4548961592,((Parand:0.2806817859,Distri:0.1438661573):0.0463756045[77],(((Cermon:0.0278183444,Purtri:0.0118809233):0.0008765000[57],Drydru:0.0133776651):0.0387403048[100],(Pruavi:0.0346839665,(Pruper:0.0368325950,Prumum:0.0253464966):0.0155857278[98]):0.0450859467[100]):0.1043957985[100]):0.0323152472[57]):0.0228513758[49],(((Medtru:0.3622614990,Glymax:0.5436090869):0.0632934005[36],Lotjap:0.2449400189):0.0879220621[50],Lupang:0.4481162598):0.4096404794[100]):0.0574358257[80],Casgla:0.2162901167))" \
Lotjap Aratha \
Lotjap.Datglo.liftOver \
Lotjap.Medtru.chain \
Lotjap.Aratha.liftOver \
Lotjap.Glymax.liftOver \
Lotjap.Lupang.liftOver \
Lotjap.Cermon.liftOver \
Lotjap.Purtri.liftOver \
Lotjap.Drydru.liftOver \
Lotjap.Pruper.liftOver \
Lotjap.Prumum.liftOver \
Lotjap.Pruavi.liftOver \
Lotjap.Parand.liftOver \
Lotjap.Distri.liftOver -v debug -f

Lotjap.Casgla.liftOver \