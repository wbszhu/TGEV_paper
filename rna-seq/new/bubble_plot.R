setwd("C:/Users/Administrator/Desktop")
df <- data.frame(
  Motif = c("Fos", "Fos", "Fra1", "Fra1",  'Fra2', "JunB", "JunB", "AP-1", "AP-1","Atf2", "Atf4", "Atf7", "IRF1", "IRF3", "IRF8"),
  Family = c("AP-1", "AP-1", "AP-1", "AP-1", "AP-1", "AP-1", "AP-1", "AP-1", "AP-1", "ATF", "ATF", "ATF", "IRF", "IRF", "IRF"),
  Group = c("Mock", "TGEV","Mock", "TGEV", "TGEV","Mock", "TGEV","Mock", "TGEV", "TGEV", "TGEV", "TGEV", "TGEV", "TGEV", "TGEV"),
  LogPvalue = c(213.5, 1610, 198, 1576, 1548, 198.3, 1518, 171.7, 1378, 87, 58, 91, 194.8, 183.5, 134.4)
)

library(ggplot2)
library(dplyr)

# 自定义颜色
my_colors <- c("AP-1" = "#e64b35", "ATF" = "#4dbbd5", "IRF" = "#00a087")
df$Motif <- factor(df$Motif, levels = unique(df$Motif))
# 绘制气泡图
ggplot(df, aes(x = Group, y = Motif, color = Family, size = LogPvalue)) +
  geom_point(shape = 16, aes(color = Family), stroke = 0.8) + # shape=21 可以填充颜色+边框
  scale_color_manual(values = my_colors) +
  theme_bw() +
  theme(
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 10),
    axis.title = element_blank(),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9)
  )+
  labs(x = "Group", y = "Motif", size = "-LogPvalue", color = "Family")

ggsave("bubble_motif_checked.pdf", width = 5, height = 6)
