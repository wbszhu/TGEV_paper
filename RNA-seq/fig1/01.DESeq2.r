#read input files
setwd("/path/to/rnaseq/data")
Mock1 <- read.csv("mock_rep1.results",header=T,sep="\t")
Mock2 <- read.csv("mock_rep2.results",header=T,sep="\t")
Mock3 <- read.csv("mock_rep3.results",header=T,sep="\t")
TGEV1 <- read.csv("tgev_rep1.results",header=T,sep="\t")
TGEV2 <- read.csv("tgev_rep2.results",header=T,sep="\t")
TGEV3 <- read.csv("tgev_rep3.results",header=T,sep="\t")
#get row reads
read_counts <- cbind(Mock1[,c(1,8)],Mock2[,8],Mock3[,8],TGEV1[,8],TGEV2[,8],TGEV3[,8])
TPM <- cbind(Mock1[,c(1,6)],Mock2[,6],Mock3[,6],TGEV1[,6],TGEV2[,6],TGEV3[,6])
#rename rownames
row.names(read_counts) <- read_counts[,1]
read_counts <- read_counts[,-1]
row.names(TPM) <- TPM[,1]
TPM <- TPM[,-1]
#rename colnames
names(read_counts) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
names(TPM) <- c("Mock1","Mock2","Mock3","TGEV1","TGEV2","TGEV3")
write.table(read_counts,file="deseq2_Mock_VS_TGEV_read_counts.txt",row.names=TRUE, sep="\t", quote=FALSE)
write.table(TPM,file="deseq2_Mock_VS_TGEV_TPM.txt",row.names=TRUE, sep="\t", quote=FALSE)
#remove low expressed gene
read_counts <- read_counts[rowSums(read_counts) > 3,]
#construct expression matrix
count_matrix <- as.matrix(read_counts)
#construct factor
group_list <- factor(c(rep("Mock",3),rep("TGEV",3)))
#construct group dataframe
coldata <- data.frame(row.names = colnames(count_matrix),group_list)
#construct dds and view
library(DESeq2)
dds <- DESeqDataSetFromMatrix(countData = round(count_matrix),
                              colData = coldata,
                              design = ~group_list)
dds <- DESeq(dds)
#trans result to df
res <- data.frame(results(dds))
#filtrate DEGs
res[which(res$log2FoldChange>=1 & res$padj<0.05),"sig"] <- "up"
res[which(res$log2FoldChange<=-1 & res$padj<0.05),"sig"] <- "down"
res[which(abs(res$log2FoldChange)<1 | res$padj>=0.05),"sig"] <- "none"
write.table(res,file="deseq2_all.txt",row.names=TRUE, sep="\t", quote=FALSE)
#output up and down
up <- subset(res,sig=="up")
down <- subset(res,sig=="down")
none <- subset(res,sig=='none')
res1_select <- subset(res,sig %in% c("up","down"))
write.table(up,file="deseq2_up_fc2_p0.01.txt",row.names=TRUE, sep="\t", quote=FALSE)
write.table(down,file="deseq2_down_fc2_p0.01.txt",row.names=TRUE, sep="\t", quote=FALSE)
write.table(none,file="deseq2_none_fc2_p0.01.txt",row.names=TRUE, sep="\t", quote=FALSE)
write.table(res1_select,file="DEGs.txt",row.names=TRUE, sep="\t", quote=FALSE)
#conversion gene id and symbol
up$ensembl_gene_id <- row.names(up)
txt <- read.table("id_name_ENSEMBL.txt",header=F,sep="\t")
names(txt) <- c("ensembl_gene_id","gene_name")
up_name <- merge(up,txt,by = "ensembl_gene_id")
up_name <- up_name[order(up_name$pvalue),]
#down
down$ensembl_gene_id <- row.names(down)
down_name <- merge(down,txt,by = "ensembl_gene_id")
down_name <- down_name[order(down_name$pvalue),]
#none
none$ensembl_gene_id <- row.names(none)
none_name <- merge(none,txt,by = "ensembl_gene_id")
none_name <- none_name[order(none_name$pvalue),]
#plot
library(ggplot2)
library(ggrepel)
res <- res[!is.na(res$sig), ]
pdf("max_volcano.pdf",width=5,height = 5)
ggplot(res,mapping=aes(log2FoldChange,-log10(padj),color=sig))+
  geom_point(size=0.5)+
  geom_text_repel(up_name[1:10,],mapping=aes(label=gene_name),color="black",size=2,direction = "y")+
  geom_text_repel(down_name[1:10,],mapping=aes(label=gene_name),color="black",size=2,direction = "y",max.overlaps = 30)+
  scale_color_manual(values=c("up"="#c0271d","none"="gray","down"="#304172"))+
  labs(x="log2FoldChange",y="-log10(p.adjust)",title="Mock VS TGEV",color="")+
  theme(plot.title = element_text(hjust = 0.5, size = 15), 
        panel.grid = element_blank(),
        panel.background = element_rect(color = 'black', fill = 'transparent'),
        legend.key = element_rect(fill = 'transparent'))+
  geom_vline(xintercept = c(-1, 1), lty = 3, color = 'black')+
  geom_hline(yintercept = 1.3, lty = 3, color = 'black')
  #xlim(-5, 5) + ylim(0, 10)
dev.off()