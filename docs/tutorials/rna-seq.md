---
layout: default
parent: Tutorials
permalink: /doc/tutorials/rna-seq
nav_order: 2
title: RNA-seq
---

# RNA-seq

Last updated: 12-19-2023

RNA-seq, or RNA sequencing, is a technique used in molecular biology to analyze the transcriptome of a sample. The transcriptome refers to the complete set of RNA molecules, including mRNA (messenger RNA), rRNA (ribosomal RNA), tRNA (transfer RNA), and other non-coding RNA produced by the cells of an organism or a tissue. Most RNA-seq data measures mRNA levels, and specialized protocols are used for each type of RNA molecule being measured. 

## How to process RNA-seq data (Frazer Lab Pipeline)

0. Make scratch directory
```sh
dir=`mktemp -d -p scratch`
```

1. Set reference
```sh
reference_star=/reference/private/STAR/hg38_gencode44/reference
reference_rsem=/reference/private/RSEM/hg38_gencode44/reference/hg38_gencode44
```

2. STAR Alignment
```sh
date >& 2
in_files=( ${dir}/R1.fastq ${dir}/R2.fastq )
cmd="STAR \
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
--quantMode TranscriptomeSAM"
echo $cmd >& 2; eval $cmd
```

3. Sort. Fill mate coordinates. Index
```sh
date >& 2
cmd="samtools sort -m 2G -n -o ${dir}/Aligned.out.namesorted.bam -@ 12 ${dir}/Aligned.out.bam"
echo $cmd >& 2; eval $cmd
date >& 2
cmd="samtools fixmate -@ 12 -m ${dir}/Aligned.out.namesorted.bam ${dir}/Aligned.out.namesorted.fixmate.bam"
echo $cmd >& 2; eval $cmd
date >& 2
cmd="samtools sort -m 2G -o ${dir}/Aligned.out.sorted.bam -@ 12 ${dir}/Aligned.out.namesorted.fixmate.bam"
echo $cmd >& 2; eval $cmd
date >& 2
cmd="samtools index -@ 12 ${dir}/Aligned.out.sorted.bam ${dir}/Aligned.out.sorted.bam.bai"
echo $cmd >& 2; eval $cmd
```

4. Mark duplicates
```sh
date >& 2
cmd="samtools markdup -@ 12 -s -T ${dir}/temp ${dir}/Aligned.out.sorted.bam ${dir}/Aligned.out.sorted.mdup.bam"
echo $cmd >& 2; eval $cmd
date >& 2
cmd="samtools index -@ 12 ${dir}/Aligned.out.sorted.mdup.bam ${dir}/Aligned.out.sorted.mdup.bam.bai"
echo $cmd >& 2; eval $cmd
```

5. Get mapping stats (total number reads, total mapped, total paired reads, total dupliciates, etc.)
```sh
date >& 2
cmd="samtools flagstat -@ 12 ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.bam.flagstat"
echo $cmd >& 2; eval $cmd
date >& 2
cmd="samtools idxstats -@ 12 ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.bam.idxstats"
echo $cmd >& 2; eval $cmd
date >& 2
cmd="samtools stats -@ 12 ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.bam.stats"
echo $cmd >& 2; eval $cmd
```

6. Run RSEM to generate read counts, TPM, and RPKM. Uses Transcriptome BAM file generated from STAR. 
```sh
date >& 2
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
echo $cmd >& 2; eval $cmd
```

7. Reformat header for PICARD
```sh
date >& 2
cmd="samtools view -H ${dir}/Aligned.out.sorted.mdup.bam | sed 's,^@RG.*,@RG\tID:None\tSM:None\tLB:None\tPL:Illumina,g' | samtools reheader - ${dir}/Aligned.out.sorted.mdup.bam > ${dir}/Aligned.out.sorted.mdup.reheader.bam"
echo $cmd >& 2; eval $cmd
```

8. Run PICARD to get more stats (pct_mrna_bases, pct_intergenic_bases, etc.)
```sh
date >& 2
refFlat=/reference/public/UCSC/hg38/refFlat.txt.gz
cmd="picard CollectRnaSeqMetrics \
I=${dir}/Aligned.out.sorted.mdup.reheader.bam \
O=${dir}/picard.RNA_Metrics \
VALIDATION_STRINGENCY=SILENT \
REF_FLAT=$refFlat \
STRAND=NONE"
echo $cmd >& 2; eval $cmd
```


