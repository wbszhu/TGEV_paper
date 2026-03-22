#!/usr/bin/env Rscript
# Volcano plot with WDR13 and LPP highlighted

library(ggplot2)
library(ggrepel)
library(dplyr)

# Read data
df <- read.csv("/path/to/CRISPR/results/CRISPR_results_zlu_lib_FC1_p0.05.csv")

# Rename columns if they contain parentheses or special characters
colnames(df) <- c("sgRNA", "Gene", "avg_control", "avg_treat",
                  "Fold_change", "log2FC", "p_value", "negLog10P", "significant")

# Threshold settings
fc_cutoff <- 2
p_cutoff <- 0.05
top_n <- 5  # Number of labels per direction

# Classification
df <- df %>%
  mutate(status = case_when(
    log2FC >= fc_cutoff & p_value < p_cutoff ~ "Enriched",
    log2FC <= -fc_cutoff & p_value < p_cutoff ~ "Depleted",
    TRUE ~ "Not significant"
  ))

# Select top genes (both directions)
top_enriched <- df %>%
  filter(status == "Enriched") %>%
  arrange(p_value, desc(log2FC)) %>%
  head(top_n)

top_depleted <- df %>%
  filter(status == "Depleted") %>%
  arrange(p_value, log2FC) %>%
  head(top_n)

# Force-label specific genes (ANPEP, WDR13, LPP)
# Note: Now using the corrected CSV file where LPP is properly mapped; no need to use Ensembl ID
highlight_genes <- df %>%
  filter(Gene %in% c("ANPEP", "WDR13", "LPP"))

# Check if these genes exist in the data
cat("Genes to highlight:\n")
print(highlight_genes %>% select(Gene, log2FC, p_value, status))

# Merge and deduplicate
label_genes <- bind_rows(top_enriched, top_depleted, highlight_genes) %>%
  distinct(Gene, .keep_all = TRUE)

# Color scheme (Cell/Nature style)
color_scheme <- c("Enriched" = "#d73027",  # Red
                  "Depleted" = "#4575b4",  # Blue
                  "Not significant" = "grey70")

# Plot
volcano_plot <- ggplot(df, aes(x = log2FC, y = -log10(p_value))) +
  geom_point(aes(color = status), size = 2.5, alpha = 0.9) +
  # Add black border for specific genes (LPP, ANPEP, WDR13)
  geom_point(data = highlight_genes,
             aes(color = status),
             size = 2.5, alpha = 0.9,
             shape = 21,  # Use shape that supports border
             stroke = 1.5,  # Border thickness
             fill = ifelse(highlight_genes$status == "Enriched", "#d73027",
                          ifelse(highlight_genes$status == "Depleted", "#4575b4", "grey70")),
             color = "black") +  # Border color is black
  scale_color_manual(values = color_scheme) +
  geom_vline(xintercept = c(-fc_cutoff, fc_cutoff),
             linetype = "dashed", color = "black", linewidth = 0.4) +
  geom_hline(yintercept = -log10(p_cutoff),
             linetype = "dashed", color = "black", linewidth = 0.4) +
  geom_text_repel(
    data = label_genes,
    aes(label = Gene),
    size = 4,
    color = "black",
    box.padding = 0.5,
    point.padding = 0.3,
    segment.color = "black",
    segment.size = 0.4,
    segment.alpha = 0.8,
    min.segment.length = 0,
    max.overlaps = 100,
    fontface = "bold.italic"
  ) +
  labs(
    x = expression(Log[2]~"fold change"),
    y = expression(-Log[10]~"p-value"),
    color = "Screen outcome"
  ) +
  theme_bw(base_size = 13) +
  theme(
    text = element_text(face = "bold"),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 1.2),
    axis.text = element_text(color = "black", face = "bold", size = 12),
    axis.title = element_text(color = "black", face = "bold", size = 14),
    axis.ticks.length = unit(0.25, "cm"),
    legend.position = "right",
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 11, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# Display plot
print(volcano_plot)

# Save plot
ggsave(
  filename = "/path/to/CRISPR/results/CRISPR_volcano_with_WDR13_LPP.pdf",
  plot = volcano_plot,
  device = cairo_pdf,
  width = 6, height = 5, units = "in",
  dpi = 300
)

cat("\nVolcano plot saved to: CRISPR_volcano_with_WDR13_LPP.pdf\n")
