---
layout: default
permalink: /doc/bioinformatics/atac_call_peaks
nav_order: 3
parent: 1.1 ATAC-seq
title: 1.1.2 Call Peaks (MACS2)
grand_parent: "1. Bioinformatics Tutorials 🧬"
---

# Calling ATAC-seq Peaks using MACS2

MACS2 (Model-based Analysis of ChIP-seq 2) (Zhang et al., Genome Biology, 2008) is a widely used tool originally designed for the analysis of ChIP-seq but is also commonly used for ATAC-seq analysis. MACS2 identifies peaks of enriched regions from ChIP-seq data or in the case of ATAC-seq data, regions of open chromatin. 

For detailed tutorial of MACS2: https://hbctraining.github.io/Intro-to-ChIPseq/lessons/05_peak_calling_macs.html

The decision to call narrow peaks versus broad peaks is primarily based on the nature of the experiment. From previous experience, I have always used narrow peaks for ATAC-seq experiments. To help determine which type of peaks to call, you may assess the distribution of the peak lengths and determine if they are compatible with common literature. For example, TF binding sites are typically short sequences so narrow peaks might be more suitable. 

MACS2 also accepts either a BED or a BAM file. From experience, I find that using BED files as input yields more refined and shorter peaks while BAM files yields longer and less resolved peaks. However, the shorter peaks from using BED files can be too short and therefore, not ideal for genetic analyses. We found that larger peaks have a better chance of identifying relevant regulatory variants than shorter peaks. 

## Calling narrow peaks
```sh
name=`basename $bam ".bam"`
macs2 callpeak -f BAMPE -g hs -t ${bam} -n ${name} --outdir ${out_dir} --nomodel --shift -100 --extsize 200 --call-summits
```

## Calling broad peaks
```sh
macs2 callpeak -f BAMPE -g hs -t ${bam} -n ${name} --outdir ${out_dir} --nomodel --shift -100 --extsize 200 --broad
```

## Remove peaks in blacklisted regions





