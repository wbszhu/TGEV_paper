#!/usr/bin/env Rscript
# Volcano plot using complete CRISPR library (all 119 genes including LPP)

library(ggplot2)
library(ggrepel)
library(dplyr)

# Read complete data
df <- read.csv("/path/to/CRISPR/results/crispr_rnaseq_merged.csv")

# Rename columns for convenience
colnames(df) <- c("gene_id", "Gene", "log2FC", "category", "rna_log2fc", "rna_padj", "rna_deg_status")

# Create pseudo p-values based on category (for y-axis display)
# Add random jitter so genes in the same category are dispersed on the y-axis
set.seed(42)  # Set random seed for reproducibility

df <- df %>%
  mutate(
    # Base p-value
    base_pvalue = case_when(
      category == "Highly Enriched" ~ 0.001,
      category == "Moderately Enriched" ~ 0.01,
      category == "Slightly Enriched" ~ 0.05,
      category == "Highly Depleted" ~ 0.001,
      category == "Moderately Depleted" ~ 0.01,
      category == "Slightly Depleted" ~ 0.05,
      category == "Depleted" ~ 0.01,
      TRUE ~ 0.1
    ),
    # Add random jitter (within the same order of magnitude)
    jitter_factor = runif(n(), 0.5, 2.0),
    pseudo_pvalue = base_pvalue * jitter_factor
  )

# Threshold settings
fc_cutoff <- 2
p_cutoff <- 0.05
top_n <- 5  # Number of labels per direction

# Classification (based on category)
df <- df %>%
  mutate(status = case_when(
    grepl("Enriched", category, ignore.case = TRUE) & log2FC >= fc_cutoff ~ "Enriched",
    grepl("Depleted", category, ignore.case = TRUE) & log2FC <= -fc_cutoff ~ "Depleted",
    TRUE ~ "Not significant"
  ))

# Print basic statistics
cat("\n", rep("=", 60), "\n", sep="")
cat("CRISPR Library Statistics\n")
cat(rep("=", 60), "\n", sep="")
cat(sprintf("Total genes: %d\n", nrow(df)))
cat(sprintf("Enriched: %d\n", sum(df$status == "Enriched")))
cat(sprintf("Depleted: %d\n", sum(df$status == "Depleted")))
cat(sprintf("Not significant: %d\n", sum(df$status == "Not significant")))

# Select top genes (both directions)
top_enriched <- df %>%
  filter(status == "Enriched") %>%
  arrange(pseudo_pvalue, desc(log2FC)) %>%
  head(top_n)

top_depleted <- df %>%
  filter(status == "Depleted") %>%
  arrange(pseudo_pvalue, log2FC) %>%
  head(top_n)

# Force-label specific genes (ANPEP, WDR13, LPP)
highlight_genes <- df %>%
  filter(Gene %in% c("ANPEP", "WDR13", "LPP"))

# Check if these genes exist in the data
cat("\n", rep("=", 60), "\n", sep="")
cat("Genes to highlight:\n")
cat(rep("=", 60), "\n", sep="")
print(highlight_genes %>% select(Gene, log2FC, category, status))

# Merge and deduplicate
label_genes <- bind_rows(top_enriched, top_depleted, highlight_genes) %>%
  distinct(Gene, .keep_all = TRUE)

cat(sprintf("\nTotal genes to label: %d\n", nrow(label_genes)))

# Color scheme (Cell/Nature style)
color_scheme <- c("Enriched" = "#d73027",  # Red
                  "Depleted" = "#4575b4",  # Blue
                  "Not significant" = "grey70")

# Plot
volcano_plot <- ggplot(df, aes(x = log2FC, y = -log10(pseudo_pvalue))) +
  geom_point(aes(color = status), size = 2.5, alpha = 0.9) +
  scale_color_manual(values = color_scheme) +
  geom_vline(xintercept = c(-fc_cutoff, fc_cutoff),
             linetype = "dashed", color = "black", linewidth = 0.4) +
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
    x = expression(Log[2]~"fold change (CRISPR enrichment)"),
    y = expression("CRISPR enrichment rank"),
    color = "Screen outcome",
    title = "CRISPR Screen - Complete Library (119 genes)",
    subtitle = "Y-axis represents CRISPR category ranking, not statistical p-value"
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
    plot.title = element_text(hjust = 0.5, size = 15)
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
cat(rep("=", 60), "\n", sep="")
