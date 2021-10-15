#!/usr/bin/env python

from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import numpy as np
import sys


#This is work in progress. The code takes a fasta file and a number for the kmer size and will 
# analyze kmers for similarity against a sequence (PACE element). Then it calculates
# the levenshtein distance to define similarity. 

#run this on terminal 
#CHECK THE FASTA FILE IS NOT CORRUPTED
#for info about jellyfish look at: http://www.genome.umd.edu/docs/JellyfishUserGuide.pdf

#jellyfish count -m 10 -s 100M -C test.prom.fasta 
#jellyfish dump mer_counts.jf > test.prom.dump.fasta

#modify fasta header to add species name and sequence. 

# this will generate a mer_counts.jf file that can be dumped to make a list of kmers
def hamming_distance(s1, s2):
    """Return the Hamming distance between equal-length sequences"""
    if len(s1) != len(s2):
        raise ValueError("Undefined for sequences of unequal length")
    return sum(ch1 != ch2 for ch1, ch2 in zip(s1, s2))

def levenshtein(seq1, seq2):
    size_x = len(seq1) + 1
    size_y = len(seq2) + 1
    matrix = np.zeros ((size_x, size_y))
    for x in range(size_x):
        matrix [x, 0] = x
    for y in range(size_y):
        matrix [0, y] = y

    for x in range(1, size_x):
        for y in range(1, size_y):
            if seq1[x-1] == seq2[y-1]:
                matrix [x,y] = min(
                    matrix[x-1, y] + 1,
                    matrix[x-1, y-1],
                    matrix[x, y-1] + 1
                )
            else:
                matrix [x,y] = min(
                    matrix[x-1,y] + 1,
                    matrix[x-1,y-1] + 1,
                    matrix[x,y-1] + 1
                )
   # print (matrix)
    return (matrix[size_x - 1, size_y - 1])

#Generate kmers from the provided fasta file. k-mers will be named based on the fasta header and their position. 

ksize=int(sys.argv[2])
kmers = []
with open(sys.argv[1]) as handle:
    for record in SeqIO.parse(handle, "fasta"):  
        sequence = str(record.seq)  
        n_kmers = len(sequence) - ksize + 1
        for i in range(n_kmers):
            c=i + ksize
            kmer =SeqRecord(Seq(sequence[i:i + ksize]), id=record.id, name="kmer", description="{}:{}".format(i, c))
            kmers.append(kmer)

#SeqIO.write(kmers, "kmer_gen.fasta", "fasta")

motif = SeqRecord(Seq("GCCATGTGGC"), id="PACE")
print("\t".join([motif.id,str(motif.seq)]))

#Look for candidates based on levenshtein distance. At this point I'm using an arbitrary cut-off of how many substitutions are allowed.
#Need to do some sort of statistical test to look for significance. 
candidates=[]
for record in kmers:
    b=levenshtein(motif.seq, record.seq)
    a=levenshtein(motif.seq, record.reverse_complement())
    if a <= 3:
        candidates.append("\t".join([motif.id, str(motif.seq), record.id, str(record.seq), str(a),record.description, "+"]))
     #   print("\t".join([motif.id, record.id, str(record.seq), str(a), "+"]))
    if b <=3:
        candidates.append("\t".join([motif.id, str(motif.seq), record.id, str(record.seq), str(b),record.description, "-"]))
     #   print("\t".join([motif.id, record.id, str(record.seq.reverse_complement()), str(b), "-"]))

print(candidates)

textfile = open("candidates.tsv", "w")
for element in candidates:
    textfile.write(element + "\n")
textfile.close()


#Do some sort of statistical model and predict similarity between motifs. 

