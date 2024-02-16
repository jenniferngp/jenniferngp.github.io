---
layout: default
nav_order: 3
title: 1.2.1 Data Processing and Expression Quantification
parent: 1.2 RNA-seq
grand_parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/rna_processing
---

# Data Processing and Expression Quantification

Credit to former Frazer Lab members

## 0. Make scratch directory
```sh
dir=`mktemp -d -p scratch`
```

## 1. Set reference
```sh
reference_star=/reference/private/STAR/hg38_gencode44/reference
reference_rsem=/reference/private/RSEM/hg38_gencode44/reference/hg38_gencode44
```

## 2. STAR Alignment
```sh
date >& 2
in_files=( ${dir}/R1.fastq ${dir}/R2.fastq )
STAR \
--runThreadN 12 \
--genomeDir ${reference_star} \
--genomeLoad NoSharedMemory \
--readFilesIn ${in_files[@]} \
--outSAMattributes All \
--outSAMunmapped Within \
--outSAMattrRGline ID:1 PL:ILLUMINA PU:CARDIPS LB:${name} SM:${name} \
--outFilterMultimapNmax 20 \
--outFilterMismatchNmax 999 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outSAMtype BAM Unsorted \
--outFileNamePrefix ${dir}/ \
--quantMode TranscriptomeSAM
```

## 3. Sort. Fill mate coordinates. Index
```sh
samtools sort -m 2G -n -o ${dir}/Aligned.out.namesorted.bam -@ 12 ${dir}/Aligned.out.bam"
samtools fixmate -@ 12 -m ${dir}/Aligned.out.namesorted.bam ${dir}/Aligned.out.namesorted.fixmate.bam"
samtools sort -m 2G -o ${dir}/Aligned.out.sorted.bam -@ 12 ${dir}/Aligned.out.namesorted.fixmate.bam
samtools index -@ 12 ${dir}/Aligned.out.sorted.bam ${dir}/Aligned.out.sorted.bam.bai
```

## 4. Mark duplicates
```sh
date >& 2
cmd="samtools markdup -@ 12 -s -T ${dir}/temp ${dir}/Aligned.out.sorted.bam ${dir}/Aligned.out.sorted.mdup.bam"
echo $cmd >& 2; eval $cmd
date >& 2
cmd="samtools index -@ 12 ${dir}/Aligned.out.sorted.mdup.bam ${dir}/Aligned.out.sorted.mdup.bam.bai"
echo $cmd >& 2; eval $cmd
```

## 5. Get mapping stats 
```sh
samtools flagstat -@ 12 ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.bam.flagstat
samtools idxstats -@ 12 ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.bam.idxstats
samtools stats -@ 12 ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.bam.stats
```

## 6. Reformat header for PICARD
```sh
samtools view -H ${dir}/Aligned.out.sorted.mdup.bam | sed 's,^@RG.*,@RG\tID:None\tSM:None\tLB:None\tPL:Illumina,g' | samtools reheader - ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.reheader.bam
```

## 7. Run Picard to get more mapping stats
Useful stats from this are % intergenic bases, % mRNA bases, % ribosomal bases
```sh
refFlat=/reference/public/UCSC/hg38/refFlat.txt.gz
picard CollectRnaSeqMetrics \
I=${dir}/Aligned.out.sorted.mdup.reheader.bam \
O=${dir}/picard.RNA_Metrics \
VALIDATION_STRINGENCY=SILENT \
REF_FLAT=$refFlat \
STRAND=NONE
```

## 8. Run RSEM 
Generates read counts, TPM, and RPKM for each gene in the GTF file. Requires the toTranscriptome.out.bam outputted by STAR
```sh
cmd="rsem-calculate-expression \
--bam \
--num-threads 16 \
--no-bam-output \
--seed 3272015 \
--estimate-rspd \
--forward-prob 0"
if [ ${#in_files[@]} -gt 1 ]; then
   cmd=$cmd" --paired-end"
fi
cmd=$cmd" ${dir}/Aligned.toTranscriptome.out.bam ${reference_rsem} ${dir}/rsem"
eval $cmd
```





