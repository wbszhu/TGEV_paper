data <- read.table("/path/to/hic/project/fig4/proximal_and_distal_h3k27ac/proximal_enhancer_h3k27ac_change.txt", sep = "\t", header = T)
data$Log2FC <- data$pi.k27ac_change-data$wt.k27ac_change

library(ggplot2)
library(ggsci)
data$Group <- factor(data$Group, levels = c("merge", "wt_specific", "pi_specific"))

ggplot(data, aes(x=Group, y=Log2FC, fill=Group)) +
  geom_boxplot(width=0.4, outlier.shape = NA) +
  geom_signif(comparisons = list(c("merge", "wt_specific"), c("merge", "pi_specific")),
              tip_length = 0.01, textsize = 3,
              y_position = c(3, 3.5),
              map_signif_level = TRUE) +
  scale_fill_manual(values = c("#00a087", "#3c5488", "#dc0000"))+
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),      # Remove grid
    panel.border = element_rect(color = "black", linewidth = 1),  # Black border
    axis.line = element_line(color = "black"), # Black axis lines
    legend.key = element_blank()
  )
ggsave("class_proximal_H3K27ac_Foldchange.pdf", width = 5, height = 4)

data1 <- data[,c(4,6)]
data1$Condition <- "Mock"
colnames(data1) <- c("H3k27ac", "Group", "Condition")
data2 <- data[,c(5,6)]
data2$Condition <- "TGEV"
colnames(data2) <- c("H3k27ac", "Group", "Condition")

total <- rbind(data1, data2)
ggplot(total, aes(x=Group, y=H3k27ac)) +
  geom_boxplot(aes(fill=Group), width=0.4, outlier.shape = NA) +
  geom_signif(comparisons = list(c("merge", "pi_specific"), c("wt_specific", "pi_specific")),
              map_signif_level = TRUE,
              tip_length = 0.01, textsize = 3,
              y_position = c(2, 2.25))+
  facet_grid(~Condition) +
  scale_fill_manual(values = c("#00a087", "#3c5488", "#dc0000"))+
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),      # Remove grid
    panel.border = element_rect(color = "black", linewidth = 1),  # Black border
    axis.line = element_line(color = "black"), # Black axis lines
    legend.key = element_blank()
  )+ ylim(0,3)
ggsave("class_baseline_proximal_H3K27ac.pdf", width = 7, height = 4)
