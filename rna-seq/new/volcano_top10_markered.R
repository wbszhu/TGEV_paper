#读取差异分析结果文件
res <- read.table("deseq2_all.txt",header = T,row.names = 1,sep = '\t')
#读取up,down,NS基因列表
none <- read.table("deseq2_none_fc1_padj0.05.txt",header = T,row.names = 1,sep = '\t')
up <- read.table("deseq2_up_fc1_padj0.05.txt",header = T,row.names = 1,sep = '\t')
down <- read.table("deseq2_down_fc1_padj0.05.txt",header = T,row.names = 1,sep = '\t')
#获取上述三种基因列表的SYMBOL
#up
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
#绘图
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