---
layout: default
title: FIMO
parent: Other
nav_order: 1
permalink: /docs/other/trung_hap
---

1. Get the chromosome and positions for each SNP

2. Set filename to write sequences to

file = "sequences.txt"

3. Set window from SNP position 

window = 30

3. Loop through SNPs to, 1) extract sequence from fasta, 2) write original sequence, 3) replace allele with other allele, and 4) write the altered sequence

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


