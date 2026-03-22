#library
library(org.Hs.eg.db)
library(tools)
library(clusterProfiler)

symbol <- read.table('stableb_gene.txt', header=F, sep= "\t")
#Perform GO BP enrichment
BP <- enrichGO(gene = symbol$V1,  #Input gene names
                keyType = "SYMBOL",
                OrgDb=org.Hs.eg.db,  #Annotation package
                ont = "BP",   #Ontology type
                pvalueCutoff = 1,  #p-value threshold
                pAdjustMethod = "fdr",  #Correction method
                minGSSize = 1,
                maxGSSize = 500,
                readable = TRUE,#Output as SYMBOL for readability
                qvalueCutoff = 1)#q-value threshold
BP_df1 <- BP@result
BP_df2 <- subset(BP_df1, BP_df1$pvalue<0.05)#Significance level set to 0.05
BP_df2$type <- "BP"
if (any(BP_df1$p.adjust < 0.05, na.rm = TRUE)) {
  BP_df3 <- subset(BP_df1, p.adjust < 0.05)
  BP_df3$type <- "BP"
} else {
  BP_df3 <- NULL  # Or you can create an empty data.frame
}

MF <- enrichGO(gene = symbol$V1,  #Input gene names
                keyType = "SYMBOL",
                OrgDb=org.Hs.eg.db,  #Annotation package
                ont = "MF",   #Ontology type
                pvalueCutoff = 1,  #p-value threshold
                pAdjustMethod = "fdr",  #Correction method
                minGSSize = 1,
                maxGSSize = 500,
                readable = TRUE,#Output as SYMBOL for readability
                qvalueCutoff = 1)#q-value threshold
MF_df1 <- MF@result
MF_df2 <- subset(MF_df1, MF_df1$pvalue<0.05)#Significance level set to 0.05
MF_df2$type <- "MF"
if (any(MF_df1$p.adjust < 0.05, na.rm = TRUE)) {
  MF_df3 <- subset(MF_df1, p.adjust < 0.05)
  MF_df3$type <- "MF"
} else {
  MF_df3 <- NULL  # Or you can create an empty data.frame
}

CC <- enrichGO(gene = symbol$V1,  #Input gene names
                keyType = "SYMBOL",
                OrgDb=org.Hs.eg.db,  #Annotation package
                ont = "CC",   #Ontology type
                pvalueCutoff = 1,  #p-value threshold
                pAdjustMethod = "fdr",  #Correction method
                minGSSize = 1,
                maxGSSize = 500,
                readable = TRUE,#Output as SYMBOL for readability
                qvalueCutoff = 1)#q-value threshold
CC_df1 <- CC@result
CC_df2 <- subset(CC_df1, CC_df1$pvalue<0.05)#Significance level set to 0.05
CC_df2$type <- "CC"
if (any(CC_df1$p.adjust < 0.05, na.rm = TRUE)) {
  CC_df3 <- subset(CC_df1, p.adjust < 0.05)
  CC_df3$type <- "CC"
} else {
  CC_df3 <- NULL  # Or you can create an empty data.frame
}

pvalue_tab <- rbind(MF_df2,BP_df2,CC_df2)
write.table(pvalue_tab, "./go_pvalue0.05/stableb_pvalue0.05_go.txt", sep = "\t", row.names = FALSE, quote=FALSE)

padj_tab <- rbind(MF_df3,BP_df3,CC_df3)
if (!is.null(padj_tab) && nrow(padj_tab) > 0) {
  write.table(padj_tab, "./go_padj0.05/stableb_padj0.05_go.txt", sep = "\t", quote = FALSE, row.names = FALSE)
}
