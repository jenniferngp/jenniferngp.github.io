---
layout: default
parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/genotype_pca
nav_order: 6
title: 1.6 Genotype PCA
---

# Principal component analysis to characterize global ancestry

Global ancestry refers to the genetic lineage and heritage of individuals that span across continents and populations. Given the extensive genetic diversity and complexity inherent in human populations, identifying and characterizing this global ancestry is crucial for understanding human evolution, migration patterns, and the genetic basis of diseases. PCA facilitates this by efficiently summarizing large genetic datasets into principal components (PCs) that reflect underlying patterns of genetic variation, often correlated with geographic and ancestral origins.

1. For each chromosome VCF, separate multi-allelic SNPs and rename SNP ids
```sh
pca_dir= # output directory
chr= #chromosome
ref_vcf=ALL.chr${chr}.shapeit2_integrated_snvindels_v2a_27022019.GRCh38.phased.vcf.gz

cmd="bcftools norm \
--threads 8 \
-m - -Oz \
-o chr${chr}.vcf.gz \
$ref_vcf"
echo $cmd >& 2; eval $cmd

cmd="plink2 -\
-snps-only \
--vcf chr${chr}.vcf.gz  \
--make-bed  \
--memory 3000 \
--threads 8 \
--out ${pca_dir}/input/chr${chr}.rename \
--set-all-var-ids @:#:\\\$1:\\\$2"
echo $cmd >& 2; eval $cmd

cmd="echo chr${chr}.rename >> ${pca_dir}/merge_list.txt"
echo $cmd >& 2; eval $cmd
```
2. Run PCA
- `within_filt.txt` is a text a file with FIDs in the first column, IIDs in the second column, and cluster names in the third column
- `merge_list.txt` is a list of VCFs (chr1-22) to merge, although, only chr21 is sufficient to do the analysis. 
- `intersect.snps` is a list of variants to use in the analysis (bi-allelic, common SNPs)
- `pca-cluster-names` is a space-delimited sequence of cluster names on the command line

```sh
cmd"plink /
--extract intersect.snps
--keep within_filt.txt 
--make-bed
--merge-list merge_list.txt # list of VCFs to merge
--out $out_dir
--pca
--pca-cluster-names AFR EUR AMR EAS SAS
--within within_filt.txt " 
echo $cmd >& 2; eval $cmd
```