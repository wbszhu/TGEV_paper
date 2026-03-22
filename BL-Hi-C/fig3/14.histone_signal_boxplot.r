library(tidyverse)
library(ggsci)
library(cowplot)
library(ggplot2)
library(ggsignif)

data <- read.table("E:/pig_TGEV_cut&tag/组图20250731/fig3/extended/boxplot/histone_change_signal.txt", sep="\t", header = F)
colnames(data) <- c('chr', 'start', 'end', 'wt', 'pi', 'compartment', 'histone')

data1 <- data[!(data$wt == 0 & data$pi == 0), ]
data1$change <- data1$pi - data1$wt

ggplot(data1, aes(x=compartment, y=change)) +
  geom_boxplot(aes(fill=compartment), outlier.shape=NA, width=0.4) +
  facet_grid(~histone) +
  scale_fill_npg() +
  ylim(-0.7,0.9) +
  labs(x=NULL) +
  theme_test()
ggsave("tads_hitone_signal_change_boxplot.pdf", width = 8, height = 4)
