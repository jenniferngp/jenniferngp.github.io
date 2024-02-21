---
layout: default
parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/run-ldsc
nav_order: 3
title: 1.3 LDSC
---

# LD Score regression to estimate heritability enrichment

LD Score regression is a statistical method used in genetics to estimate the heritability of traits, the genetic correlation between traits from summary-level GWAS (Genome-Wide Association Studies) data, and more. It leverages the principle that the contribution of genetic variants to trait heritability is proportional to their linkage disequilibrium (LD) score, which measures the non-random association between a pair of genetic variants within a population. Here's a basic tutorial on how to use LD Score Regression, focusing on the use of the popular software LDSC (LD Score Regression Software).

## Prerequisites
Before you start, you'll need:

- Python: LDSC is a Python-based tool, so ensure Python is installed on your system.
- GWAS Summary Statistics: You'll need summary statistics from a GWAS study that you're interested in analyzing.
- LD Score Files: These files are necessary for the analysis and can be downloaded from the LDSC GitHub repository or other sources.

## Installation
```sh
git clone https://github.com/bulik/ldsc.git
```

## Preparing GWAS Data

- Required columns are:

1. SNP: identifier
2. N: sample size
3. Z: z-score (sign respect to A1)
4. A1: effect allele 
5. A2: second allele

- Make sure that MAF, N, N_CASE, and N_CONTROL have no non-numeric values and remove all empty values
- If necessary, use the munge_sumstats.py script included with LDSC to format your summary statistics:

```sh
python ldsc/munge_sumstats.py \
--sumstats your_data.txt \
--out formatted_data \
--merge-alleles w_hm3.snplist
```

Notes:


## Preparing Annotations Files

I recommend annotating the SNPs directly from the baseline dataset. This ensures that the order of variants remains consistent across different annotations. The program will throw an error if there are discrepancies in the variant order between your dataset and baseline annotations. By annotating baseline SNPs from the beginning, you would prevent this error from occurring. Also, LDSC developers recommend using a set of HapMap SNPs to run LDSC, and the baseline files already contains these SNPs. 

You will also need to separate these files by chromosomes. I also recommend combining all of your annotations into one file, it just makes things easier downstream. 

## Estimate the LD Score

The LD score measures the association strength between variants in a given population. Here, I am using European population as reference. 

```sh
for chr in {1..22}; 
do
	python ldsc.py \
	--l2 \
	--ld-wind-cm 1 \
	--yes-really \
	--bfile plink_files/1000G.EUR.hg38.${chr} \ 
	--annot annotations/${chr}.annot.gz \ 
	--out annotations/${chr} 
done
```

## Estimate Heritability

`ldsc.py` is provided in the GitHub. For `--ref-ld-chr`, you will need to both your (`annotations/`) and the baseline annotations (`baseline_v1.2/baseline.`). LDSC will read these files assuming the chromosome number follows right after the prefix provided. For example, the way I had structured my annotations directory is as follows: `annotations/1.*`, `annotations/2.*`, etc.

```sh
python ldsc.py \
--h2 height.sumstats.gz \
--ref-ld-chr annotations/,baseline_v1.2/baseline. \
--w-ld-chr weights/weights.hm3_noMHC. \
--overlap-annot \
--frqfile-chr 1000G_Phase3_frq/1000G.EUR.QC. \
--out h2_out/height
```

## Interpreting Results

`ldsc.py` will output `*.results` file, which contains an Enrichment column and an "Enrichment_p" column. Enrichment was calculated as proportion of heritability explained by SNPs within ATAC peaks divided by the proportion of SNPs within ATAC peaks. Previous studies have used Enrichment_p < 0.05 as the threshold.  




