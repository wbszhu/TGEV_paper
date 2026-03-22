#set dir
setwd("/path/to/data")
TPM <- read.table("deseq2_Mock_VS_TGEV_TPM.txt",header = T,row.names = 1,sep = "\t")
sample_cor <- cor(TPM)
head(sample_cor)
library(pheatmap)
heatmap <- pheatmap(sample_cor,
                    cluster_rows = FALSE,
                    cluster_cols = FALSE,
                    scale="none",
                    cellwidth = 40,cellheight = 40 ,# Set heatmap cell width and height
                    display_numbers = TRUE,
                    fontsize_number = 8, #font size of numbers on heatmap
                    number_color="black", #font color of numbers on heatmap
                    number_format="%.3f", #number format on heatmap
                    color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
                    #color = colorRampPalette(c("green3", "white", "blue4"))(100),#change colors
                    )
#loading file
Mock1 <- read.csv("/path/to/rnaseq/data/Mock/rep1PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
Mock2 <- read.csv("/path/to/rnaseq/data/Mock/rep2PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
Mock3 <- read.csv("/path/to/rnaseq/data/Mock/rep3PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV1 <- read.csv("/path/to/rnaseq/data/TGEV/rep1PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV2 <- read.csv("/path/to/rnaseq/data/TGEV/rep2PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV3 <- read.csv("/path/to/rnaseq/data/TGEV/rep3PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
#get col
result <- cbind(Mock1[,c(1,7)],Mock2[,7],Mock3[,7],TGEV1[,7],TGEV2[,7],TGEV3[,7])
#rename rownames
row.names(result) <- result[,1]
result <- result[,-1]
names(result) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
setwd("/path/to/data")
result <- read.table("deseq2_Mock_VS_TGEV_read_counts.txt",header = T,sep ='\t')
sample_cor <- cor(result)
library(pheatmap)
#rnaseq
pdf("cor.pdf",width =5,height = 4)
heatmap <- pheatmap(sample_cor,
                    cluster_rows = T,
                    cluster_cols = T,
                    scale="none",
                    cellwidth = 30,cellheight = 30 ,
                    display_numbers = TRUE,
                    fontsize_number = 8, 
                    number_color="black", 
                    number_format="%.3f", 
                    color = colorRampPalette(c("#6ba5c4","#9eb9cd","#d1dbe1","#d1806c","#bb4f48"))(100),
                  ) 
