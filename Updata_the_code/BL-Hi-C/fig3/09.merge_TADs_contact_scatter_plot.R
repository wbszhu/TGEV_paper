library(tidyr)
library(dplyr)
library(ggplot2)
data <- read.table("total_tads_contact.txt", sep="\t")
data <- na.omit(data)
colnames(data) <- c('WT', 'PI')
# 添加颜色列
data <- data %>%
  mutate(color = ifelse(PI > WT, "#91d1c2", "#b09c85"))

# 绘图
ggplot(data, aes(x=WT, y=PI, color=color)) +
  geom_point(size=2) +
  scale_color_identity() +  # 使用自定义颜色
  geom_abline(intercept=0, slope=1, linetype="dashed") + # 对角线
  theme_bw() +
  xlim(0,0.15) +
  ylim(0,0.15) +
  labs(x="WT", y="PI") +
  theme(
    panel.background = element_rect(fill = "white"),   # 面板背景白色
    plot.background  = element_rect(fill = "white"),   # 整体背景白色
    panel.border     = element_rect(color = "black", fill = NA, size = 1), # 黑色边框
    panel.grid       = element_blank()                # 去掉格子/网格线
  )
ggsave("scatter.pdf", width=6, height=6, dpi=300)
