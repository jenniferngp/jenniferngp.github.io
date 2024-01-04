---
layout: default
parent: Bioinformatics
permalink: /doc/bioinformatics/run-ldsc
nav_order: 3
title: LD Score Regression
---

# LD Score Regression (LDSC)

Original tutorial: https://github.com/bulik/ldsc/wiki

1. Prepare GWAS input with columns SNP (rsid), POS, N, N_CASE, N_CONTROL, BETA, SE, MAF
\
Tip: Make sure that MAF, N, N_CASE, and N_CONTROL have no non-numeric values and remove all empty values

1. Prepare annotations input
\
For easier, faster, and cleaner implementation, I recommend using  SNPs from baseline. The program will output an error if the variants are not in the same order across the annotations, so it is easier to use SNPs from the baseline files (with the same order) and annotate them with your annotations. 

1. Calculate LD scores
```sh
python ldsc.py \
--l2 \
--ld-wind-cm 1 \
--yes-really \
--bfile plink_files/1000G.EUR.hg38.${chr} \
--annot ${annot_dir}/${chr}.annot.gz \
--out ${out_dir}/${chr} \
--print-snps baseline.${chr}.snps 
```

1. Calculate heritability enrichment
```sh
python ldsc.py \
--h2 ${trait_name}.sumstats.gz \
--ref-ld-chr ${out_dir}/,baseline_v1.2/baseline. \
--w-ld-chr weights/weights.hm3_noMHC. \
--overlap-annot \
--frqfile-chr 1000G_Phase3_frq/1000G.EUR.QC. \
--out ${out_dir}/${trait_name}
```