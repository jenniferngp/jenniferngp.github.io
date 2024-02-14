---
layout: default
parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/run-ldsc
nav_order: 3
title: 1.3 LD Score Regression
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

- Ensure your GWAS summary statistics are formatted correctly. Key columns include SNP identifier, position, allele information, p-values, effect sizes, and standard errors.
- If necessary, use the munge_sumstats.py script included with LDSC to format your summary statistics:

```sh
python ldsc/munge_sumstats.py \
--sumstats your_data.txt \
--out formatted_data \
--merge-alleles w_hm3.snplist
```

- Tip: Make sure that MAF, N, N_CASE, and N_CONTROL have no non-numeric values and remove all empty values

## Preparing Annotations Files

To ensure a smooth and error-free experience, I strongly advise annotating with SNPs directly from the baseline dataset. This guarantees that the order of variants remains consistent across different annotations. The program tends to throw errors if it detects any discrepancies in the variant order between your dataset and baseline annotations. By sticking with the baseline SNPs from the get-go, you would sidestep this potential error entirely. You will also need to separate these files by chromosomes. I would also recommend making one set of annotation files that contains all of your annotations (each row is a SNP, each column is an annotation). 

## Estimate the LD Score

The LD score measures the association strength between variants in a given population. Estimating it accurately is essential for understanding the genetic architecture of traits and for subsequent analyses, including heritability estimation and genetic correlation studies.

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

Use the ldsc.py script with your formatted GWAS summary statistics and the appropriate LD Score files. For `--ref-ld-chr`, I included my annotations (`annotations/`) and baseline annotations (`baseline_v1.2/baseline.`). LDSC will read these files assuming the chromosome number follows right after the prefix provided. 

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

The above command outputs a `*.results`. The `Enrichment` column was calculated as proportion of heritability explained by SNPs within ATAC peaks divided by the proportion of SNPs within ATAC peaks, and each enrichment was given a p-value, with studies using < 0.05 as the threshold. 




