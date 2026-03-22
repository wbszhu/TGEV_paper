#loading
library(dplyr)
library(tidyr)

#read counts
h3k27ac <- read.table('h3k27ac_log.txt',header = T,sep='\t')
subset_h3k27ac <- subset(h3k27ac, (wt.k27ac_change > 0 & pi.k27ac_change > 0))
h3k27me3 <- read.table('h3k27me3_log.txt',header = T,sep='\t')
subset_h3k27me3 <- subset(h3k27me3, (wt.k27me3_change > 0 & pi.k27me3_change > 0))
h3k4me3 <- read.table('h3k4me3_log.txt',header = T,sep='\t')
subset_h3k4me3 <- subset(h3k4me3, (wt.4me3_change > 0 & pi.4me3_change > 0))
#h3k27ac
subset_h3k27ac[which(subset_h3k27ac$pi.k27ac_change/subset_h3k27ac$wt.k27ac_change>1),"Group"] <- "up"
subset_h3k27ac[which(subset_h3k27ac$pi.k27ac_change/subset_h3k27ac$wt.k27ac_change<1),"Group"] <- "down"
subset_h3k27ac <- subset_h3k27ac %>% drop_na(Group)
#h3k27me3
subset_h3k27me3[which(subset_h3k27me3$pi.k27me3_change/subset_h3k27me3$wt.k27me3_change>1),"Group"] <- "up"
subset_h3k27me3[which(subset_h3k27me3$pi.k27me3_change/subset_h3k27me3$wt.k27me3_change<1),"Group"] <- "down"
subset_h3k27me3 <- subset_h3k27me3 %>% drop_na(Group)
#h3k4me3
subset_h3k4me3[which(subset_h3k4me3$pi.4me3_change/subset_h3k4me3$wt.4me3_change>1),"Group"] <- "up"
subset_h3k4me3[which(subset_h3k4me3$pi.4me3_change/subset_h3k4me3$wt.4me3_change<1),"Group"] <- "down"
subset_h3k4me3 <- subset_h3k4me3 %>% drop_na(Group)

# plot h3k27ac
library(ggplot2)
library(ggrastr)
ggplot(subset_h3k27ac, mapping = aes(x = wt.k27ac_change, y = pi.k27ac_change, color = Group)) +
  geom_point_rast(alpha = 1, size = 0.5) +
  geom_abline(slope = 1, intercept = 0, color = "black", linetype = "solid") +
  scale_x_continuous(limits = c(0, 7.5), breaks = seq(0, 7.5, 2.5)) +
  scale_y_continuous(limits = c(0, 7.5), breaks = seq(0, 7.5, 2.5)) +
  scale_color_manual(values = c("#304172", "#c0271d")) +
  theme(
    panel.background = element_rect(fill = "white"),
    legend.key = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 20)
  ) +
  xlab("WT_log(reads per 100kb bin)") +
  ylab("PI_log(reads per 100kb bin)") +
  ggtitle("H3K27ac")
ggsave("h3k27ac.pdf",width = 6,height = 5,dpi=300)
#h3k27me3
ggplot(subset_h3k27me3,mapping = aes(x=wt.k27me3_change,y=pi.k27me3_change,color=Group))+
  geom_point_rast(alpha=1,size=0.5)+
  geom_abline(slope = 1, intercept = 0, color = "black", linetype = "solid")+
  scale_x_continuous(limits = c(0, 7.5),breaks = seq(0,7.5,2.5))+
  scale_y_continuous(limits = c(0, 7.5),breaks = seq(0,7.5,2.5))+
  scale_color_manual(values = c("#304172", "#c0271d"))+
  theme(panel.background = element_rect(fill="white"),
        legend.key = element_blank(),#remove legend gray background
        axis.line = element_line(color = "black"),  # set axis line appearance
        axis.ticks = element_line(),  # set tick mark appearance
        panel.grid.major = element_blank(),  # remove major grid lines
        panel.grid.minor = element_blank(),   # remove minor grid lines
        plot.title = element_text(hjust = 0.5, size = 20))+
  xlab("WT_log(reads per 100kb bin)")+
  ylab("PI_log(reads per 100kb bin)")+
  ggtitle("H3K27me3")
ggsave("H3K27me3.pdf",width = 6,height = 5,dpi=300) 
#h3k4me3
ggplot(subset_h3k4me3,mapping = aes(x=wt.4me3_change,y=pi.4me3_change,color=Group))+
  geom_point_rast(alpha=1,size=0.5)+
  geom_abline(slope = 1, intercept = 0, color = "black", linetype = "solid")+
  scale_x_continuous(limits = c(0, 7.5),breaks = seq(0,7.5,2.5))+
  scale_y_continuous(limits = c(0, 7.5),breaks = seq(0,7.5,2.5))+
  scale_color_manual(values = c("#304172", "#c0271d"))+
  theme(panel.background = element_rect(fill="white"),
        legend.key = element_blank(),#remove legend gray background
        axis.line = element_line(color = "black"),  # set axis line appearance
        axis.ticks = element_line(),  # set tick mark appearance
        panel.grid.major = element_blank(),  # remove major grid lines
        panel.grid.minor = element_blank(),   # remove minor grid lines
        plot.title = element_text(hjust = 0.5, size = 20))+
  xlab("WT_log(reads per 100kb bin)")+
  ylab("PI_log(reads per 100kb bin)")+
  ggtitle("H3K4me3")
ggsave("H3K4me3.pdf",width = 6,height = 5,dpi=300)
