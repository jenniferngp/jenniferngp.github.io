
---
layout: default
permalink: /doc/bioinformatics/atac_call_peaks
nav_order: 4
parent: 1.1 ATAC-seq
title: 1.1.3 Read Counts
grand_parent: "1. Bioinformatics Tutorials 🧬"
---

# Calculating Read Counts and TMM normalization

4. Convert peak file to saf (peaks2saf.pl). Count reads in each peak (featureCounts).
```sh
cat narrowPeaks.bed | peaks2saf.pl > ${saf}
featureCounts -p -T 4 --donotsort -F SAF -a ${saf} -o ${name}.narrowPeaks.counts ${bam}
```


