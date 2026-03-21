# Load required packages and set working directory
library(dplyr)
setwd("./")
# Read read counts data, remove chromosome and bin information
data <- read.table('scores_per_100kb.tab',header = F,sep='\t')
data <- data[,4:15]
# Calculate the mean of two replicates
data$WT_27ac <- rowMeans(select(data,c(V4,V5)))
data$WT_4me3 <- rowMeans(select(data,c(V6,V7)))
data$WT_27me3 <- rowMeans(select(data,c(V8,V9)))
data$PI_27ac <- rowMeans(select(data,c(V10,V11)))
data$PI_4me3 <- rowMeans(select(data,c(V12,V13)))
data$PI_27me3 <- rowMeans(select(data,c(V14,V15)))
# Get the mean value matrix
data_mean <- data[,13:18]
# Calculate natural log of the mean values
data_mean$WT_27ac_log <- log(data_mean$WT_27ac)
data_mean$WT_4me3_log <- log(data_mean$WT_4me3)
data_mean$WT_27me3_log <- log(data_mean$WT_27me3)
data_mean$PI_27ac_log <- log(data_mean$PI_27ac)
data_mean$PI_4me3_log <- log(data_mean$PI_4me3)
data_mean$PI_27me3_log <- log(data_mean$PI_27me3)
# Generate log matrix
data_log <- data_mean[,7:12]
# Separate matrices by histone modification for three groups of plots
final_27ac <- data_log[,c(1,4)]
final_4me3 <- data_log[,c(2,5)]
final_27me3 <- data_log[,c(3,6)]
# Plot
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
        axis.line = element_line(color = "black"),  # Set axis line appearance
        axis.ticks = element_line(),  # Set tick mark appearance
        panel.grid.major = element_blank(),  # Remove major grid lines
        panel.grid.minor = element_blank(),   # Remove minor grid lines
        plot.title = element_text(hjust = 0.5, size = 20))+
  xlab("WT_log(reads per 100kb bin)")+
  ylab("PI_log(reads per 100kb bin)")+
  ggtitle("H3K27me3")
ggsave("H3K27me3.pdf",width = 5,height = 5,dpi=300)
