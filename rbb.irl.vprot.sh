makeblastdb -in ../augustus.hints.aa -dbtype prot -out Elaang_prot


blastp -query ../augustus.hints.aa -db ~/../../scratch/projects/illorens/Motif_search/NINbe/Elaang/NINNLP.310321.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 10 > blast.outfmt6
#Switch query and search paths for reciprocal search
blastp -query ~/data/extraNINs/NINNLP.310321.fasta -db Elaang_prot -max_target_seqs 1 -outfmt 6 -evalue 1e-3 -num_threads 10 > blast_reciprocal.outfmt6
#Output end status message

##Input query blast results file
queryPath="blast.outfmt6"
#Input DB reciprocal blast results file
dbPath="blast_reciprocal.outfmt6"

#Usage ex: bash findRBH.sh blast.outfmt6 blast_reciprocal.outfmt6
#Final output files

outFileRBH=Elaang.blast_RBH.txt
outFileSummary=Elaang.blast_RBH_summary.txt
#Add headers to output RBH files
echo "queryHit,dbHit,percentage,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore" > $outFileRBH
echo "queryHits,dbHits,bestHits" > $outFileSummary
#Output start status message
echo "Recording RBH..."
#Loop over query blast results
while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
do
#Determine RBH to DB blast results
if grep -q "$f2"$'\t'"$f1"$'\t' $dbPath; then 
echo "$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$f10,$f11,$f12" >> $outFileRBH
fi
done < $queryPath
#Output summary of RBH
queryHits=$(wc -l "$queryPath" | cut -d ' ' -f 1)
dbHits=$(wc -l "$dbPath" | cut -d ' ' -f 1)
bestHits=$(($(wc -l "$outFileRBH" | cut -d ' ' -f 1)-1))
echo "$queryHits","$dbHits","$bestHits" >> $outFileSummary
#Output end status message
echo "Finished recording RBH!"