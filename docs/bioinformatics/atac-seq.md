---
layout: default
parent: 1. Bioinformatics Tutorials
permalink: /doc/bioinformatics/atac-seq
nav_order: 1
title: 1.1 ATAC-seq
has_children: true
---

# ATAC-seq

Last updated: 12-19-2023

ATAC-seq stands for **A**ssay for **T**ransposase-**A**ccessible **C**hromatin with Sequencing. 

ATAC-seq is a widely adopted technique for profiling open chromatin regions throughout the genome. Recently, it has been extended to infer transcription factor occupancy by leveraging Tn5 insertion profiles, giving rise to a technique called digital ATAC-seq footprinting. By integrating these two types of information, ATAC-seq enables the identification of regions exhibiting active regulatory activity, such as enhancers and promoters, and facilitates the elucidation of the transcription factors involved in coordinating subsequent transcriptional processes.

ATAC-seq method was first published in 2013 by [Buenostro et al., Nature Methods](10.1038/nmeth.2688) at the Greenleaf Lab @ Stanford. 

## Role of Tn5 Transposase in ATAC-seq

Tn5 is a hyperactive transposase enzyme derived from the bacterium Tn5. It is used in ATAC-seq to efficiently fragment accessible DNA sites and incorporate sequencing adapaters. Tn5 also preferentially targets open chromatin regions because steric hindrance at non-accessible regions makes it difficult for adaptor incorporation. 


