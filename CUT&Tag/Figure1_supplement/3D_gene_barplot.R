#设置工作路径
setwd('C:/Users/you/Desktop')
#读取目标基因集和上下调表达基因集
target <- read.table("gene_list.txt",header = T,sep='\t')
des <- read.table('deseq2_all.txt',header = T,sep = '\t')
#将基因分为三类：up,down,none
up <- des[des$sig == 'up',]
down <- des[des$sig == 'down',]
none <- des[des$sig == 'none',]
up$gene_id <- row.names(up)
down$gene_id <- row.names(down)
none$gene_id <- row.names(none)
#将上下调和不差异的基因分别与目的基因列表取交集
tar_up <- merge(up,target,by='gene_id')
tar_down <- merge(down,target,by='gene_id')
tar_none <- merge(none,target,by="gene_id")
#分别计算上下调和不差异基因的数目和总数
num_up <- nrow(tar_up)
num_down <- nrow(tar_down)
num_none <- nrow(tar_none)
num_total <- num_up + num_down + num_none
#转化为百分数
data <- c(num_none/num_total,num_up/num_total,num_down/num_total)
library(scales)
data <- percent(data, accuracy = 0.01)
data <- data.frame(data)
row.names(data) <- c("none","up","down")
colnames(data) <- "Percent"
data$gene <- row.names(data)
library(ggplot2)
pdf("3D_gene_barplot.pdf",width = 3,height=3)
ggplot(data,mapping = aes(x=gene,y=Percent))+
  geom_bar(stat = "identity",fill=c("#15365f","#75a2b9","#bdd9e7"))+
  geom_text(aes(label=Percent),vjust=-0.5,hjust=0.5)+
  theme(axis.line = element_line(colour = "black"),panel.background = element_blank())
dev.off() 