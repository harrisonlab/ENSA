#!/bin/bash

assembly=$1
proteins=$2
species=$3      # can't be used twice.
outdir=$4
rnaseqdir=$5
rna=($rnaseqdir/*.bam)

#echo ${rna[@]}

printf -v joined '%s,' ${rna[@]}
echo ${joined%,}
