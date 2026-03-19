res <- read.table("deseq2_all.txt", sep = "\t", header = T, row.names = 1)
up <- read.table("deseq2_up_fc1_padj0.05.txt", sep = "\t", header = T, row.names = 1)
down <- read.table("deseq2_down_fc1_padj0.05.txt", sep = "\t", header = T, row.names = 1)

up$ensembl_gene_id <- row.names(up)
txt <- read.table("id_name_ENSEMBL.txt",header=F,sep="\t")
names(txt) <- c("ensembl_gene_id","gene_name")
up_name <- merge(up,txt,by = "ensembl_gene_id")
up_name <- up_name[order(up_name$pvalue),]
down$ensembl_gene_id <- row.names(down)
down_name <- merge(down,txt,by = "ensembl_gene_id")
down_name <- down_name[order(down_name$pvalue),]

up_sub <- up_name[up_name$gene_name %in% c("MYC", "GADD45A", "GADD45B", "TNFAIP3", "BCL2L1", "IL6", "MAP3K14", "DUSP1", "MAP3K13", "MAP3K5"), ]
down_sub <- down_name[down_name$gene_name %in% c("SQLE", "CYP26B1", "INSIG1", "APP", "CYP51A1"), ]
#绘图
library(ggplot2)
library(ggrepel)
pdf("volcano.pdf",width=5,height = 5)
ggplot(res, mapping=aes(log2FoldChange, -log10(padj), color=sig)) +
  # 整体散点
  #geom_point(size=0.5) +
  #
  # 给 up_sub 单独加绿色点
  #geom_point(data = up_sub, aes(log2FoldChange, -log10(padj)), 
  #           color = "green", size = 0.8) +
  
  # 给 down_sub 单独加绿色点
  #geom_point(data = down_sub, aes(log2FoldChange, -log10(padj)), 
   #          color = "green", size = 0.8) +
  
  # 标注
  #geom_text_repel(data = up_sub, aes(label=gene_name), 
  #                color="black", size=2, direction="y") +
  #geom_text_repel(data = down_sub, aes(label=gene_name), 
  #                color="black", size=2, direction="y") +
  
  # 颜色映射（针对主sig分类）
  scale_color_manual(values=c("up"="#c0271d","none"="gray","down"="#304172")) +
  
  labs(x="log2FoldChange", y="-log10(padj)", title="Mock VS TGEV", color="") +
  theme(plot.title = element_text(hjust = 0.5, size = 15), 
        panel.grid = element_blank(),
        panel.background = element_rect(color = 'black', fill = 'transparent'),
        legend.key = element_rect(fill = 'transparent')) +
  geom_vline(xintercept = c(-1, 1), lty = 3, color = 'black') +
  geom_hline(yintercept = 1.3, lty = 3, color = 'black') +
  xlim(-5, 5) + ylim(0, 250)

dev.off()