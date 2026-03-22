library(enrichplot)
library(clusterProfiler)
library(org.Hs.eg.db)
library(ggplot2)
setwd("/path/to/rnaseq/data")
#read DEGs and conversion id to name
gene_all <- read.table("DEGs.txt",header=T,sep="\t")
gene_all$ensembl_id <- row.names(gene_all)
trans <- read.table("id_name.txt",header = F,sep = "\t")
colnames(trans) <- c("ensembl_id","gene_name")
merge_all <- merge(gene_all,trans,by="ensembl_id")
#keytypes(org.Hs.eg.db)
all_entrezid <- bitr(merge_all$gene_name,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Hs.eg.db)
#kegg analysis
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #gene list (converted IDs)
                   keyType = "kegg",  #specified gene ID type, default is ENTREZID
                   organism ="hsa",  #organism-specific org package
                   pvalueCutoff = 0.05,  #p-value threshold
                   pAdjustMethod = "fdr",  #multiple hypothesis testing correction method
                   qvalueCutoff = 0.05)  #q-value threshold
#conversion kegg result to df
kegg_subset <- kegg
kegg_subset@result <- kegg@result %>%

#select kegg enrich pathway
selected_pathways <- c(
    "MAPK signaling pathway",
    'FoxO signaling pathway',
    'Human T-cell leukemia virus 1 infection',
    'Chronic myeloid leukemia',
    'TNF signaling pathway',
    'Hippo signaling pathway',
    'Axon guidance',
    'TGF-beta signaling pathway',
    'NF-kappa B signaling pathway',
    'Steroid biosynthesis',
    'PI3K-Akt signaling pathway',
    'ErbB signaling pathway',
    'AMPK signaling pathway',
    'Transcriptional misregulation in cancer',
    'RNA polymerase',
    'p53 signaling pathway',
    'JAK-STAT signaling pathway'
)
#get select pathway pvalue et al
filter(Description %in% selected_pathways)
#cluster
kegg_sim <- pairwise_termsim(kegg_subset, method = "JC")
#tree plot
treep <- treeplot(kegg_sim)
#save plot
ggsave(treep, filename="treeplot.pdf", width=12, height=10)