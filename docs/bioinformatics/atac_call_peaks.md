---
layout: default
permalink: /doc/bioinformatics/atac_call_peaks
nav_order: 3
parent: 1.1 ATAC-seq
title: 1.1.2 Call Peaks (MACS2)
grand_parent: "1. Bioinformatics Tutorials 🧬"
---

# Calling Peaks using MACS2


1. Call narrow peaks
```sh
name=`basename $bam ".bam"`
macs2 callpeak -f BAMPE -g hs -t ${bam} -n ${name} --outdir ${out_dir} --nomodel --shift -100 --extsize 200 --call-summits
```

2. Call broad peaks
```sh
macs2 callpeak -f BAMPE -g hs -t ${bam} -n ${name} --outdir ${out_dir} --nomodel --shift -100 --extsize 200 --broad
```

3. Count reads in promoters
```sh
samtools view -c -L ${promoters_bed} ${bam} > ${out_dir}/reads_in_promoter.txt
```

## What files does MACS2 accept?

MACS2 accepts a BED or a BAM file. From experience, I found that using BED files yields more refined but much shorter peaks (i.e, can distinguish two peaks within one) while BAM files yields longer and less resolved peaks. For genetic analyses, specifically QTL analyses, I recommend using BAM files as input because longer peaks have a higher change of detecting QTLs. While ENCODE calls peaks using BED files, there have been studies that used BAM files, so I believe both methods are acceptable. 

## 

Next steps:
10. Remove peaks in blacklisted regions (from ENCODE)
11. TMM normalize read counts using edgeR
12. Generate consensus peaks by merging peaks across samples or selecting a subsample of high-quality samples and call peaks from their merged bam files. 