
######
###  This is not a script but a series of functions, for loops and pseudocode to manually process some of the data #####
###



# add key to fasta headers and  make promoters sl

for i in ./*/
do 
output=`basename ${i}`
cd $i
#sed "s/>/>${output}_/" ${output}_2.5kbprom.0.5cds.fasta > ${output}.promoter.fasta 
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${output}_2.5kbprom.0.5cds.fasta | sed "s/>/>${output}_/" > ${output}.sl.prom.fasta
cd ..
done

# create blastdb for all the proteomes
cat prot_workingdataset.txt | while read key proteome;
do
makeblastdb -in $proteome -dbtype prot -out $key
done

#convert proteome to single line
cat prot_workingdataset.txt | while read key proteome;
do
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${proteome} > ${key}.sl.proteome.fasta
done


#extract blast list
cat ../proteomes/prot_workingdataset.txt | while read key proteome;
do
echo ${key}
echo ${key} >> YUCCA.prot.blast.all.txt
cat ${key}/${key}.blast_RBH.txt  >> YUCCA.prot.blast.all.txt
done #manually added the proteome *.sl.proteome.fasta for each species to a file. 


cat prot_workingdataset.txt | while read key proteome;
do
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${proteome} > ${key}.sl.proteome.fasta
done


#extract the aa sequences and put them in a file. 

cat ../YUCCA/YUCCA.prot.blast.all.txt | while read key protein genome proteome
do 
echo $key
grep ${protein} ${proteome} -A 1 >> ../YUCCA/YUCCA.Rosales.proteins.fasta
done


#convert promoter file to single line
cat prot_workingdataset.txt | while read key proteome;
do
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${proteome} > ${key}.sl.proteome.fasta
done

awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${proteome} > ${key}.sl.proteome.fasta



#lbd16
#extract blast lists
#promoters
cat ../proteomes/prot_workingdataset.txt | while read key proteome;
do
echo ${key}
echo ${key} >> LBD16.prot.blast.all.txt
cat ${key}/${key}.blast_RBH.txt  >> LBD16.prot.blast.all.txt
done #manually added the proteome *.sl.proteome.fasta for each species to a file. 

#extract promoters
cat ../proteomes/prot_workingdataset.txt | while read key proteome;
do
cat ${key}/${key}.sl.prom.fasta  >> LBD16.promoters.fasta
done 
#manually added the proteome *.sl.proteome.fasta for each species to a file. 


#protein blast hits
cat ../proteomes/prot_workingdataset.txt | while read key proteome;
do
echo ${key}
echo ${key} >> LBD16.prot.blast.all.txt
cat ${key}/${key}.prot.blast_RBH.txt >> LBD16.prot.blast.all.txt
done 

cat prot_workingdataset.txt | while read key proteome;
do
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${proteome} > ${key}.sl.proteome.fasta
done


#extract the aa sequences and put them in a file. 

cat ../LBD16/LBD16.prot.blast.all.txt | while read key proteome protein genome
do 
echo $key
grep ${protein} ${proteome} -A 1 >> ../LBD16/LBD16.Rosales.proteins.fasta
done


#Fixing bugs of my code. 
#Make one blast_db to recycle all the blastdb done already. 

cat ~/data/genomes_key_rosales30042021.txt |while read key genome
do
echo $key
cd ${key}

mv $genome.* ../../blast_db/
cd ..
done


awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Filulm.augustus.hints.aa > Filulm.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Elaang.augustus.hints.aa > Elaang.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Parand.proteome.fasta > Parand.sl.proteome.fasta

awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Aradur.proteome.fasta > Aradur.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Casgla_aa.fasta  > Casgla.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Cicer.prot.fasta  > Cicer.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Casgla_aa.fasta  > Casgla.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Glymax.proteome.fasta  > Glymax.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Lotjap.proteome.fasta  > Lotjap.sl.proteome.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Lupang.prot.fasta  > Lupang.sl.proteome.fasta
 



makeblastdb -in Filulm.sl.proteome.fasta -dbtype prot -out Filulm
makeblastdb -in Elaang.sl.proteome.fasta -dbtype prot -out Elaang
makeblastdb -in Parand.sl.proteome.fasta -dbtype prot -out Parand

# Code to generate the final list of promoters and proteins from the two blasts "now embeded in rbb.irl.vprot3.sh"
for i in ./*/
do 
output=`basename ${i}`
cd $i
sed  1d ${output}.prot.blast_RBH.txt > prot.blast_RBH.tmp.txt
awk -v var=$output '{print var"\t"$0}' prot.blast_RBH.tmp.txt |uniq >> ../RPG.prot.blast.anno.txt
rm prot.blast_RBH.tmp.txt
cd ..
done

#write a code that only keeps the promoters on the 3rd column and retrieves the proteins from the second column

cat NIN2prot.blast.anno.txt |while read key protein promoter
do
echo $key
cd ${key}
grep ${protein} ../../proteomes/${key}.sl.proteome.fasta -A 1 | sed "s/>/>${key}_/"  >> ../RPG.proteins.fasta
cd ..
done

#use this to run iqtree

#manual curation of tree
# select promoters 

cat RPG.prot.blast.anno.txt |while read key protein promoter
do
echo $key
cd ${key}
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ${key}_2.5kbprom.0.5cds.fasta | sed "s/>/>${key}_/" > ${key}.sl.prom.fasta
cd ..
done

cat ./*/*.sl.prom.fasta >> RPG.promoters.fasta



#PROCESS THE TREE OUTPUTS

#Manually extract the branches of the tree and label them accordingly. 
#use the following script to get the corresponding promoter and make a list (note. I need to ammend this because I did it manually the first time)
awk 'FNR==NR{a[$2]=$3; next}{print $0 "\t" a[$4]}'  NIN2prot.blast.anno.txt orthologue_list2.txt >> orthologue_list.txt

#use this to extract the promoter sequences from each gene family and label it with the gene name
cat orthologue_list.txt | while read file gene sp prot prom; do grep ${prom} ${file} -A 1 | sed "s/>/>${gene}_/" >> NINNLP.promoters; done

# there was a problem with the fragaria stuff so added the promoters manually. 


# Use orthologue_list.txt to extract the scaffolds for the gene of interest and make "mini genome" files for each gene/species for chain generation.
awk '$2=="NIN" {print $2"\t"$3"\t"$5}' orthologue_list.txt |sed 's/:/\t/g' |awk '{print $2"\t"$3}' > NIN.scaffolds.txt
#merge with genome file list and extract scaffolds
awk 'FNR==NR{a[$1]=$2; next}{print $0 "\t" a[$1]}'  ~/data/genomes_key_rosales30042021.txt NIN.scaffolds.txt > NIN.scaffolds_wgenome.txt

cat NIN.scaffolds_wgenome.txt |while read output chr genome;
do

awk  '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/../../scratch/projects/illorens/data/genomes_available/$genome > tmp.fasta
grep ${chr} tmp.fasta -A 1  >> $output.scaffold.fasta 
rm tmp.fasta
done

# for Datglo it deleted the first one so had to re run to add the deleted one like this:
awk  '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/../../scratch/projects/illorens/data/genomes_available/Datglo.softmasked.fasta > tmp.fasta
grep "QANY01003393.1" tmp.fasta -A 1  >> Datglo.scaffold.fasta 
rm tmp.fasta

#Next step is to do multiple alignments!!!!







