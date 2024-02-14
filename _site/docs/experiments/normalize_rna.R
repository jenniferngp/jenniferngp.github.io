# Prepare phenotype data
my.invnorm = function(x)
{
    res = rank(x)
    res = qnorm(res/(length(res)+0.5))
    return(res)
}

transform_standard_normal = function(df)
{
    message("Quantile normalizing across genes per sample")
    df                           = as.matrix(df)
    data_valid_expressed_full_qn = normalize.quantiles(df, copy=FALSE)
    rownames(data_valid_expressed_full_qn) = rownames(df)
    colnames(data_valid_expressed_full_qn) = colnames(df)
    
    message("Inverse normalizing across samples per gene")
    input_mat                    = as.data.frame(t(apply(t(data_valid_expressed_full_qn), 2, my.invnorm)))
    
    return(input_mat)
}

normalize_exp = function(config)
{
    library(edgeR)
    counts = add_rownames(fread(config$input_phenotype_count_matrix, data.table = F))
    tpm = add_rownames(fread(config$input_phenotype_tpm_matrix, data.table = F))

    message("TMM normalize across all genes")
    # https://www.biostars.org/p/317701/
    dge = DGEList(counts=as.matrix(counts), group=colnames(counts))
    dge = calcNormFactors(dge, method = "TMM")
    tmm = cpm(dge)

    message(paste("Filtering for expressed genes"))
    message(paste("Require:", ">=", config$expressed_counts, "counts (unnormalized)", "in >=", paste0(as.double(config$expressed_pct) * 100, "%"), "samples"))
    message(paste("Require:", ">=", config$expressed_tpm, "TPM", "in >=", paste0(as.double(config$expressed_pct) * 100, "%"), "samples"))
    message(paste("Starting:", nrow(counts), nrow(tpm), "elements"))

    expressed = as.matrix(tpm)
    expressed[as.matrix(tpm) <  as.double(config$expressed_tpm)] = 0
    expressed[as.matrix(tpm) >= as.double(config$expressed_tpm)] = 1

    tpm_f = tpm[rowSums(expressed) >= (as.double(config$expressed_pct) * ncol(tpm)),]

    expressed = as.matrix(counts)
    expressed[as.matrix(counts) <  as.double(config$expressed_counts)] = 0
    expressed[as.matrix(counts) >= as.double(config$expressed_counts)] = 1

    counts_f = counts[rowSums(expressed) >= (as.double(config$expressed_pct) * ncol(counts)),]

    expressed = intersect(rownames(tpm_f), rownames(counts_f))

    tpm_f = tpm_f[expressed,]
    counts_f = counts_f[expressed,]

    message("Removing sex chromosomal genes")
    length(unique(expressed))
    auto_genes = fread("/reference/private/Gencode.v44lift38/gene_info.txt", data.table = F) %>% filter(chrom %in% paste0("chr", c(1:22)))
    expressed = expressed[which(expressed %in% auto_genes$gene_id)]
    length(unique(expressed))

    # Filter by expressed autosomal genes
    tmm_f = as.matrix(tmm[expressed,]) 

    # Quantile normalize and inverse norm transform across samples
    tmm_f_norm = transform_standard_normal(tmm_f) 

    message(paste("Expressed:", length(unique(expressed)), nrow(counts_f[expressed,]), nrow(tpm_f[expressed,]), nrow(tmm_f[expressed,]), "elements"))
    message(paste("Samples:", ncol(tmm_f_norm)))
    
    return(list("all_tmm"          = tmm,
                "all_counts"       = counts,
                "all_tpm"          = tpm,
                "expressed_tmm"    = tmm_f[expressed,], 
                "expressed_tpm"    = tpm_f[expressed,], 
                "expressed_counts" = counts_f[expressed,], 
                "normalized_tmm"   = tmm_f_norm[expressed,], 
                "element_ids"      = expressed, 
                "phenotype_ids"    = colnames(tmm_f_norm)))

}