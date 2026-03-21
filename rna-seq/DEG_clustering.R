#Load packages required for heatmap
library(pheatmap)
library(vegan)
#Read data
setwd("./")
data1 <- read.table("DEGs.txt",header = T,sep = "\t")
data1 <- subset(data1,pvalue<0.005)
data2 <- read.table("deseq2_Mock_VS_TGEV_TPM.txt",header = T,sep = "\t")
#Merge two datasets by gene name to extract TPM values of differentially expressed genes
data3 <- merge(data1,data2,by="row.names",all=FALSE)
row.names(data3) <- data3$Row.names
data3 <- data3[,8:14]
#Annotate groups for clustering
annotation_col <- data.frame(group=c(rep("Mock",3),rep("TGEV",3)))
annotation_row <- data.frame(sig=data3$sig)
row.names(annotation_row) <- rownames(data3)
row.names(annotation_col) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
#Plot
data4 <- data3[,-1]
pdf("pheatmap.pdf",width=5,height = 5)
pheatmap(data4,scale = "row",
         show_rownames=F,
         show_colnames=T,
         cluster_row=T,
         cluster_col=T,
         border_color=NA,
         cellwidth = 30,
         annotation_col = annotation_col,
         annotation_row = annotation_row,
         cutree_row = 2, cutree_cols = 2,
         colorRampPalette(c("#56549d","#bbbbd5","#edb9bd","#db6b67"))(50))
         #filename = "pheatmap.pdf")
dev.off()
