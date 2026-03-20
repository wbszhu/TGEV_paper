library(GenomicRanges)  # 处理基因组坐标
library(ggplot2)        # 绘图
library(data.table)     # 高效数据操作
library(dplyr)          # 数据整理
library(tidyr)
# 读取Control组数据
control_tad <- fread("wt_part1_bd.txt", col.names = c("chr", "start", "end")) %>%
  mutate(group = "Mock")
control_is <- fread("E:/pig_TGEV_cut&tag/组图20250731/fig3/fig3d/WT_is.bedGraph", col.names = c("chr", "start", "end", "IS_score")) %>%
  mutate(group = "Mock")

# 读取Infected组数据
infected_tad <- fread("pi_part1_bd.txt", col.names = c("chr", "start", "end")) %>%
  mutate(group = "TGEV")
infected_is <- fread("E:/pig_TGEV_cut&tag/组图20250731/fig3/fig3d/PI_is.bedGraph", col.names = c("chr", "start", "end", "IS_score")) %>%
  mutate(group = "TGEV")

# 合并数据
all_tad <- bind_rows(control_tad, infected_tad)
all_is <- bind_rows(control_is, infected_is)

# 转换为GenomicRanges对象以便坐标操作
gr_tad <- makeGRangesFromDataFrame(all_tad, keep.extra.columns = TRUE)
gr_is <- makeGRangesFromDataFrame(all_is, keep.extra.columns = TRUE)

#以boundary为中心拓展左右200kb
window_size <- 200000  # ±200 kb

# 扩展每个TAD边界为中心点，并向两侧扩展窗口
gr_tad_centers <- resize(gr_tad, width = 1, fix = "center")  # 取边界中心点
gr_tad_windows <- resize(gr_tad_centers, width = 2 * window_size, fix = "center")

# 找到与每个TAD窗口重叠的IS数据
overlaps <- findOverlaps(gr_tad_windows, gr_is)

# 提取对应的IS值和位置
is_subset <- gr_is[subjectHits(overlaps)] %>%
  as.data.frame() %>%
  mutate(
    tad_id = queryHits(overlaps),
    position = (start + end) / 2,
    group = gr_tad$group[queryHits(overlaps)]  # 关联分组标签
  )

# 关联TAD边界中心坐标
tad_centers <- gr_tad_centers[queryHits(overlaps)] %>%
  as.data.frame() %>%
  mutate(tad_center = (start + end) / 2) %>%
  select(tad_center)

is_subset <- cbind(is_subset, tad_centers) %>%
  mutate(rel_position = position - tad_center)

# 按分组和相对位置分箱（10 kb步长）
is_aggregated <- is_subset %>%
  mutate(bin = floor(rel_position / 10000) * 10000) %>%
  group_by(group, bin) %>%
  summarise(
    mean_IS = mean(IS_score, na.rm = TRUE),
    se_IS = sd(IS_score, na.rm = TRUE) / sqrt(n())
  )

is_aggregated <- is_aggregated[,-4]
df_wide <- is_aggregated %>%
  pivot_wider(names_from = group, values_from = mean_IS)
df_wide$part1_change <- df_wide$TGEV - df_wide$Mock

write.table(df_wide, "part1_score.txt", col.names = F, row.names = F, sep = "\t", quote = F)

#绘制is曲线
ggplot(is_aggregated, aes(x = bin, y = mean_IS, color = group)) +
  geom_line(linewidth = 1) +
  geom_ribbon(
    aes(ymin = mean_IS - se_IS, ymax = mean_IS + se_IS, fill = group),
    alpha = 0.2, color = NA  # 隐藏填充边框
  ) +
  labs(
    x = "Relative Position to TAD Boundary (kb)",
    y = "Insulation Score (IS)",
    title = "IS Profile Around TAD Boundaries (Mock vs TGEV)"
  ) +
  scale_x_continuous(labels = ~ .x / 1000) +
  scale_color_manual(values = c("Mock" = "#304172", "TGEV" = "#c0271d")) +
  scale_fill_manual(values = c("Mock" = "#304172", "TGEV" = "#c0271d")) +
  theme_classic() +
  theme(legend.position = "top")
#SAVE
ggsave("part1_is.pdf", width = 5, height = 4)
