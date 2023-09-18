#载入所需要的包，设置工作路径
library(dplyr)
setwd("C:/Users/you/Desktop")
#读入read counts数据，去除染色体和bins信息
data <- read.table('scores_per_100kb.tab',header = F,sep='\t')
data <- data[,4:15]
#取两个rep的平均值
data$WT_27ac <- rowMeans(select(data,c(V4,V5)))
data$WT_4me3 <- rowMeans(select(data,c(V6,V7)))
data$WT_27me3 <- rowMeans(select(data,c(V8,V9)))
data$PI_27ac <- rowMeans(select(data,c(V10,V11)))
data$PI_4me3 <- rowMeans(select(data,c(V12,V13)))
data$PI_27me3 <- rowMeans(select(data,c(V14,V15)))
#得到平均值矩阵
data_mean <- data[,13:18]
#对平均值取loge
data_mean$WT_27ac_log <- log(data_mean$WT_27ac)
data_mean$WT_4me3_log <- log(data_mean$WT_4me3)
data_mean$WT_27me3_log <- log(data_mean$WT_27me3)
data_mean$PI_27ac_log <- log(data_mean$PI_27ac)
data_mean$PI_4me3_log <- log(data_mean$PI_4me3)
data_mean$PI_27me3_log <- log(data_mean$PI_27me3)
#生成log矩阵
data_log <- data_mean[,7:12]
#根据组蛋白因子区分矩阵，用于三组绘图
final_27ac <- data_log[,c(1,4)]
final_4me3 <- data_log[,c(2,5)]
final_27me3 <- data_log[,c(3,6)]
#绘图
library(ggplot2)
ggplot(final_27me3,mapping = aes(x=WT_27me3_log,y=PI_27me3_log))+
  geom_point(color='#e1be61',alpha=1,size=0.5)+
  geom_point(color='black',alpha=0.1,size=0.5)+
  geom_abline(slope = 1, intercept = 0, color = "black", linetype = "solid")+
  geom_abline(slope = 1, intercept = 2, color = "black", linetype = "dashed")+
  geom_abline(slope = 1, intercept = -2, color = "black", linetype = "dashed")+
  scale_x_continuous(limits = c(0, 12.5),breaks = seq(0,12.5,2.5))+
  scale_y_continuous(limits = c(0, 12.5),breaks = seq(0,12.5,2.5))+
  theme(panel.background = element_rect(fill="white"),
        axis.line = element_line(color = "black"),  # 设置坐标轴线的外观
        axis.ticks = element_line(),  # 设置刻度线的外观
        panel.grid.major = element_blank(),  # 去除主网格线
        panel.grid.minor = element_blank(),   # 去除次要网格线
        plot.title = element_text(hjust = 0.5, size = 20))+
  xlab("WT_log(reads per 100kb bin)")+
  ylab("PI_log(reads per 100kb bin)")+
  ggtitle("H3K27me3")
ggsave("H3K27me3.pdf",width = 5,height = 5,dpi=300)  
