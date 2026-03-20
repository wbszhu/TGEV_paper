library(dplyr)
library(tidyr)
library(ggplot2)
library(ggsci)

data1 <- read.table("part1_score.txt", sep="\t")
colnames(data1) <- c('bin', 'mock', 'tgev', 'part1_change') 
data1 <- data1[, c(1,4)]

data2 <- read.table("part2_score.txt", sep="\t")
colnames(data2) <- c('bin', 'mock', 'tgev', 'part2_change') 
data2 <- data2[, c(1,4)]

data3 <- read.table("part3_score.txt", sep="\t")
colnames(data3) <- c('bin', 'mock', 'tgev', 'part3_change')
data3 <- data3[, c(1,4)]

data4 <- read.table("part4_score.txt", sep="\t")
colnames(data4) <- c('bin', 'mock', 'tgev', 'part4_change') 
data4 <- data4[, c(1,4)]

data5 <- read.table("part5_score.txt", sep="\t")
colnames(data5) <- c('bin', 'mock', 'tgev', 'part5_change') 
data5 <- data5[, c(1,4)]

data6 <- read.table("part6_score.txt", sep="\t")
colnames(data6) <- c('bin', 'mock', 'tgev', 'part6_change') 
data6 <- data6[, c(1,4)]

df_all <- data1 %>%
  full_join(data2, by="bin") %>%
  full_join(data3, by="bin") %>%
  full_join(data4, by="bin") %>%
  full_join(data5, by="bin") %>%
  full_join(data6, by="bin")

df_long <- df_all %>%
  pivot_longer(
    cols = -bin,                 # 除了 a 列之外的所有列
    names_to = "Group",        # 新列，表示原来的列名
    values_to = "is_change"        # 新列，表示数值
  )

ggplot(df_long, aes(x = bin, y = is_change, color = Group)) +
  geom_line(linewidth = 1) +
  labs(
    x = "Relative Position to TAD Boundary (kb)",
    y = "IS score change",
    title = "IS change Around TAD Boundaries (Mock vs TGEV)"
  ) +
  scale_x_continuous(labels = ~ .x / 1000) +
  scale_color_npg() +
  theme_bw() +
  theme(legend.position = "top",
    panel.border = element_rect(color="black", fill=NA),
    panel.background = element_rect(fill="white"),
    plot.background  = element_rect(fill="white"),
    panel.grid = element_blank()
  )
ggsave("IS_change_alongcontact.pdf", width=5, height=5)

