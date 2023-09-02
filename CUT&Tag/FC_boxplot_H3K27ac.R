setwd('C:/Users/you/Desktop')
random_fc <- read.csv('random_foldchange.bed',sep = '\t',header = TRUE)
slm_fc <- read.csv('slm_foldchange.bed',sep = '\t',header = TRUE)
random_fc$Gene <- "random"
slm_fc$Gene <- "slm"
#random分组
WT_random <- random_fc[,c(1,3)]
WT_random$Group <- "WT"
colnames(WT_random)[1] <- "Signal"
PI_random <- random_fc[,c(2,3)]
PI_random$Group <- "PI"
colnames(PI_random)[1] <- "Signal"
#slm分组
WT_slm <- slm_fc[,c(1,3)]
WT_slm$Group <- "WT"
colnames(WT_slm)[1] <- "Signal"
PI_slm <- slm_fc[,c(2,3)]
PI_slm$Group <- "PI"
colnames(PI_slm)[1] <- "Signal"
#合并所有数据
data_all <- rbind(WT_slm,PI_slm,WT_random,PI_random)
#绘图
library(ggplot2)
ggplot(data_all,aes(x=Gene,y=Signal,fill=Group))+
  geom_boxplot()+
  ggtitle("signal intensity of different Gene")+
  theme_bw() + theme(panel.grid=element_blank())+
  scale_fill_manual(values=c('PI'="#e3ab92",'WT'="#94b5d6"))
ggsave("C:/Users/you/Desktop/random_slm_FC.pdf",width = 6, height = 5, dpi = 300)
