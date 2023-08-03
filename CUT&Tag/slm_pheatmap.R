#设置工作路径
setwd('C:/Users/you/Desktop')
#读取基因文件
slm <- read.table("target_gene.bed",header = F,sep='\t')
#读取全部基因表达差异，将目标基因分为上调、下调、不显著
all <- read.table('deseq2_all.txt',header = T,sep='\t')
all$V1 <- row.names(all)
deg <- merge(slm,all,by='V1')
none <- deg[deg$sig == 'none',c('V1','sig')]
up <- deg[deg$sig == 'up',c('V1','sig')]
down <- deg[deg$sig == 'down',c('V1','sig')]
#读取TPM文件
tpm <- read.table('deseq2_Mock_VS_TGEV_TPM.txt',header = T,sep='\t')
tpm$V1 <- row.names(tpm)
#分别得到上调，下调，不显著的tpm矩阵
none_tpm <- merge(none,tpm,by='V1')
row.names(none_tpm) <- none_tpm$V1
none_tpm <- none_tpm[,c(-1,-2)]
up_tpm <- merge(up,tpm,by='V1')
row.names(up_tpm) <- up_tpm$V1
up_tpm <- up_tpm[,c(-1,-2)]
down_tpm <- merge(down,tpm,by='V1')
row.names(down_tpm) <- down_tpm$V1
down_tpm <- down_tpm[,c(-1,-2)]
#将上下调不显著矩阵拼接起来
all_tpm <- rbind(up_tpm,down_tpm,none_tpm)
#绘图
library(pheatmap)
library(vegan)
pdf("slm_pheatmap.pdf",width = 5,height = 5)
pheatmap(all_tpm,scale = "row",
         show_rownames=F,
         show_colnames=T,
         cluster_row=F,
         cluster_col=F,
         border_color=NA,
         cellwidth = 45,
         colorRampPalette(c("#15365f","#75a2b9","#f6f3ea","#d65037"))(50))
dev.off()