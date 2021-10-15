#!/usr/bin/env python

from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import numpy as np
import sys

#Fraves.primary.proteome.fasta
#Fvesca_677_v4.0.a2.cds_primaryTranscriptOnly.fa
with open("ccamk_streptoclade_forENSA_translated.fasta", 'w') as aa_fa:
    for dna_record in SeqIO.parse("ccamk_streptoclade_forENSA_cds.fa", 'fasta'):
        # use both fwd and rev sequences
        dna_seqs = [dna_record.seq, dna_record.seq.reverse_complement()]

        # generate all translation frames
        aa_seqs = (s[i:].translate(to_stop=True) for i in range(3) for s in dna_seqs)

        # select the longest one
        max_aa = max(aa_seqs, key=len)

        # write new record
        aa_record = SeqRecord(max_aa, id=dna_record.id, description="translated sequence")
        SeqIO.write(aa_record, aa_fa, 'fasta')
