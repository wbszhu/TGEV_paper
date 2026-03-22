library(tidyr)
library(dplyr)
library(ggplot2)
data <- read.table("total_tads_contact.txt", sep="\t")
data <- na.omit(data)
colnames(data) <- c('WT', 'PI')
# Add color column
data <- data %>%
  mutate(color = ifelse(PI > WT, "#91d1c2", "#b09c85"))

# Plot
ggplot(data, aes(x=WT, y=PI, color=color)) +
  geom_point(size=2) +
  scale_color_identity() +  # Use custom colors
  geom_abline(intercept=0, slope=1, linetype="dashed") + # Diagonal line
  theme_bw() +
  xlim(0,0.15) +
  ylim(0,0.15) +
  labs(x="WT", y="PI") +
  theme(
    panel.background = element_rect(fill = "white"),   # Panel background white
    plot.background  = element_rect(fill = "white"),   # Overall background white
    panel.border     = element_rect(color = "black", fill = NA, size = 1), # Black border
    panel.grid       = element_blank()                # Remove grid lines
  )
ggsave("scatter.pdf", width=6, height=6, dpi=300)
