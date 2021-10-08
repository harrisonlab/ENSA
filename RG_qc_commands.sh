#Assesment of Redgauntlet assemblies

"/projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/RNAseq"
 
#Check reads 
#PE
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/PE/1628_LIB19365_LDI16700_GCCAAT_L001_R1.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/PE/1650_LIB19365_LDI16700_GCCAAT_L001_R?.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/PE/1650_LIB19365_LDI16700_GCCAAT_L002_R?.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/PE/1670_LIB19365_LDI16700_GCCAAT_L001_R?.fastq.gz

#LMP

kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/LMP/nextclip_filtered/2074_LIB24445_LDI21734_CCGTCC_L001_nc_ABC_R2.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/LMP/nextclip_filtered/2074_LIB24445_LDI21734_CCGTCC_L001_nc_ABC_R1.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/LMP/nextclip_filtered/2074_LIB24440_LDI21729_CAGATC_L001_nc_ABC_R2.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/LMP/nextclip_filtered/2074_LIB24440_LDI21729_CAGATC_L001_nc_ABC_R1.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/LMP/nextclip_filtered/2074_LIB24438_LDI21727_ACAGTG_L001_nc_ABC_R2.fastq.gz
kat hist -o scer_pe_hist -h 80 -t 10 -m 27 -H 1000000000 ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/LMP/nextclip_filtered/2074_LIB24438_LDI21727_ACAGTG_L001_nc_ABC_R1.fastq.gz


#Check assembly contiguity and quality

for i in ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/assemblies/*.fasta.gz
do
echo $i
abyss-fac $i
done

#Compare PE reads to contigs and scaffolds. more specifically:
# redgauntlet_contigs_2016-11-25_ei_version.fasta.gz,
# redgauntlet_scaffolds_2017-01-23_ei_v1_ns_remapped.fasta.gz
# redgauntlet_scaffolds_abyss_ei_all_100_mp1_3-6-scaffolds.fa.gz


kat comp -t 10 -o pe_v_asm_test ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/PE/1628_LIB19365_LDI16700_GCCAAT_L001_R?.fastq.gz  ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/assemblies/redgauntlet_scaffolds_abyss_ei_all_100_mp1_3-6-scaffolds.fa.gz 
kat comp -t 10 -o pe_v_asm_test ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/PE/1628_LIB19365_LDI16700_GCCAAT_L001_R?.fastq.gz ~/../../projects/oldhome/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/assemblies/redgauntlet_contigs_2016-11-25_ei_version.fasta.gz