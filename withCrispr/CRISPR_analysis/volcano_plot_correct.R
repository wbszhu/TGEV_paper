#!/usr/bin/env Rscript
# Volcano plot using REAL CRISPR p-values (NO FAKE DATA!)

library(ggplot2)
library(ggrepel)
library(dplyr)

# Read real CRISPR data (containing real p-values)
df <- read.csv("/path/to/CRISPR/results/CRISPR_results_zlu_lib_FC1_p0.05.csv")

# View column names
cat("Available columns:\n")
print(colnames(df))

# Rename columns
colnames(df) <- c("sgRNA", "Gene", "avg_pigGeCKO", "average", "Fold_change",
                  "log2FC", "p_value", "neg_log10p", "significant")

# Print basic statistics
cat("\n", rep("=", 60), "\n", sep="")
cat("CRISPR Screen Statistics (REAL p-values)\n")
cat(rep("=", 60), "\n", sep="")
cat(sprintf("Total genes: %d\n", nrow(df)))
cat(sprintf("Enriched (p<0.05): %d\n", sum(df$significant == "Enriched")))
cat(sprintf("Depleted: %d\n", sum(df$significant == "Depleted", na.rm = TRUE)))
cat(sprintf("Not significant: %d\n", sum(df$significant == "Not Significant")))

# Threshold settings
fc_cutoff <- 2
p_cutoff <- 0.05
top_n <- 5  # Number of labels per direction

# Classification (based on real p-values and log2FC)
df <- df %>%
  mutate(status = case_when(
    p_value < p_cutoff & log2FC >= fc_cutoff ~ "Enriched",
    p_value < p_cutoff & log2FC <= -fc_cutoff ~ "Depleted",
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
# Note: Now using the corrected CSV file where LPP is properly mapped
highlight_genes <- df %>%
  filter(Gene %in% c("ANPEP", "LPP", "WDR13"))

# Check if these genes exist in the data
cat("\n", rep("=", 60), "\n", sep="")
cat("Genes to highlight:\n")
cat(rep("=", 60), "\n", sep="")
print(highlight_genes %>% select(Gene, log2FC, p_value, status))

# Merge and deduplicate
label_genes <- bind_rows(top_enriched, top_depleted, highlight_genes) %>%
  distinct(Gene, .keep_all = TRUE)

cat(sprintf("\nTotal genes to label: %d\n", nrow(label_genes)))

# Gene names are already correctly mapped in the CSV file; no additional conversion needed

# Color scheme (Cell/Nature style)
color_scheme <- c("Enriched" = "#d73027",  # Red
                  "Depleted" = "#4575b4",  # Blue
                  "Not significant" = "grey70")

# Plot
volcano_plot <- ggplot(df, aes(x = log2FC, y = -log10(p_value))) +
  geom_point(aes(color = status), size = 2.5, alpha = 0.9) +
  scale_color_manual(values = color_scheme) +
  # Fold change threshold lines
  geom_vline(xintercept = c(-fc_cutoff, fc_cutoff),
             linetype = "dashed", color = "black", linewidth = 0.4) +
  # p-value threshold line
  geom_hline(yintercept = -log10(p_cutoff),
             linetype = "dashed", color = "black", linewidth = 0.4) +
  # Add p=0.05 annotation
  annotate("text", x = Inf, y = -log10(p_cutoff),
           label = "p = 0.05",
           hjust = 1.1, vjust = -0.5,
           size = 3.5, color = "black", fontface = "bold") +
  # Add log2FC threshold annotation
  annotate("text", x = fc_cutoff, y = Inf,
           label = paste0("FC = ", 2^fc_cutoff),
           hjust = 0.5, vjust = 1.2,
           size = 3.5, color = "black", fontface = "bold") +
  annotate("text", x = -fc_cutoff, y = Inf,
           label = paste0("FC = ", round(1/2^fc_cutoff, 2)),
           hjust = 0.5, vjust = 1.2,
           size = 3.5, color = "black", fontface = "bold") +
  # Gene labels
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
    y = expression(-Log[10]~"(p-value)"),
    color = "Screen outcome",
    title = "CRISPR Screen - Complete Library (119 genes)",
    subtitle = "Using real statistical p-values from CRISPR screen"
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
    panel.grid.minor = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 15),
    plot.subtitle = element_text(hjust = 0.5, size = 10, face = "italic")
  )

# Display plot
print(volcano_plot)

# Save plot
output_file <- "/path/to/CRISPR/results/CRISPR_volcano_complete_library.pdf"

ggsave(
  filename = output_file,
  plot = volcano_plot,
  device = cairo_pdf,
  width = 6, height = 5, units = "in",
  dpi = 300
)

cat("\n", rep("=", 60), "\n", sep="")
cat(sprintf("Volcano plot saved to: %s\n", output_file))
cat("✓ Using REAL p-values from CRISPR screen\n")
cat("✓ NO fake/pseudo p-values used\n")
cat(rep("=", 60), "\n", sep="")
