setwd("./")
tpm <- read.table("deseq2_Mock_VS_TGEV_TPM.txt",header = T,sep="\t")
mock <- tpm[,1:3]
tgev <- tpm[,4:6]
mock1 <- mock[which(rowSums(mock) > 0),]
tgev1 <- tgev[which(rowSums(tgev) > 0),]
library(VennDiagram)
a <- list(Mock=row.names(mock1),TGEV=row.names(tgev1))
venn <- venn.diagram(a,
             scaled=F,#Scale size proportionally
             alpha = 0.5,#Transparency
             lwd=1,lty=1,col=c('#ffddab','#b8e9d3'),#Line width, style, and color
             label.col="black",#Number color
             cex=2,fontface = "bold",#Number size and bold
             fill=c("#de9f7e","#7394bd"),#Fill color
             category.names = c("Mock", "TGEV"),#Group names
             cat.dist = 0.02,cat.pose = -180,#Label distance and angle
             cat.fontface = "bold",cat.col="black",cat.cex=2,#Label bold, color, size
             cat.default.pos = "outer",#Label position
             print.mode = c("raw","percent"),#Display counts and percentages
             filename = NULL,
             resolution = 300)
pdf("Venn.pdf",width = 7,height = 7)
grid.draw(venn)
dev.off()
