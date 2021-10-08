#!usr/bin/env python



def build_kmers(sequence, ksize):
    kmers = []
    n_kmers = len(sequence) - ksize + 1

    for i in range(n_kmers):
        kmer = sequence[i:i + ksize]
        kmers.append(kmer)

    return kmers

import screed # a library for reading in FASTA/FASTQ

def read_kmers_from_file(filename, ksize):
    all_kmers = []
    for record in screed.open(filename):
        sequence = record.sequence

        kmers = build_kmers(sequence, ksize)
        all_kmers += kmers

    return all_kmers


import numpy as np

def levenshtein(seq1, seq2):
    size_x = len(seq1) + 1
    size_y = len(seq2) + 1
    matrix = np.zeros ((size_x, size_y))
    for x in xrange(size_x):
        matrix [x, 0] = x
    for y in xrange(size_y):
        matrix [0, y] = y

    for x in xrange(1, size_x):
        for y in xrange(1, size_y):
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
    print (matrix)
    return (matrix[size_x - 1, size_y - 1])


#%matplotlib inline
#from matplotlib_venn import venn2, venn3

#venn2([set(a), set(b)])

seq1 = 'ATTTTGTACGATTGCCATGTGGCACGCA'
seq2 = 'GGAGATTGCTTTATTAAGCTAAAAAAATATGTTTGCCAGCAAAAAGAAAAAAGATACACAATTTGTCAAAAATAAAATAAAAAAAATAAGAAACAGAAAATTTGTAGAATCGCCATGTGGCGAGCAGAGAGATGGCCC'

K = 8
kmers1 = build_kmers(seq1, K)
kmers2 = build_kmers(seq2, K)

print(K, jaccard_containment(kmers1, kmers2))

# build k-mers jellyfish to get dump k-mers
# do a cross comparison between all k-mers in query vs target 
# calculate levenshtein distance for each kmer pair and select best hits (get some sort of p-value?) 
#Compare the levenshtein distance and select those with higher p-values maybe do some bootstraping or something. 
# Do the same for each species 

# select the best hits. 
# Iterate 