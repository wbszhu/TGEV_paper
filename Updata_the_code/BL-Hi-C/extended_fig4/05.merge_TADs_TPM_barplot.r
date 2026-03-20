library(tidyverse)
library(ggsci)
library(cowplot)
library(ggplot2)
library(ggsignif)
data <- read.table("tads_fpkm.txt", sep="\t", header = F)
colnames(data) <- c('chr', 'start', 'end', 'wt', 'pi', 'tads')
data$histone <- "FPKM"
data$log2FC <- log2(data$pi/data$wt)

ggplot(data, aes(x=tads, y=log2FC)) +
geom_boxplot(aes(fill=tads), outlier.shape=NA, width=0.4) +
facet_grid(~histone) +
scale_fill_npg() +
ylim(-2,2) +
labs(x=NULL) +
theme_test()
ggsave("gene_signal_change.pdf", width = 3.2, height = 4)
