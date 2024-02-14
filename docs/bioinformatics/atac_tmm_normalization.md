---
layout: default
permalink: /doc/bioinformatics/atac_tmm_normalization
nav_order: 5
parent: 1.1 ATAC-seq
title: 1.1.3 TMM Normalization
grand_parent: "1. Bioinformatics Tutorials 🧬"
---

# TMM Normalization

R version 4.2.1
```R
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("edgeR")

library(edgeR)
library(dplyr)
library(data.table)

# 0. Get sample ids
meta = fread("metadata.txt", row.names = F)

# 1. Initialize counts matrix
# example filename: counts/sample1.counts
file = paste("counts", paste(meta$phenotype_id, "counts", sep = "."), sep = "/")
counts = fread(file, data.table = F)
colnames(counts)[7] = meta$phenotype_id[1]

# 2. Cbind counts from other samples
for (sample in meta$phenotype_id[2:length(meta$phenotype_id)])
{
    file = paste("counts", paste(sample, "counts", sep = "."), sep = "/")
    this = fread(file, data.table = F)
    colnames(this)[7] = sample
    counts = merge(counts, this, by = c("Geneid", "Chr", "Start", "End", "Strand", "Length"))
}

fwrite(counts, "phenotype_counts_matrix.txt", row.names = F, sep = "\t")

# 3. TMM Normalize
# https://www.biostars.org/p/317701/
to_tmm = counts %>% select(-Chr, -Start, -End, -Strand, -Length)

dge = DGEList(counts=as.matrix(to_tmm), group=colnames(to_tmm))
dge = calcNormFactors(dge, method = "TMM")
tmm = data.frame(cpm(dge))

fwrite(tmm, "phenotype_tmm_matrix.txt" row.names = F, sep = "\t")
```