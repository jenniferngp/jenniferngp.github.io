---
layout: default
parent: Tutorials
permalink: /doc/tutorials/run-ldsc
nav_order: 2
title: LD Score Regression
---

# LD Score Regression (LDSC)

1. Download baseline annotations
2. Download 1000 Genomes (European) LD scores
3. Download hapmap snps
4. Prepare GWAS input with columns SNP (rsid), POS, N, N_CASE, N_CONTROL, BETA, SE, MAF

Tip: Make sure that MAF, N, N_CASE, and N_CONTROL have no non-numeric values and remove all empty values

5. Prepare annotation files
6. Compute LD scores for your annotations (separate by chromosome)
7. Estimate heritability enrichment

