#Set working directory
setwd("./")
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
                    fontsize_number = 8, #Font size of numbers on heatmap
                    number_color="black", #Font color of numbers on heatmap
                    number_format="%.3f", #Number format on heatmap
                    color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
                    #color = colorRampPalette(c("green3", "white", "blue4"))(100),#Alternative color scheme
                    )
#Read input files
Mock1 <- read.csv("./Mock/rep1PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
Mock2 <- read.csv("./Mock/rep2PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
Mock3 <- read.csv("./Mock/rep3PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV1 <- read.csv("./TGEV/rep1PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV2 <- read.csv("./TGEV/rep2PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
TGEV3 <- read.csv("./TGEV/rep3PE_stranded_anno_rsem.genes.results",header=T,sep="\t")
#Extract the required columns
result <- cbind(Mock1[,c(1,7)],Mock2[,7],Mock3[,7],TGEV1[,7],TGEV2[,7],TGEV3[,7])
#Set the first column as row names and remove the first column
row.names(result) <- result[,1]
result <- result[,-1]
names(result) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
setwd("./")
result <- read.table("deseq2_Mock_VS_TGEV_read_counts.txt",header = T,sep ='\t')
sample_cor <- cor(result)
library(pheatmap)
pdf("cor.pdf",width =5,height = 4)
heatmap <- pheatmap(sample_cor,
                    cluster_rows = T,
                    cluster_cols = T,
                    scale="none",
                    cellwidth = 30,cellheight = 30 ,# Set heatmap cell width and height
                    display_numbers = TRUE,
                    fontsize_number = 8, #Font size of numbers on heatmap
                    number_color="black", #Font color of numbers on heatmap
                    number_format="%.3f", #Number format on heatmap
                    color = colorRampPalette(c("#f4faee","#b1e1b7","#40a7ca","#084483"))(100),
                  ) #color = colorRampPalette(c("green3", "white", "blue4"))(100),#Alternative color scheme
dev.off()
