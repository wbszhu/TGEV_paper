library(ggplot2)
library(clusterProfiler)
library(org.Hs.eg.db)
gene_all <- read.table("pi_specific_p_anchor_degs_10kb.txt",header=F,sep="\t")
all_entrezid <- bitr(gene_all$V1,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Hs.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #Gene list (converted IDs)
               keyType = "kegg",  #Specified gene ID type, default is ENTREZID
               organism ="hsa",  #Species-corresponding org package
               pvalueCutoff = 1,  #p-value threshold
               pAdjustMethod = "fdr",  #Multiple hypothesis testing correction method
               qvalueCutoff = 1)  #q-value threshold
kegg <- as.data.frame(kegg)
kegg1 <- subset(kegg, kegg$pvalue<0.05)
kegg1$type <- "KEGG"

write.table(kegg1, 'pi_specific_loop_anchorgene_pvalue0.05_kegg_10kb.txt', sep = '\t', quote = FALSE, row.names = FALSE)
