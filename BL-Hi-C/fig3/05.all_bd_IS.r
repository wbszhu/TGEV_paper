library(GenomicRanges)  # Handle genomic coordinates
library(ggplot2)        # Plotting
library(data.table)     # Efficient data operations
library(dplyr)          # Data manipulation
# Read Control group data
control_tad <- fread("WT_boundary.bed", col.names = c("chr", "start", "end")) %>%
  mutate(group = "Mock")
control_is <- fread("WT_is.bedGraph", col.names = c("chr", "start", "end", "IS_score")) %>%
  mutate(group = "Mock")

# Read Infected group data
infected_tad <- fread("PI_boundary.bed", col.names = c("chr", "start", "end")) %>%
  mutate(group = "TGEV")
infected_is <- fread("PI_is.bedGraph", col.names = c("chr", "start", "end", "IS_score")) %>%
  mutate(group = "TGEV")

# Merge data
all_tad <- bind_rows(control_tad, infected_tad)
all_is <- bind_rows(control_is, infected_is)

# Convert to GenomicRanges objects for coordinate operations
gr_tad <- makeGRangesFromDataFrame(all_tad, keep.extra.columns = TRUE)
gr_is <- makeGRangesFromDataFrame(all_is, keep.extra.columns = TRUE)

#Extend 200kb on each side centered on boundary
window_size <- 200000  # ±200 kb

# Expand each TAD boundary to center point and extend window on both sides
gr_tad_centers <- resize(gr_tad, width = 1, fix = "center")  # Get boundary center point
gr_tad_windows <- resize(gr_tad_centers, width = 2 * window_size, fix = "center")

# Find IS data overlapping with each TAD window
overlaps <- findOverlaps(gr_tad_windows, gr_is)

# Extract corresponding IS values and positions
is_subset <- gr_is[subjectHits(overlaps)] %>%
  as.data.frame() %>%
  mutate(
    tad_id = queryHits(overlaps),
    position = (start + end) / 2,
    group = gr_tad$group[queryHits(overlaps)]  # Associate group labels
  )

# Associate TAD boundary center coordinates
tad_centers <- gr_tad_centers[queryHits(overlaps)] %>%
  as.data.frame() %>%
  mutate(tad_center = (start + end) / 2) %>%
  select(tad_center)

is_subset <- cbind(is_subset, tad_centers) %>%
  mutate(rel_position = position - tad_center)

# Bin by group and relative position (10 kb step size)
is_aggregated <- is_subset %>%
  mutate(bin = floor(rel_position / 10000) * 10000) %>%
  group_by(group, bin) %>%
  summarise(
    mean_IS = mean(IS_score, na.rm = TRUE),
    se_IS = sd(IS_score, na.rm = TRUE) / sqrt(n())
  )

#Plot IS curves
ggplot(is_aggregated, aes(x = bin, y = mean_IS, color = group)) +
  geom_line(linewidth = 1) +
  geom_ribbon(
    aes(ymin = mean_IS - se_IS, ymax = mean_IS + se_IS, fill = group),
    alpha = 0.2, color = NA  # Hide fill border
  ) +
  labs(
    x = "Relative Position to TAD Boundary (kb)",
    y = "Insulation Score (IS)",
    title = "IS Profile Around TAD Boundaries (Mock vs TGEV)"
  ) +
  scale_x_continuous(labels = ~ .x / 1000) +
  scale_color_manual(values = c("Mock" = "#304172", "TGEV" = "#c0271d")) +
  scale_fill_manual(values = c("Mock" = "#304172", "TGEV" = "#c0271d")) +
  theme_bw() +
  theme(legend.position = "top",
        panel.border = element_rect(color="black", fill=NA),
        panel.background = element_rect(fill="white"),
        plot.background  = element_rect(fill="white"),
        panel.grid = element_blank()
  )
#SAVE
ggsave("fig3d.pdf", width = 5, height = 5)
