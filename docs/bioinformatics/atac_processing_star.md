---
layout: default
permalink: /doc/bioinformatics/atac_processing_star
nav_order: 2
parent: 1.1 ATAC-seq
title: 1.1.1 Data Processing using STAR
grand_parent: "1. Bioinformatics Tutorials 🧬"
---

## ATAC-seq Processing using STAR 

## Pre-requisites
- STAR (https://github.com/alexdobin/STAR)
- samtools (through conda or build your own https://www.htslib.org/download/)
- RSEM (through conda or build your own https://github.com/deweylab/RSEM?tab=readme-ov-file#compilation)

## 0. Make scratch directory
```sh
dir=`mktemp -d -p scratch`
```

## 1. Align
```sh
id= #sample id
project= #project_id
out_dir= #ouput directory
reference=/reference/private/STAR/hg19_gencode34
STAR \
--runThreadN 8 \
--alignIntronMax 1 \
--genomeDir $reference \
--genomeLoad NoSharedMemory \
--readFilesCommand zcat \
--readFilesIn ${dir}/R1.fastq.gz ${dir}/R2.fastq.gz \
--outSAMattributes All \
--outSAMunmapped Within \
--outSAMattrRGline ID:1 PL:ILLUMINA PU:${project} LB:${id} SM:${id} \
--outFilterMultimapNmax 20 \
--outFilterMismatchNmax 999 \
--outFilterMismatchNoverLmax 0.04 \
--seedSearchStartLmax 20 \
--outFilterScoreMinOverLread 0.1 \
--outFilterMatchNminOverLread 0.1 \
--outSAMtype BAM Unsorted \
--outFileNamePrefix ${out_dir}/
```
## 2. Mark duplicates.
```sh
bam=Aligned.out.bam
name=`basename $bam ".bam"`
samtools sort -n -m 2G -@ 8 $bam -o ${dir}/${name}.nsorted.bam
samtools fixmate -m -@ 8 ${dir}/${name}.nsorted.bam ${dir}/${name}.fixmate.bam
samtools sort -m 2G -@ 8 -o ${dir}/${name}.sorted.bam ${dir}/${name}.fixmate.bam
samtools markdup -@ 8 ${dir}/${name}.sorted.bam ${out_dir}/${name}.mdup.bam
samtools index -@ 8 ${out_dir}/${name}.mdup.bam
```

## 3. Get mapping stats (duplicates, chrM reads, etc.)
```sh
samtools flagstat -@ 8 ${out_dir}/${name}.mdup.bam > ${out_dir}/${name}.mdup.flagstat
samtools idxstats -@ 8 ${out_dir}/${name}.mdup.bam > ${out_dir}/${name}.mdup.idxstats
samtools stats -@ 8 ${out_dir}/${name}.mdup.bam > ${out_dir}/${name}.mdup.stats
```

## 4. Filter reads
- Remove duplicates (-F 1024)
- Retain reads with mapping quality > 20 (-q 20)
- Retain reads in proper pair (-f 2)
- Retain fragments between 38-2000 bp. 
```sh
chrs=(`seq 1 22` X Y)
chrs=chr`echo ${chrs[@]} | sed 's/ / chr/g'`
samtools view -h -q 20 -f 2 -F 1024 ${out_dir}/${name}.mdup.bam $chrs |\
awk 'function abs(v) {return v < 0 ? -v : v}; substr($0,1,1)=="@" || (abs($9) >= 38 && abs($9) <= 2000)' |\
samtools view -b -@ 4 > ${out_dir}/${name}.filt.bam
```

## 5. Index
```sh
samtools index ${out_dir}/${name}.filt.bam
```
