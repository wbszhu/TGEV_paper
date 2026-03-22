library(tidyverse)
library(ggsci)
library(cowplot)
library(ggplot2)
library(ggsignif)
#promoter
data <- read.table("promoter_h3k27ac_change.txt", sep="\t", header=T)
colnames(data) <- c('chr', 'start', 'end', 'wt', 'pi', 'Loop')

data$Loop[data$Loop %in% c("share_wt", "share_pi")] <- "merge"
data$Loop <- factor(data$Loop, levels = c("merge", "wt_specific", "pi_specific"))

data1 <- data[,c(4,6)]
data1$Condition <- "Mock"
colnames(data1) <- c("h3k4me3", "group", "Condition")

data2 <- data[,c(5,6)]
data2$Condition <- "TGEV"
colnames(data2) <- c("h3k4me3", "group", "Condition")

total <- rbind(data1, data2)
total$group <- factor(total$group, levels = c("merge", "wt_specific", "pi_specific"))

ggplot(total, aes(x=group, y=h3k4me3)) +
  geom_boxplot(aes(fill=group), width=0.4) +
  geom_signif(comparisons = list(c("merge", "pi_specific"), c("merge", "wt_specific"),c("wt_specific", "pi_specific")),
              map_signif_level = TRUE,
              tip_length = 0.01, textsize = 3,
              y_position = c(4, 4.4, 4.8)
              )+
  facet_grid(~Condition) +
  scale_fill_manual(values = c("#00a087", "#3c5488", "#dc0000"))+
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),      # Remove grid lines
    panel.border = element_rect(color = "black", linewidth = 1),  # Black border
    axis.line = element_line(color = "black"), # Black axis lines
    legend.key = element_blank()
  )
# + ylim(0,5.5)
ggsave("class_baseline_promoter_h3k27ac.pdf", width = 7, height = 5)
