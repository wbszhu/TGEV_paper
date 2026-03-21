#Set working directory
setwd("./")
#Read input files
Mock1 <- read.csv("mock_rep1.results",header=T,sep="\t")
Mock2 <- read.csv("mock_rep2.results",header=T,sep="\t")
Mock3 <- read.csv("mock_rep3.results",header=T,sep="\t")
TGEV1 <- read.csv("tgev_rep1.results",header=T,sep="\t")
TGEV2 <- read.csv("tgev_rep2.results",header=T,sep="\t")
TGEV3 <- read.csv("tgev_rep3.results",header=T,sep="\t")
#Extract the required columns
read_counts <- cbind(Mock1[,c(1,8)],Mock2[,8],Mock3[,8],TGEV1[,8],TGEV2[,8],TGEV3[,8])
TPM <- cbind(Mock1[,c(1,6)],Mock2[,6],Mock3[,6],TGEV1[,6],TGEV2[,6],TGEV3[,6])
#Set the first column as row names and remove the first column
row.names(read_counts) <- read_counts[,1]
read_counts <- read_counts[,-1]
row.names(TPM) <- TPM[,1]
TPM <- TPM[,-1]
#Rename columns as needed and save
names(read_counts) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
names(TPM) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
write.table(read_counts,file="./deseq2_Mock_VS_TGEV_read_counts.txt",row.names=TRUE, sep="\t", quote=FALSE)
write.table(TPM,file="./deseq2_Mock_VS_TGEV_TPM.txt",row.names=TRUE, sep="\t", quote=FALSE)
#Remove genes with very low expression
read_counts <- read_counts[rowSums(read_counts) > 3,]
#Build expression matrix
count_matrix <- as.matrix(read_counts)
#Build factors
group_list <- factor(c(rep("Mock",3),rep("TGEV",3)))
#Build grouping data frame
coldata <- data.frame(row.names = colnames(count_matrix),group_list)
#Build dds object and inspect
library(DESeq2)
dds <- DESeqDataSetFromMatrix(countData = round(count_matrix),
                              colData = coldata,
                              design = ~group_list)
dds <- DESeq(dds)
#Output results as data frame
res <- data.frame(results(dds))
#Filter differentially expressed genes
res[which(res$log2FoldChange>=1 & res$pvalue<0.05),"sig"] <- "up"
res[which(res$log2FoldChange<=-1 & res$pvalue<0.05),"sig"] <- "down"
res[which(abs(res$log2FoldChange)<1 | res$pvalue>=0.05),"sig"] <- "none"
write.table(res,file="./deseq2_all.txt",row.names=TRUE, sep="\t", quote=FALSE)
#Export upregulated and downregulated genes
up <- subset(res,sig=="up")
down <- subset(res,sig=="down")
res1_select <- subset(res,sig %in% c("up","down"))
write.table(up,file="./deseq2_up.txt",row.names=TRUE, sep="\t", quote=FALSE)
write.table(down,file="./deseq2_down.txt",row.names=TRUE, sep="\t", quote=FALSE)
write.table(res1_select,file="./DEGs.txt",row.names=TRUE, sep="\t", quote=FALSE)
#Convert gene ID to gene name
up$ensembl_gene_id <- row.names(up)
txt <- read.table("id_name.txt",header=F,sep="\t")
names(txt) <- c("ensembl_gene_id","gene_name")
up_name <- merge(up,txt,by = "ensembl_gene_id")
up_name <- up_name[order(up_name$pvalue),]
down$ensembl_gene_id <- row.names(down)
down_name <- merge(down,txt,by = "ensembl_gene_id")
down_name <- down_name[order(down_name$pvalue),]
#Plot
library(ggplot2)
library(ggrepel)
pdf("volcano.pdf",width=5,height = 5)
ggplot(res,mapping=aes(log2FoldChange,-log10(pvalue),color=sig))+
  geom_point(size=0.5)+
  geom_text_repel(up_name[1:10,],mapping=aes(label=gene_name),color="black",size=2,direction = "y")+
  geom_text_repel(down_name[1:5,],mapping=aes(label=gene_name),color="black",size=2,direction = "y")+
  scale_color_manual(values=c("up"="red","none"="gray","down"="blue"))+
  labs(x="log2FoldChange",y="-log10(pvalue)",title="Mock VS TGEV",color="")+
  theme(plot.title = element_text(hjust = 0.5, size = 15),
        panel.grid = element_blank(),
        panel.background = element_rect(color = 'black', fill = 'transparent'),
        legend.key = element_rect(fill = 'transparent'))+
  geom_vline(xintercept = c(-1, 1), lty = 3, color = 'black')+
  geom_hline(yintercept = 1.3, lty = 3, color = 'black') +
  xlim(-5, 5) + ylim(0, 300)
dev.off()
