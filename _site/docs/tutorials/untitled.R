
ids = c("pgc-bip2021-all.vcf", "PGC3_SCZ_wave3_primary_autosome.public.v3.vcf")


for (id in ids)
{
	work_dir = "/projects/CARDIPS/analysis/epigenome_resource/analyses/jennifer/gwas_liftover/hg38_summary_statistics"

	message(paste("Opening:", paste(work_dir, paste(id, "hg38.tsv.gz", sep = "."), sep = "/")))
	data = fread(paste(work_dir, paste(id, "hg38.tsv.gz", sep = "."), sep = "/"), data.table = F)

	i1 = which(colnames(data) == "a1")
	i2 = which(colnames(data) == "a2")

	colnames(data)[i1] = "a2"
	colnames(data)[i2] = "a1"

	new_file = paste(work_dir, paste(id, "hg38.tsv", sep = "."), sep = "/")
	fwrite(data, new_file, row.names = F, sep = "\t")
	message(paste(new_file, "saved!"))	

	cmd = paste("rm", paste(work_dir, paste(id, "hg38.tsv.gz", sep = "."), sep = "/"), paste(work_dir, paste(id, "hg38.tsv.gz.tbi", sep = "."), sep = "/"))
	message(cmd); system(cmd)

	cmd = paste("bgzip", new_file)
	message(cmd); system(cmd)

	cmd = paste("tabix -S 1 -s 1 -b 2 -e 2", paste(new_file, "gz", sep = "."))
	message(cmd); system(cmd)
}

for file in *; do
  newname="${file/ppc_eqtls./}"
  if [ "$file" != "$newname" ]; then
    mv "$file" "$newname"
  fi
done

for i in {1..22}; do if [ ! -f chr${i} ]; then cmd=`grep "Rscript" /projects/CARDIPS/analysis/epigenome_resource/analyses/jennifer/garfield/logs/ld.e9045927.${i}`; echo $cmd; eval $cmd; fi; done


data = fread("Chronic_pancreatitis.UKB_SAIGE_FinnGen_r3_meta1_sorted.txt.gz", data.table = F)
colnames(data) = c("chr", "pos", "rsid", "a1", "a2", "beta", "se", "p", "direction")
maf = as.data.frame(rbindlist(lapply(c(1:22), function(x) { 
	file = paste("/frazer01/home/jennifer/references/1kg/hg38_af", paste0("chr", x, ".af"), sep = "/")
	af = fread(file, data.table = F)
	colnames(af) = c("chr", "pos", "a1", "a2", "af")
	af$maf = ifelse(af$af > 0.5, 1-af$af, af$af)
	af = af[af$pos %in% data[data$chr == x,]$pos,]
	return(af)
})))

data2 = merge(data, maf[,c("chr", "pos", "maf")], by = c("chr", "pos")) %>% filter(!is.na(maf))
data2$ncases_finngen = manifest[manifest$trait == "chronic_pancreatitis",]$ncases_finngen
data2$ncases_ukbb = manifest[manifest$trait == "chronic_pancreatitis",]$ncases_ukbb
data2$ncontrols_finngen = manifest[manifest$trait == "chronic_pancreatitis",]$ncontrols_finngen
data2$ncontrols_ukbb = manifest[manifest$trait == "chronic_pancreatitis",]$ncontrols_ukbb
data2$ntotal = manifest[manifest$trait == "chronic_pancreatitis",]$ntotal
data2$cases_fr = manifest[manifest$trait == "chronic_pancreatitis",]$cases_fr
data2$a1 = toupper(data2$a1)
data2$a2 = toupper(data2$a2)
fwrite(data2, "/projects/CARDIPS/analysis/epigenome_resource/analyses/jennifer/gwas_liftover/hg38_summary_statistics/Chronic_pancreatitis.UKB_SAIGE_FinnGen_r3_meta1.txt", row.names = F, sep = "\t")

data2 = merge(data2, manifest[manifest$trait == "chronic_pancreatitis", 
	c("ncontrols_finngen", "ncases_finngen", "ncontrols_ukbb", "ncontrols_finngen", "ntotal", "cases_fr")])

