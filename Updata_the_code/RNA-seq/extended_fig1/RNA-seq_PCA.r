#set dir
setwd("C:/Users/you/Desktop/TGEV101")
#loading
df <- read.table("deseq2_Mock_VS_TGEV_read_counts.txt",header = T,sep = "\t")
head(df)
#construct expression matrix
count_matrix1 <- as.matrix(df)
#construct factor
group_list1 <- factor(c(rep("Mock",3),rep("TGEV",3)))
#construct group df
coldata1 <- data.frame(row.names = colnames(count_matrix1),group_list1)
#construct dds and view
library(DESeq2)
dds1 <- DESeqDataSetFromMatrix(countData = round(count_matrix1),
                              colData = coldata1,
                              design = ~group_list1)
head(dds1)
#standard
rld <- rlog(dds1)
head(rld)
#construct pca plot
pca_data <- plotPCA(rld, intgroup=c("group_list1"),returnData=T)
percentVar <- round(100 * attr(pca_data, "percentVar"),2)
#plot
library(ggplot2)
library(ggrepel)
pdf("pca.pdf",width=6,height = 4)
ggplot(pca_data,aes(PC1,PC2,color=group))+
  geom_point(size=5)+
  scale_color_manual(values = c("#0e4e8b","#af4e47"))+
  theme_classic()+
  labs(title="PCA",color="Group",x=paste("PC1:",percentVar[1],"%variance"),y=paste("PC2:",percentVar[2],"%variance"))+
  geom_text_repel(pca_data,mapping=aes(label=name),size=3,color="black")
dev.off()
