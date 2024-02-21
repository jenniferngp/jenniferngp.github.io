---
layout: default
parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/sample_identity
nav_order:5
title: 1.5 Sample ID
---

# Sample Identity

Sample identity is a critical aspect of bioinformatics research, especially when hundreds of samples are involved. In this field, sample swaps or mix-ups can lead to significant errors in data interpretation, affecting the conclusions drawn from research study. 

To perform sample identity analysis:

1. Create a reference VCF containing common variants
- this analysis is highly robust so a few hundred variants is sufficient
- to reduce computation time even further, you may filter for variants that are in specific genomic regions we expect to there to be a lot of reads. For instance, for RNA-seq, variants in exonic regions can be selected. For ATAC-seq, variants in promoter region scan be selected. Beware that filtering for promoter variants may reduce the number of variants by a significant magnitude. 
2. Call variants from aligned molecular data
3. Merge the sample VCF with real genotypes
- in this case, we have whole-genome sequencing genotypes that we can compare to
4. Calculate pairwise IBD using `plink -genome` 

```sh
reference_vcf= # reference vcf
reference=/reference/public/ucsc/hg38/hg38.fa 
out_dir= # output directory to save

log=${out_dir}/pipeline.log

dir=`mktemp -d -p scratch` # make scratch directory

date >& 2

echo "$bam target" > ${dir}/sample.txt # make file to rename bamfile as "target" in VCF header

cat ${dir}/sample.txt >& 2

# 2. Call genotypes from BAM file
cmd="bcftools mpileup -Ou -f $reference -R $reference_vcf --threads 12 $bam |\
bcftools call --threads 12 -Ou -mv |\
bcftools filter -e 'DP<10'  | bcftools reheader -s ${dir}/sample.txt |\
awk 'BEGIN{OFS=\"\t\";} {if(\$1 !~ /^#/) {\$3=\$1\":\"\$2;} print;}' |\
bgzip -c > ${dir}/call.vcf.gz"
echo $cmd >> $log; echo $cmd >& 2; eval $cmd

cmd="tabix -p vcf ${dir}/call.vcf.gz"
echo $cmd >> $log; echo $cmd >& 2; eval $cmd

# 3. Merge with WGS VCF
cmd="bcftools merge ${dir}/call.vcf.gz $reference_vcf |\
bcftools view --threads 8 -m2 -M2 -v snps -o ${dir}/merged.vcf.gz -O z"
echo $cmd >> $log; echo $cmd >& 2; eval $cmd

# 4. Make input for PLINK
cmd="plink --threads 12 --vcf ${dir}/merged.vcf.gz --make-bed --out ${dir}/merged --allow-extra-chr"
echo $cmd >> $log; echo $cmd >& 2; eval $cmd

# 5. Calculate IBD 
cmd="plink --threads 12 --bfile ${dir}/merged --genome full --out ${dir}/plink --allow-extra-chr"
echo $cmd >> $log; echo $cmd >& 2; eval $cmd

# 6. Move plink.genome to out_dir
cmd="rsync ${dir}/plink.genome ${out_dir}/."
echo $cmd >> $log; echo $cmd >& 2; eval $cmd

# 7. Delete scratch directory
cmd="rm -rf $dir"
echo $cmd >> $log; echo $cmd >& 2; eval $cmd
```