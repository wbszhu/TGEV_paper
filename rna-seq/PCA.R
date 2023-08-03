#设置工作目录
setwd("C:/Users/you/Desktop/TGEV101")
#载入数据
df <- read.table("deseq2_Mock_VS_TGEV_read_counts.txt",header = T,sep = "\t")
head(df)
#构建表达矩阵
count_matrix1 <- as.matrix(df)
#构建因子
group_list1 <- factor(c(rep("Mock",3),rep("TGEV",3)))
#构建分组数据框
coldata1 <- data.frame(row.names = colnames(count_matrix1),group_list1)
#构建dds并查看
library(DESeq2)
dds1 <- DESeqDataSetFromMatrix(countData = round(count_matrix1),
                              colData = coldata1,
                              design = ~group_list1)
head(dds1)
#对数据进行标准化并查看
rld <- rlog(dds1)
head(rld)
#构建pca绘图对象
pca_data <- plotPCA(rld, intgroup=c("group_list1"),returnData=T)
percentVar <- round(100 * attr(pca_data, "percentVar"),2)
#绘图
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
