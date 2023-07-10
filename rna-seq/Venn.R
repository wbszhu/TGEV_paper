setwd("C:/Users/you/Desktop/TGEV101")
tpm <- read.table("deseq2_Mock_VS_TGEV_TPM.txt",header = T,sep="\t")
mock <- tpm[,1:3]
tgev <- tpm[,4:6]
mock1 <- mock[which(rowSums(mock) > 0),]
tgev1 <- tgev[which(rowSums(tgev) > 0),]
library(VennDiagram)
a <- list(Mock=row.names(mock1),TGEV=row.names(tgev1))
venn <- venn.diagram(a,
             scaled=F,#按比例显示大小
             alpha = 0.5,#透明度
             lwd=1,lty=1,col=c('#ffddab','#b8e9d3'),#线条粗细形状颜色
             label.col="black",#数字颜色
             cex=2,fontface = "bold",#数字大小和加粗
             fill=c("#de9f7e","#7394bd"),#填充颜色
             category.names = c("Mock", "TGEV"),#组别命名
             cat.dist = 0.02,cat.pose = -180,#标签距离和角度
             cat.fontface = "bold",cat.col="black",cat.cex=2,#标签加粗颜色大小
             cat.default.pos = "outer",#标签位置
             print.mode = c("raw","percent"),#显示数据和百分比
             filename = NULL,
             resolution = 300)
pdf("Venn.pdf",width = 7,height = 7)             
grid.draw(venn)
dev.off()       
