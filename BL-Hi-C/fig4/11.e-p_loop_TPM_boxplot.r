library(ggplot2)
library(ggsci)
library(ggsignif)

data <- read.table("total_p_anchor_tpm_10kb.txt", sep="\t")
data$Log2FC <- log2((data$V10+1)/(data$V9+1))
data2 <- data[,c(1,11)]
colnames(data2) <- c("Group", "Log2FC")
data2$Group <- factor(data2$Group, levels = c("All", "merge", "wt_specific", "pi_specific"))

ggplot(data2, aes(x=Group, y=Log2FC,fill=Group)) +
  geom_boxplot(width=0.4, outlier.shape = NA) +
  geom_signif(comparisons = list(c("All", "merge"), c('merge', 'pi_specific'),c('merge', 'wt_specific')),
              tip_length = 0.01,textsize = 3,
              y_position = c(2.5, 3, 3.5),
              map_signif_level = TRUE) +
  scale_fill_manual(values = c("#4dbbd5", "#00a087", "#3c5488", "#dc0000"))+
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),      # Remove grid
    panel.border = element_rect(color = "black", linewidth = 1),  # Black border
    axis.line = element_line(color = "black"), # Black axis lines
    legend.key = element_blank()
  )+
  ylim(-2,4.5)


ggsave("p_anchor_tpm_boxplot_10kb.pdf", width = 5, height = 4)
