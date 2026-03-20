length <- read.table("loop_length.txt", sep="\t")
length1 <- length[,c(7,8)]
colnames(length1) <- c("Length", "Group")

library(ggplot2)
library(ggsignif)
length1$Group <- factor(length1$Group, levels = c("wt", "pi"))

ggplot(length1, aes(x=Group, y=Length, fill=Group)) +
  geom_boxplot(width=0.4, outlier.shape = NA) +
  geom_signif(comparisons = list(c("wt", "pi")),
              tip_length = 0.01, textsize = 3,
              y_position = 600000,
              map_signif_level = TRUE) +
  scale_fill_manual(values = c("#3c5488", "#dc0000")) +
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),      # 去掉网格
    panel.border = element_rect(color = "black", linewidth = 1),  # 黑色外框
    axis.line = element_line(color = "black"), # 坐标轴线为黑色
    legend.key = element_blank()
  )+ ylim(0,800000)
