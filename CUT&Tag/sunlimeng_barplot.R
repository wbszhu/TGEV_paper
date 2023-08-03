#读取name和id（不能转化为name）分别的文件
name <- read.table("name_merged",header = F,sep='\t')
id <- read.table("id_merged",header = F,sep='\t')
#读取id和name一一对应的文件
id_name <- read.table("id_name.txt",header = F,sep = '\t')
colnames(name) <- 'V2'
#将name文件和id-name转化文件按name列merge，获得name所对应的id
name_to_id <- merge(name,id_name,by='V2')
id2 <- data.frame(name_to_id$V1)
colnames(id2) <- 'V1'
#将name转化来的id和原有的id文件进行合并
id_all <- rbind(id,id2)
#读入差异表达基因列表
des <- read.table('deseq2_all.txt',header = T,sep = '\t')
up <- des[des$sig == 'up',]
down <- des[des$sig == 'down',]
none <- des[des$sig == 'none',]
up$V1 <- row.names(up)
down$V1 <- row.names(down)
none$V1 <- row.names(none)
#将上下调和不差异的基因分别与目的基因列表取交集
tar_up <- merge(up,id_all,by='V1')
tar_down <- merge(down,id_all,by='V1')
tar_none <- merge(none,id_all,by="V1")
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
pdf("sunlimeng_barplot.pdf",width = 3,height=3)
ggplot(data,mapping = aes(x=gene,y=Percent))+
  geom_bar(stat = "identity",fill=c("#15365f","#75a2b9","#bdd9e7"))+
  geom_text(aes(label=Percent),vjust=-0.5,hjust=0.5)+
  theme(axis.line = element_line(colour = "black"),panel.background = element_blank())
dev.off() 
