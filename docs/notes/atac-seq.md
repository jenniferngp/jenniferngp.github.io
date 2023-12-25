---
layout: default
parent: Notes
permalink: /doc/notes/atac-seq
nav_order: 1
title: ATAC-seq
---

# ATAC-seq

Last updated: 12-19-2023

ATAC-seq stands for **A**ssay for **T**ransposase-**A**ccessible **C**hromatin with Sequencing. 

ATAC-seq is a widely adopted technique for profiling open chromatin regions throughout the genome. Recently, it has been extended to infer transcription factor occupancy by leveraging Tn5 insertion profiles, giving rise to a technique called digital ATAC-seq footprinting. By integrating these two types of information, ATAC-seq enables the identification of regions exhibiting active regulatory activity, such as enhancers and promoters, and facilitates the elucidation of the transcription factors involved in coordinating subsequent transcriptional processes.

ATAC-seq method was first published in 2013 by [Buenostro et al., Nature Methods](10.1038/nmeth.2688) at the Greenleaf Lab @ Stanford. 

## Role of Tn5 Transposase in ATAC-seq

Tn5 is a hyperactive transposase enzyme derived from the bacterium Tn5. It is used in ATAC-seq to efficiently fragment accessible DNA sites and incorporate sequencing adapaters. Tn5 also preferentially targets open chromatin regions because steric hindrance at non-accessible regions makes it difficult for adaptor incorporation. 

## How to process ATAC-seq data (Frazer Lab Pipeline)

1. Align (BWA and STAR produce very similar results)
```sh
reference=/reference/private/STAR/hg19_gencode34
STAR --runThreadN 8 --alignIntronMax 1 --genomeDir $reference \
--genomeLoad NoSharedMemory --readFilesCommand zcat \
--readFilesIn ${dir}/R1.fastq.gz ${dir}/R2.fastq.gz \
--outSAMattributes All --outSAMunmapped Within \
--outSAMattrRGline ID:1 PL:ILLUMINA PU:CARDIPS LB:${id} SM:${id} \
--outFilterMultimapNmax 20 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.04 \
--seedSearchStartLmax 20 --outFilterScoreMinOverLread 0.1 --outFilterMatchNminOverLread 0.1 \
--outSAMtype BAM Unsorted --outFileNamePrefix ${out_dir}/
```
2. Sort. Fixmate. Mark duplicates
```sh
samtools sort -n -m 2G -@ 8 $bam -o ${dir}/${name}.nsorted.bam
samtools fixmate -m -@ 8 ${dir}/${name}.nsorted.bam ${dir}/${name}.fixmate.bam
samtools sort -m 2G -@ 8 -o ${dir}/${name}.sorted.bam ${dir}/${name}.fixmate.bam
samtools markdup -@ 8 ${dir}/${name}.sorted.bam ${out_dir}/${name}.mdup.bam
samtools index -@ 8 ${out_dir}/${name}.mdup.bam
```

3. Optional: Get mapping stats (duplicates, chrM reads, etc.)
```sh
samtools flagstat -@ 8 ${out_dir}/${name}.mdup.bam > ${out_dir}/${name}.mdup.flagstat
samtools idxstats -@ 8 ${out_dir}/${name}.mdup.bam > ${out_dir}/${name}.mdup.idxstats
samtools stats -@ 8 ${out_dir}/${name}.mdup.bam > ${out_dir}/${name}.mdup.stats
```

4. Remove duplicates (-F 1024). Filter reads with mapping quality > 20 (-q 20). Keep reads in proper pair (-f 2). Keep fragments between 38-2000 bp. 
```sh
chrs=(`seq 1 22` X Y)
chrs=chr`echo ${chrs[@]} | sed 's/ / chr/g'`
samtools view -h -q 20 -f 2 -F 1024 ${out_dir}/${name}.mdup.bam $chrs |\
awk 'function abs(v) {return v < 0 ? -v : v}; substr($0,1,1)=="@" || (abs($9) >= 38 && abs($9) <= 2000)' |\
samtools view -b -@ 4 > ${out_dir}/${name}.filt.bam
```

5. Index
```sh
samtools index ${out_dir}/${name}.filt.bam
```

6. Call narrow peaks
```sh
macs2 callpeak -f BAMPE -g hs -t ${out_dir}/${name}.filt.bam -n ${name} --outdir ${out_dir} --nomodel --shift -100 --extsize 200 --call-summits
```

7. Call broad peaks
```sh
macs2 callpeak -f BAMPE -g hs -t ${out_dir}/${name}.filt.bam -n ${name} --outdir ${out_dir} --nomodel --shift -100 --extsize 200 --broad
```

8. Count reads in promoters
```sh
samtools view -c -L ${promoters_bed} ${out_dir}/${name}.filt.bam > ${out_dir}/reads_in_promoter.txt
```

8. Convert peak file to saf (peaks2saf.pl). Count reads in each peak (featureCounts).
```sh
cat $peak | peaks2saf.pl > ${saf}
featureCounts -p -T 4 --donotsort -F SAF -a ${saf} -o ${out_file} ${out_dir}/${name}.filt.bam
```


Next steps:
10. Remove peaks in blacklisted regions (from ENCODE)
11. TMM normalize read counts using edgeR
12. Generate consensus peaks by merging peaks across samples or selecting a subsample of high-quality samples and call peaks from their merged bam files. 

