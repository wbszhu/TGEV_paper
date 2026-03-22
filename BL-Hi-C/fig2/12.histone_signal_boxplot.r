library(tidyverse)
library(ggsci)
library(cowplot)
library(ggplot2)
library(ggsignif)

data <- read.table("/path/to/data/histone_change_signal.txt", sep="\t", header = F)
colnames(data) <- c('chr', 'start', 'end', 'wt', 'pi', 'compartment', 'histone')

data1 <- data[!(data$wt == 0 & data$pi == 0), ]
data1$change <- data1$pi - data1$wt

ggplot(data1, aes(x=compartment, y=change)) +
  geom_boxplot(aes(fill=compartment), outlier.shape=NA, width=0.4) +
  geom_signif(comparisons = list(c("a2b", "stableb"),
                                 c("a2b", "stablea"), c("b2a", "stableb"), 
                                 c("a2b", "b2a"), c("b2a", "stablea"), c("stablea", "stableb")),
              y_position = c(1, 1.25, 1.5, 1.75, 2, 2.25),tip_length = 0.01,textsize = 3,
              map_signif_level = TRUE) +
  facet_grid(~histone) +
  scale_fill_npg() +
  ylim(-1.5,3) +
  labs(x=NULL) +
  theme_test()
ggsave("/path/to/output/histone_signal_change.pdf", width = 6, height = 4)
