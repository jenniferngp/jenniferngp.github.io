---
layout: default
title: The missing link between genetic association and regulatory function
parent: Other
nav_order: 1
permalink: /docs/papers/Connally_eLife_2022
---

# The missing link between genetic association and regulatory function

Noah J Connally, ...., Chris Cotsapas, Christopher A Cassa, Shamil R Sunyaev. eLife, 2022

## Abstract 
- Despite the availability of gene expression and epigenomic datasets, few variant-to-gene links have emerged. 

- It is unclear whether these sparse results are due to limitations in available data and methods, or to deficiencies in the underlying assumed model

- To better distinguish between these possibilities, we identified 220 gene-trait pairs in which protein-coding variants influence a complex trait or its Mendelian cognate. 

- We applied a gene-based approach and found "limited evidence that the baseline expression of trait-related genes explains GWAS associations"

- These results contradict the hypothesis that most complext trait-associated variants coincide with homeostatic expression QTLs, suggesting that better models are needed. 

TLDR; Baseline expression of trait-related genes do not explain the associations between complex traits and genetic variants. 

## Introduction

- The "unembellished model - in which GWAS peaks are mediated by the effects on the homeostatic expression assayed in tissue samples - is the exception rather than the rule."

- "We highlight challenges of current strategies linking GWAS variants to genes and call for a reevaluation of the basic model in favor of more complex models possibly involving context-specificity with respect to cell types, developmental stages, cell states or the constancy of expression effects."

- There are several observations that challenge the unembellished model:
1. eQTLs are enriched in close proximity to genes while GWAS peaks are usually further away.
2. Expression levels mediate a minority of complex trait heritability.
3. Only 5-40% of trait associations colocalize with eQTLs

-  A narrower, more testable hypothesis requires identifying genes we believe a priori are biological relevant to the GWAS traits and seeing if they have nearby GWAS peaks and eQTLs. Thus, failure to colocalize would be a meaningful negative results. Previously, when a GWAS peak has no colocalization, the model is inconclusive. But trait-linked genes that fail to colocalize reveal that our method fo detecting non-coding variation is incompatible with our model for understanding it. 

- True positives were identified by looking for genes that are both in loci associated with a complex trait and also known to harbor coding mutations tied to a related Mendelian trait or the same complex trait. 

## Results

- The study analyzed 220 unique gene-trait pairs that have known associations with coding variants and have large effect sizes. 

- To remove signaals from coding variation, the authors re-corrected GWAS summary statistics by conditioning on coding variants. The resulting GWAS associations should reflect only non-coding variants. 

- The authors found 147 genes out of the 220 that fell within 1 Mb of a GWAS locus, but only 22 (15% of 147) was identified as putatively causative genes using current eQTL colocalization and TWAS methods. 

## Discussion

The study results align with the notion that noncoding genetic variants play a significant role in complex traits by regulating gene expression near the variants.

However, these findings do not support the model where the effects on gene regulation come solely from genetic influences on baseline gene expression as captured by eQTLs.

Current statistical methods fail to link GWAS associations with gene expression changes, suggesting that GWAS variants do not exert their effects through the stable, baseline expression patterns captured by broad eQTL studies.

Common explanations for lack of eQTL and GWAS overlap include: non-expression-related mechanisms, lack of GWAS power, absence of relevant eQTLs, and underpowered methods for linking expression to GWAS.

The 'missing regulation' linking variants to gene expression may be revealed by more nuanced models that consider context-dependent expression and short-term expression variability.

Identifying 'missing regulation' involves finding new eQTLs linked to GWAS peaks as well as explaining why some eQTLs near GWAS peaks, termed 'red herring eQTLs,' do not colocalize with GWAS. 

The study emphasizes that while eQTLs are important, current models are insufficient because they don't connect trait-associated noncoding variants with known genes and fail to explain the lack of GWAS effect from 'red herring' eQTLs.

The study supports the prioritization of data from specialized cell contexts and other forms of expression data that could capture the complex regulatory effects not seen in standard eQTL mapping.
