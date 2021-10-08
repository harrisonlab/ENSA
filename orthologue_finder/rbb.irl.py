#!/usr/bin/env python

#in fasta file including all sequences for the database
#out database name
#db type 

import sys

makeblastdb -in FILE_NAME.fasta -dbtype 'TYPE' -out DATABASE_NAME