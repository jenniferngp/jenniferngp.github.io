---
layout: default
nav_order: 1
title: 1.2.0 Create STAR Reference
parent: 1.2 RNA-seq
grand_parent: 1. Bioinformatics Tutorials
permalink: /doc/bioinformatics/rna_star_reference
---

# Create STAR Reference

0. Load software
```sh
export PATH=/software/STAR-2.7.10b/bin/Linux_x86_64:$PATH
export PATH=/software/STAR-2.7.10b/source/:$PATH
```

1. Download conprehensive gene annotation GTF file from Gencode: https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_45/gencode.v45.annotation.gtf.gz

2. Download hg38 fasta reference from UCSC: https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz

3. Unzip files
```sh
gunzip gencode.v45.annotation.gtf.gz
gunzip hg38.fa.gz
```

4. Make reference
```sh
STAR --runThreadN 32 --runMode genomeGenerate --genomeDir ${out_dir} \
--genomeFastaFiles hg38.fa --sjdbGTFfile gencode.v44.annotation.gtf \
--sjdbOverhang 99
```

This command should output these files:

- chrLength.txt      
- chrName.txt   
- exonGeTrInfo.tab  
- geneInfo.tab  
- genomeParameters.txt  
- SA       
- sjdbInfo.txt
- sjdbList.out.tab
- chrNameLength.txt  
- chrStart.txt  
- exonInfo.tab 
- Genome 
- Log.out
- SAindex
- sjdbList.fromGTF.out.tab 
- transcriptInfo.tab


Notes:
- https://www.reneshbedre.com/blog/star-aligner.html

References on sjdbOverhang:
- https://groups.google.com/g/rna-star/c/h9oh10UlvhI/m/BfSPGivUHmsJ
- https://groups.google.com/g/rna-star/c/pHKU0vGGvGk

Actual script:
- scripts/rna_seq/star_reference.pbx


