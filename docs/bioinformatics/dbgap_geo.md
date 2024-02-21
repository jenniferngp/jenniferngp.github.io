---
layout: default
parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/qtl
nav_order: 10
title: 1.10 dbGaP/GEO
---

# dbGaP / GEO

The Database of Genotypes and Phenotypes (dbGaP) and the Gene Expression Omnibus (GEO) are both databases managed by NCBI but they each have distinct access policies reflecting the nature of the data they contain and their intended research applications. 

For dbGP, access to individual-level data in dbGaP is controlled due to the sensitive nature of genetic and phenotypic information. Researchers must apply for access, detailing their research purposes and obtaining approval from a data access committee to ensure compliance with privacy protections and ethical guidelines.

For GEO, it provides open access to its datasets, which include high-throughput gene expression data and other functional genomic datasets. The public can freely download these datasets without the need for application or approval. 

Both databases deposit raw data onto the Sequence Read Archive (SRA). However, if you are downloading data from dbGaP, you will need to add the extra paramter `--ngc` which points to your personal dbGaP repository key. 

## Downloading data from SRA

### 1. Install the SRA Toolkit

Fetch the tar file
```sh
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.10/sratoolkit.3.0.10-centos_linux64.tar.gz
```

Extract contents from the tar file
```sh
tar -xvzf sratoolkit.3.0.10-centos_linux64.tar.gz
```

Add path to your environmental variable
```sh
export PATH=${dir}/sratoolkit.3.0.10-centos_linux64/bin:$PATH
```

Verify that the binaries are executable
```sh
which fasterq-dump
```

The output should be this
```sh
${dir}/sratoolkit.3.0.10-centos_linux64/bin/fasterq-dump
```

### 2. Obtain the SRR ID for the sample you wish to download

I find that it is easiest to get SRR IDs from SRA Run Selector using either a GSE (GSEXXXXX) or BioProject (PRJNAXXXX) Accession number (https://0-www-ncbi-nlm-nih-gov.brum.beds.ac.uk/Traces/study/?). 


### 3. Download

Using `prefetch` before `fasterq-dump` is a recommended practice when downloading from data from SRA. It ensures the integrity of the downloaded data by verifying file completeness and checksums after download. This minimizes the risk of data corruption or partial downloads. It also allows for better management of network bandwidth. `prefetch` will download an `.sra`.

If the data is controlled access (i.e., on dbGaP)
```sh
prefetch ${SRR_ID}
fasterq-dump --ngc ${ngc_file} ~/ncbi/sra/${SRR_ID}.sra --split-3
```

If the data is uncontrolled
```sh
prefetch ${SRR_ID}
fasterq-dump ~/ncbi/sra/${SRR_ID}.sra --split-3
```

`split-3` will split paired-end reads into the `*_1.fastq` and `*_2.fastq` files. Unmated (i.e., single-end) reads will be written in a `.fastq` file. 

If the data has a technical reads (like single-cell data from 10x Genomics), you will need to add the `--include-technical` parameter. 

Useful references:

- https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump
- https://rnnh.github.io/bioinfo-notebook/docs/fasterq-dump.html





