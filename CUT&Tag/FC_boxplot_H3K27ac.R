setwd("./")
random_fc <- read.csv('random_foldchange.bed',sep = '\t',header = TRUE)
slm_fc <- read.csv('slm_foldchange.bed',sep = '\t',header = TRUE)
random_fc$Gene <- "random"
slm_fc$Gene <- "slm"
slm_fc <- slm_fc[1:1206,]
# Random group
WT_random <- random_fc[,c(1,3)]
WT_random$Group <- "WT-random"
colnames(WT_random)[1] <- "Signal"
WT_random <- WT_random[,c(1,3)]
PI_random <- random_fc[,c(2,3)]
PI_random$Group <- "PI-random"
colnames(PI_random)[1] <- "Signal"
PI_random <- PI_random[,c(1,3)]
# slm group
WT_slm <- slm_fc[,c(1,3)]
WT_slm$Group <- "WT-slm"
colnames(WT_slm)[1] <- "Signal"
WT_slm <- WT_slm[,c(1,3)]
PI_slm <- slm_fc[,c(2,3)]
PI_slm$Group <- "PI-slm"
colnames(PI_slm)[1] <- "Signal"
PI_slm <- PI_slm[,c(1,3)]
# Merge all data
data_all <- rbind(WT_slm,PI_slm,WT_random,PI_random)
# Plot
library(ggplot2)
library(ggsignif)
ggplot(data_all,aes(x=Group,y=Signal,fill=Group))+
  geom_boxplot()+
  ggtitle("signal intensity of different Gene")+
  theme_bw() + theme(panel.grid=element_blank())+
  scale_fill_manual(values=c("#e3ab92","#94b5d6","#e3ab92","#94b5d6"))+
  ylim(0,20)+
  geom_signif(comparisons = list(c("PI-random","PI-slm"),c('WT-random','WT-slm')),
              map_signif_level = TRUE, test = t.test, textsize = 4)
ggsave("./random_slm_FC.pdf",width = 6, height = 5, dpi = 300)
