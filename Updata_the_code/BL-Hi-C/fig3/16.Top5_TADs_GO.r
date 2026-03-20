#library
library(org.Hs.eg.db)
library(tools)
library(clusterProfiler)

symbol <- read.table('part1.txt', header=F, sep= "\t")
#进行GO的BP富集
BP <- enrichGO(gene = symbol$V9,  #输入基因名
                keyType = "SYMBOL",  
                OrgDb=org.Hs.eg.db,  #注释包
                ont = "BP",   #模式
                pvalueCutoff = 1,  #p值阈值
                pAdjustMethod = "fdr",  #矫正方法
                minGSSize = 1,   
                maxGSSize = 500,  
                readable = TRUE,#输出为SYMBOL，方便阅读
                qvalueCutoff = 1)#q值阈值
BP_df1 <- BP@result
BP_df2 <- subset(BP_df1, BP_df1$pvalue<0.05)#显著水平取0.05
BP_df2$type <- "BP"
if (any(BP_df1$p.adjust < 0.05, na.rm = TRUE)) {
  BP_df3 <- subset(BP_df1, p.adjust < 0.05)
  BP_df3$type <- "BP"
} else {
  BP_df3 <- NULL  # 或者你可以创建一个空 data.frame
}

MF <- enrichGO(gene = symbol$V9,  #输入基因名
                keyType = "SYMBOL",  
                OrgDb=org.Hs.eg.db,  #注释包
                ont = "MF",   #模式
                pvalueCutoff = 1,  #p值阈值
                pAdjustMethod = "fdr",  #矫正方法
                minGSSize = 1,   
                maxGSSize = 500,  
                readable = TRUE,#输出为SYMBOL，方便阅读
                qvalueCutoff = 1)#q值阈值
MF_df1 <- MF@result
MF_df2 <- subset(MF_df1, MF_df1$pvalue<0.05)#显著水平取0.05
MF_df2$type <- "MF"
if (any(MF_df1$p.adjust < 0.05, na.rm = TRUE)) {
  MF_df3 <- subset(MF_df1, p.adjust < 0.05)
  MF_df3$type <- "MF"
} else {
  MF_df3 <- NULL  # 或者你可以创建一个空 data.frame
}

CC <- enrichGO(gene = symbol$V9,  #输入基因名
                keyType = "SYMBOL",  
                OrgDb=org.Hs.eg.db,  #注释包
                ont = "CC",   #模式
                pvalueCutoff = 1,  #p值阈值
                pAdjustMethod = "fdr",  #矫正方法
                minGSSize = 1,   
                maxGSSize = 500,  
                readable = TRUE,#输出为SYMBOL，方便阅读
                qvalueCutoff = 1)#q值阈值
CC_df1 <- CC@result
CC_df2 <- subset(CC_df1, CC_df1$pvalue<0.05)#显著水平取0.05
CC_df2$type <- "CC"
if (any(CC_df1$p.adjust < 0.05, na.rm = TRUE)) {
  CC_df3 <- subset(CC_df1, p.adjust < 0.05)
  CC_df3$type <- "CC"
} else {
  CC_df3 <- NULL  # 或者你可以创建一个空 data.frame
}

pvalue_tab <- rbind(MF_df2,BP_df2,CC_df2)
write.table(pvalue_tab, "./go_pvalue0.05/part1_pvalue0.05_go.txt", sep = "\t", row.names = FALSE, quote=FALSE)

padj_tab <- rbind(MF_df3,BP_df3,CC_df3)
if (!is.null(padj_tab) && nrow(padj_tab) > 0) {
  write.table(padj_tab, "./go_padj0.05/part1_padj0.05_go.txt", sep = "\t", quote = FALSE, row.names = FALSE)
}
