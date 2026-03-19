#设置工作路径
setwd("C:/Users/you/Desktop")
TPM <- read.table("deseq2_Mock_VS_TGEV_TPM.txt",header = T,row.names = 1,sep = "\t")
sample_cor <- cor(TPM)
head(sample_cor)
library(pheatmap)
heatmap <- pheatmap(sample_cor,
                    cluster_rows = FALSE,
                    cluster_cols = FALSE,
                    scale="none",
                    cellwidth = 40,cellheight = 40 ,# 设置热图单元格宽度和高度
                    display_numbers = TRUE,
                    fontsize_number = 8, #热图上数值的字体大小
                    number_color="black", #热图上数值的字体颜色
                    number_format="%.3f", #热图上数值的字体类型
                    color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
                    #color = colorRampPalette(c("green3", "white", "blue4"))(100),#换颜色
                    )
#读入文件
Mock1 <- read.csv("C:/Users/you/Desktop/Mock/rep1PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
Mock2 <- read.csv("C:/Users/you/Desktop/Mock/rep2PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
Mock3 <- read.csv("C:/Users/you/Desktop/Mock/rep3PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV1 <- read.csv("C:/Users/you/Desktop/TGEV/rep1PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV2 <- read.csv("C:/Users/you/Desktop/TGEV/rep2PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV3 <- read.csv("C:/Users/you/Desktop/TGEV/rep3PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
#取所需要的列
result <- cbind(Mock1[,c(1,7)],Mock2[,7],Mock3[,7],TGEV1[,7],TGEV2[,7],TGEV3[,7])
#将第一列变为行名并且去除第一列
row.names(result) <- result[,1]
result <- result[,-1]
names(result) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
setwd("C:/Users/you/Desktop/TGEV101")
result <- read.table("deseq2_Mock_VS_TGEV_read_counts.txt",header = T,sep ='\t')
sample_cor <- cor(result)
library(pheatmap)
pdf("cor.pdf",width =5,height = 4)
heatmap <- pheatmap(sample_cor,
                    cluster_rows = T,
                    cluster_cols = T,
                    scale="none",
                    cellwidth = 30,cellheight = 30 ,# 设置热图单元格宽度和高度
                    display_numbers = TRUE,
                    fontsize_number = 8, #热图上数值的字体大小
                    number_color="black", #热图上数值的字体颜色
                    number_format="%.3f", #热图上数值的字体类型
                    color = colorRampPalette(c("#6ba5c4","#9eb9cd","#d1dbe1","#d1806c","#bb4f48"))(100),
                  ) #color = colorRampPalette(c("green3", "white", "blue4"))(100),#换颜色
dev.off()


pc1 <- read.table("total_rep_pc1.txt", sep="\t")
colnames(pc1) <- c("Mock_rep1", "Mock_rep2", "TGEV_rep1", "TGEV_rep2")
pc1_cor <- cor(pc1, method = "pearson", use = "pairwise.complete.obs")
heatmap <- pheatmap(pc1_cor,
                    cluster_rows = T,
                    cluster_cols = T,
                    scale="none",
                    cellwidth = 30,cellheight = 30 ,# 设置热图单元格宽度和高度
                    display_numbers = TRUE,
                    fontsize_number = 8, #热图上数值的字体大小
                    number_color="black", #热图上数值的字体颜色
                    number_format="%.3f", #热图上数值的字体类型
                    color = colorRampPalette(c("#f5faf4","#319c87"))(100))
