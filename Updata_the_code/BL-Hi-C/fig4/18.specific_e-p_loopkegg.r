library(ggplot2)
library(clusterProfiler)
library(org.Hs.eg.db)
gene_all <- read.table("pi_specific_p_anchor_degs_10kb.txt",header=F,sep="\t")
all_entrezid <- bitr(gene_all$V1,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Hs.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #基因列表(转换的ID)
               keyType = "kegg",  #指定的基因ID类型，默认为ENTREZID
               organism ="hsa",  #物种对应的org包
               pvalueCutoff = 1,  #p值阈值
               pAdjustMethod = "fdr",  #多重假设检验校正方
               qvalueCutoff = 1)  #q值阈值
kegg <- as.data.frame(kegg)
kegg1 <- subset(kegg, kegg$pvalue<0.05)
kegg1$type <- "KEGG"

write.table(kegg1, 'pi_specific_loop_anchorgene_pvalue0.05_kegg_10kb.txt', sep = '\t', quote = FALSE, row.names = FALSE)
