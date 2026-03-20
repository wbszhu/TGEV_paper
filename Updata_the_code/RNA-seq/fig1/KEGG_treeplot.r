library(enrichplot)
library(clusterProfiler)
library(org.Hs.eg.db)
library(ggplot2)

gene_all <- read.table("DEGs.txt",header=T,sep="\t")
gene_all$ensembl_id <- row.names(gene_all)
trans <- read.table("id_name.txt",header = F,sep = "\t")
colnames(trans) <- c("ensembl_id","gene_name")
merge_all <- merge(gene_all,trans,by="ensembl_id")
#keytypes(org.Ss.eg.db)
all_entrezid <- bitr(merge_all$gene_name,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Hs.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #基因列表(转换的ID)
                   keyType = "kegg",  #指定的基因ID类型，默认为ENTREZID
                   organism ="hsa",  #物种对应的org包
                   pvalueCutoff = 0.05,  #p值阈值
                   pAdjustMethod = "fdr",  #多重假设检验校正方
                   qvalueCutoff = 0.05)  #q值阈值

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

kegg_subset <- kegg
kegg_subset@result <- kegg@result %>%
filter(Description %in% selected_pathways)

kegg_sim <- pairwise_termsim(kegg_subset, method = "JC")

treep <- treeplot(kegg_sim)

ggsave(treep, filename="treeplot.pdf", width=12, height=10)