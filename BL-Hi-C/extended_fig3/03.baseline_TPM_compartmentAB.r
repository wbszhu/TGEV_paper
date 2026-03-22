library(ggplot2)
library(ggsci)
library(ggsignif)
library(ggpubr)
library(patchwork)

data <- read.table("gene_total.txt", sep="\t", header = T)
data <- data[,-1]
data$log <- log(data$tpm+1)
data$Group <- factor(data$Group, levels = c("WT_comA", "WT_comB", "PI_comA", "PI_comB"))
data <- data[data$log != 0,]

ggplot(data, aes(x=Group, y=log, fill=Group))+
  geom_boxplot(width=0.4) +
  geom_signif(comparisons = list(c("WT_comA", "WT_comB"), c('PI_comA', 'PI_comB')),
              tip_length = 0.01,textsize = 3,
              #y_position = c(2.5, 3, 3.5),
              map_signif_level = TRUE) +
  scale_fill_manual(values = c("#ce151b","#3b5284","#ce151b","#3b5284"))+
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),      # Remove grid lines
    panel.border = element_rect(color = "black", linewidth = 1),  # Black border
    axis.line = element_line(color = "black"), # Black axis lines
    legend.key = element_blank()
  )
ggsave("compartmentAB_baseline_tpm.pdf", width = 5, height = 4)
