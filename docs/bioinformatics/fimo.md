---
layout: default
parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/fimo
nav_order: 4
title: 1.4 FIMO
---

# Using FIMO to determine whether a SNP disrupts a motif occurrence

FIMO stands for "Find Individual Motif Occurrences" and is a software tool that is part of the MEME Suite. FIMO was designed to scan a set of sequences (e.g., DNA or protein sequences) for occurrences of specific motifs, which are patterns that are widespread and presumed to have a biological significance. Often, they indicate sequence-specific binding sites for proteins such as nucleases and transcription factors (TFs). FIMO is useful to identify potential binding sites of TFs or other motif-associated proteins within genomic regions. 

FIMO outputs:

- A p-value for the motif occurrence measuring "the probability of a random sequence of the same length as the motif matching that position of the sequence with as good or better a score". 
- A score for the match of a position in a sequence to a motif, computed by "summing the appropriate entries from each column of the position-dependent scoring matrix that represents the motif".
- A q-value for a motif occurrence defined as "the false discovery rate if the occurrence is accepted as significant".  

Useful links:
- https://meme-suite.org/meme/doc/fimo.html
- https://meme-suite.org/meme/doc/examples/fimo_example_output_files/fimo.html


## 1. Prepare sequences for FIMO

This script processes a list of SNPs by iterating over each one. For every SNP, it retrieves a 30 base pair (bp) sequence surrounding it and saves this sequence to a file. Subsequently, the script swaps the original allele for its alternative allele within this sequence and records the modified sequence as well.

```R
snps2test = c("VAR_1_12345_A_G", "VAR_4_23568372_T_C") # SNPs to test for motif disruption

outfile = "sequences.txt" # name of file to write sequences

window = 30 # considering a 30 bp window from SNP for motif detection
for (snp in snps2test)
{
	chr = unlist(strsplit(snp, "_"))[2]
	pos = as.numeric(unlist(strsplit(snp, "_"))[3])
	ref = unlist(strsplit(snp, "_"))[4]
	alt = unlist(strsplit(snp, "_"))[5]
	start = pos - window
	end = pos + window

	cmd = paste("samtools faidx", "/reference/public/ucsc/hg38/hg38.fa", paste0(paste0("chr", chr), ":", start, "-", end))
	seq = fread(cmd = cmd, header = F)
	seq = as.vector(paste(toupper(seq[2,]$V1), toupper(seq[3,]$V1), sep = ""))

	message(paste("Sequence of interest:", seq))

	write(paste0(">", snp, "-1"), file, append = T)
	write(seq, file, append = T)

	allele_to_replace_with = c(ref, alt)[which(!c(ref, alt) %in% unlist(strsplit(seq, ""))[window+1])]
	message(paste("Allele to replace with:", allele_to_replace_with))

	if (length(allele_to_replace_with) == 1)
	{
		alt_seq = unlist(strsplit(seq, ''))
		alt_seq[window+1] = allele_to_replace_with

	    ref_seq = unlist(strsplit(seq, ''))
	    message(paste( length(ref_seq), paste(ref_seq[1:window], collapse = ""), ref_seq[window+1], paste(ref_seq[window+2:length(ref_seq)], collapse = ""), sep = "-"), appendLF = F)
	    message(paste( length(alt_seq), paste(alt_seq[1:window], collapse = ""), alt_seq[window+1], paste(alt_seq[window+2:length(alt_seq)], collapse = ""), sep = "-"), appendLF = F)

		alt_seq = paste0(alt_seq, collapse = "")

		write(paste0(">", snp, "-2"), file, append = T)
	    write(alt_seq, file, append = T)   

	}
}
```

## 2. Run FIMO

```sh
fimo \
–thresh 0.01 \
–max-stored-scores 1000000 \
–no-qvalue–skip-matched-sequence \
–text \
<motif> \
<sequence-file>
```

## 3. Measure motif disruption 

From a previous study: 
- Currin KW, Erdos MR, Narisu N, Rai V, Vadlamudi S, Perrin HJ, Idol JR, Yan T, Albanus RD, Broadaway KA, Etheridge AS. Genetic effects on liver chromatin accessibility identify disease regulatory variants. The American Journal of Human Genetics. 2021 Jul 1;108(7):1169-89.

>For each motif-variant pair, we selected the strongest motif match (smallest p value) per allele and only retained motif occurrences that matched strongly to at least one allele (p < 1 × 10−4). If different motifs for the same representative TF overlapped the same variant, we selected the motif with the strongest match.

>Similar to a recent study, we quantified the difference in motif match between alleles of a variant using the log ratio of FIMO p values. The FIMO p value for a given motif occurrence is the probability of observing a motif occurrence with the same or greater score, which inherently accounts for differences in score distributions between different motifs. For a given variant-motif pair, we define motif disruption as log10(paw) – log10(pas), where paw and pas are the FIMO p values for the alleles with the weaker and stronger motif match, respectively. As motif disruption is always positive, we classified a motif as disrupted if motif disruption was > 1, corresponding to a 10-fold difference in the FIMO p values between alleles.
