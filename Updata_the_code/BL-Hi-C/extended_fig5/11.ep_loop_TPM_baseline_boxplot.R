library(ggplot2)
library(ggsci)
library(ggsignif)

data <- read.table("total_p_anchor_tpm_10kb.txt", sep="\t")
data$Log2FC <- log2((data$V10+1)/(data$V9+1))
data <- data[data$V1 %in% c("merge", "wt_specific", "pi_specific"),]
data1 <- data[,c(1,9)]
data1$Condition <- "Mock"
colnames(data1) <- c("Group", "TPM", "Condition")
data2 <- data[,c(1,10)]
data2$Condition <- "TGEV"
colnames(data2) <- c("Group", "TPM", "Condition")
total <- rbind(data1, data2)
total$log <- log(total$TPM+1)
total$Group <- factor(total$Group, levels = c("merge", "wt_specific", "pi_specific"))

ggplot(total, aes(x=Group, y=log)) +
  geom_boxplot(aes(fill=Group), width=0.4) +
  geom_signif(comparisons = list(c("merge", "pi_specific"),c("merge", "wt_specific"), c("wt_specific", "pi_specific")),
              map_signif_level = TRUE,
              tip_length = 0.01, textsize = 3,
              y_position = c(10, 10.5,11)
              )+
  facet_grid(~Condition) +
  scale_fill_manual(values = c("#00a087", "#3c5488", "#dc0000"))+
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),      # 去掉网格
    panel.border = element_rect(color = "black", linewidth = 1),  # 黑色外框
    axis.line = element_line(color = "black"), # 坐标轴线为黑色
    legend.key = element_blank()
  )
+
ylim(0,8)

ggsave("class_baseline_TPM.pdf", width = 7, height = 5)
