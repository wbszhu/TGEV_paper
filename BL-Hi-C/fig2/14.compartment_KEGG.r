library(ggplot2)
library(clusterProfiler)
library(org.Hs.eg.db)
gene_all <- read.table("b2a_gene.txt",header=F,sep="\t")
all_entrezid <- bitr(gene_all$V1,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Hs.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #Gene list (converted IDs)
               keyType = "kegg",  #Specified gene ID type, default is ENTREZID
               organism ="hsa",  #Organism corresponding org package
               pvalueCutoff = 1,  #p-value threshold
               pAdjustMethod = "fdr",  #Multiple hypothesis testing correction method
               qvalueCutoff = 1)  #q-value threshold
kegg <- as.data.frame(kegg)
kegg1 <- subset(kegg, kegg$pvalue<0.05)
kegg1$type <- "KEGG"
kegg2 <- subset(kegg, kegg$p.adjust<0.05)
kegg2$type <- "KEGG"

write.table(kegg1, 'b2a_pvalue0.05_kegg.txt', sep = '\t', quote = FALSE, row.names = FALSE)
write.table(kegg2, 'b2a_padj0.05_kegg.txt', sep = '\t', quote = FALSE, row.names = FALSE)