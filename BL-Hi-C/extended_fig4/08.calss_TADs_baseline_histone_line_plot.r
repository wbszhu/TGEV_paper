library(ggplot2)
library(dplyr)
setwd("/path/to/hic/project/fig3/extended/rid")
data <- read.table("h3k4me3_change.txt", sep="\t", header = T)
data <- data[,c(4,5,6)]
colnames(data) <- c('WT', 'PI', 'TADs')
df_filtered <- data[!(data$WT == 0 & data$PI == 0), ]

long_data <- gather(df_filtered, key = "Group", value = "Signal", -'TADs')
#long_data$Signal <- log2(long_data$Signal)

result <- long_data %>%
  group_by(TADs, Group) %>%
  summarise(mean_signal = mean(Signal))

ggplot(result, aes(x = TADs, y = mean_signal, color = Group, group = Group)) +
  geom_line(size = 1) +  # Draw line
  geom_point(size = 2) +  # Add data points
  scale_color_manual(values = c("#c0271d", "#304172")) +  # Manually set colors
  labs(
    title = "H3K4me3 Signal",
    x = "TADs",
    y = "Signal",
    color = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"), # Center the title
    legend.position = "right", # Legend position
    panel.grid.major = element_line(color = "gray50"), # Major grid lines in dark gray
    panel.grid.minor = element_line(color = "gray30"), # Minor grid lines in light gray
    panel.background = element_rect(fill = "white", color = "black", size = 1), # White background with black border
    legend.title = element_blank()
  )
ggsave("h3k27ac_lineplot.pdf", width=4.5, height = 3)
