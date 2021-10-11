#!/usr/bin/env python

#code for downloading assemblies from ncbi. Taken from:
#https://www.ncbi.nlm.nih.gov/datasets/
from __future__ import print_function
import sys
import zipfile
from pandas import pandas
from pprint import pprint
from datetime import datetime
from collections import defaultdict, Counter
from IPython.display import display

import matplotlib.pyplot as plt
plt.style.use('ggplot')

try:
    import ncbi.datasets
except ImportError:
    print('ncbi.datasets module not found. To install, run `pip install ncbi-datasets-pylib`.')


## start an api_instance 
api_instance = ncbi.datasets.GenomeApi(ncbi.datasets.ApiClient())


#look by taxon ID
#taxid = 37572 ## butterflies
taxid=71275 ##Rosids
assembly_descriptors = api_instance.assembly_descriptors_by_taxon(
    taxon=taxid,
    limit='all',
    filters_refseq_only=True)

print(f"Number of assemblies: {assembly_descriptors.total_count}")

#with open("assemblies.csv", "w") as f:
 #   f.write("Accession,species,level,length.chromosome,date\n")
## print other information as a table to select genomes to download

  #  for assembly in map(lambda d: d.assembly, assembly_descriptors.assemblies):
   #     print("%s,%s,%s,%s,%s" %
    #        (assembly.assembly_accession,
     #       assembly.org.sci_name,
      #      assembly.assembly_level,
       #     len(assembly.chromosomes),
        #    assembly.submission_date),file=f)


rosids_assemblies= []
for assembly in map(lambda d: d.assembly, assembly_descriptors.assemblies):
    rosids_assemblies.append(assembly.assembly_accession)
        
print(f'Download a dehydrated package for {rosids_assemblies}, with the ability to rehydrate with the CLI later on.')
api_response = api_instance.download_assembly_package(
    rosids_assemblies,
    exclude_sequence=False,
    _preload_content=False
    )

zipfile_name = 'rosids_genomes.zip'
with open(zipfile_name, 'wb') as f:
    f.write(api_response.data)

print('Download complete')
