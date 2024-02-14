---
layout: default
nav_order: 3
title: 1.2.0 Create RSEM Reference
parent: 1.2 RNA-seq
grand_parent: 1. Bioinformatics Tutorials
permalink: /doc/bioinformatics/rna_rsem_reference
---

# Create RSEM Reference

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
rsem-prepare-reference --gtf gencode.v44.annotation.gtf \
hg38.fa ${out_dir}/${prefix}
```

This command should output these files:

- ${prefix}.chrlist  
- ${prefix}.idx.fa      
- ${prefix}.seq  
- ${prefix}.transcripts.fa
- ${prefix}.grp      
- ${prefix}.n2g.idx.fa  
- ${prefix}.ti

Notes:
- https://deweylab.github.io/RSEM/rsem-prepare-reference.html

Publication:

- Li B, Dewey CN. RSEM: accurate transcript quantification from RNA-Seq data with or without a reference genome. BMC bioinformatics. 2011 Dec;12:1-6.
- https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-323

