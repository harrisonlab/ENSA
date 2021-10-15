#!/bin/bash
#SBATCH --cpus-per-task=40
#SBATCH --mem 50G
#SBATCH --nodelist=triticum
#SBATCH --partition=himem

export MYCONDAPATH=/home/illorens/miniconda3
source ${MYCONDAPATH}/bin/activate aw.braker.env
export PATH="/scratch/software/cdbfasta/:$PATH"

#This is a test script for braker2 to be used on RNAseq and protein data. If you want to run braker2 only with proteins or RNA and then merge the results, you can do it. 
# Check https://github.com/Gaius-Augustus/BRAKER to see how to modify the script below. 

#This script requires:
# an assembly ($assembly)
# protein database ($proteins)
# a name of the species ($species) (for some reason it cant be used twice)
# the name of the output directory $outdir (try to set a new one if repeating the analysis) 
# directory where the rnaseq data is localized $rnaseqdir. !IMPORTANT RNAseq data needs to be mapped to the genome and converted to .bam (see rnaseq_analysis folder)

# For example: 
# sbatch ./scripts/braker_annew_prot_and_rna.sh ./data/genomes_available/Cercocarpus_montanus.softmasked.fasta ./data/proteomes/diamond_proteins/proteins.fasta Cermonv2 ~/../../scratch/projects/illorens/genome_annotation/out/braker_out/Cermonv2  ~/../../projects/ensa/plants/RNAseq/raw_data/Cermon/


export DATA=/scratch/projects/illorens
cd ${DATA}

assembly=$1
proteins=$2
species=$3      # can't be used twice.
outdir=$4
rnaseqdir=$5
rna=($rnaseqdir/*.bam)
printf -v joined '%s,' ${rna[@]}



srun /scratch/software/BRAKER-06october2021/scripts/braker.pl --species=$species \
--genome=$assembly \
--etpmode \
--prot_seq=$proteins \
--bam=${joined%,} \
--gff3 \
--cores 40 \
--workingdir=$outdir \
--verbosity 4 \
--softmasking \
--nocleanup \
--PYTHON3_PATH=/scratch/software/miniconda3/bin \
--GENEMARK_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/" \
--ALIGNMENT_TOOL_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/" \
--PROTHINT_PATH="/scratch/software/gmes_linux_64_4.68_13oct2021/gmes_linux_64_4/ProtHint/bin/" 
