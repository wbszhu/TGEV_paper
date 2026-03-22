################################################################################
# Script for combined GO CC and MF result plotting
# Plot GO Cellular Component and Molecular Function results in one barplot
################################################################################

library(ggplot2)
library(dplyr)
library(forcats)
library(RColorBrewer)

# Read GO results
go_cc <- read.csv("enrichment_results/GO_results/GO_CC_enrichment.csv", stringsAsFactors = FALSE)
go_mf <- read.csv("enrichment_results/GO_results/GO_MF_enrichment.csv", stringsAsFactors = FALSE)

# Add category column
go_cc$Category <- "Cellular Component"
go_mf$Category <- "Molecular Function"

# Merge data
combined_go <- rbind(go_cc, go_mf)

# Sort by p.adjust, select top entries (up to 10 per category)
go_cc_top <- go_cc %>%
    arrange(p.adjust) %>%
    head(10)

go_mf_top <- go_mf %>%
    arrange(p.adjust) %>%
    head(10)

combined_top <- rbind(go_cc_top, go_mf_top)

# Calculate -log10(p.adjust) for plotting
combined_top$NegLog10P <- -log10(combined_top$p.adjust)

# Truncate long descriptions for better display
combined_top$Description_short <- ifelse(
    nchar(combined_top$Description) > 50,
    paste0(substr(combined_top$Description, 1, 47), "..."),
    combined_top$Description
)

# Sort by Category and p-value, prepare for plotting
combined_top <- combined_top %>%
    arrange(Category, p.adjust) %>%
    mutate(Description_short = factor(Description_short, levels = Description_short))

# Set colors
colors <- c("Cellular Component" = "#4DBBD5FF",
            "Molecular Function" = "#E64B35FF")

# Create combined barplot
p_combined <- ggplot(combined_top, aes(x = NegLog10P, y = Description_short, fill = Category)) +
    geom_col(width = 0.7) +
    scale_fill_manual(values = colors) +
    labs(
        title = "GO Enrichment Analysis",
        subtitle = "Cellular Component & Molecular Function",
        x = "-log10(Adjusted P-value)",
        y = NULL,
        fill = "GO Category"
    ) +
    theme_bw(base_size = 12) +
    theme(
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray40"),
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10),
        axis.title.x = element_text(size = 11, face = "bold"),
        legend.position = "top",
        legend.title = element_text(face = "bold", size = 11),
        legend.text = element_text(size = 10),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
    ) +
    # Add separator line
    geom_vline(xintercept = -log10(0.05), linetype = "dashed", color = "red", alpha = 0.5)

# Save plot
ggsave(
    filename = "enrichment_results/figures/GO_Combined_barplot.pdf",
    plot = p_combined,
    width = 10,
    height = 8
)

ggsave(
    filename = "enrichment_results/figures/GO_Combined_barplot.png",
    plot = p_combined,
    width = 10,
    height = 8,
    dpi = 300
)

cat("Done: Combined barplot generated:\n")
cat("  - enrichment_results/figures/GO_Combined_barplot.pdf\n")
cat("  - enrichment_results/figures/GO_Combined_barplot.png\n")

# ============================================================================
# Optional: Create version with gene count
# ============================================================================

# Extract gene count (from GeneRatio)
combined_top$GeneCount <- as.numeric(sapply(strsplit(combined_top$GeneRatio, "/"), `[`, 1))

# Create bubble plot version with gene count
p_combined_bubble <- ggplot(combined_top,
                             aes(x = NegLog10P, y = Description_short,
                                 fill = Category, size = GeneCount)) +
    geom_point(shape = 21, alpha = 0.8) +
    scale_fill_manual(values = colors) +
    scale_size_continuous(range = c(3, 10)) +
    labs(
        title = "GO Enrichment Analysis (with Gene Count)",
        subtitle = "Cellular Component & Molecular Function",
        x = "-log10(Adjusted P-value)",
        y = NULL,
        fill = "GO Category",
        size = "Gene Count"
    ) +
    theme_bw(base_size = 12) +
    theme(
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
        plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray40"),
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10),
        axis.title.x = element_text(size = 11, face = "bold"),
        legend.position = "right",
        legend.title = element_text(face = "bold", size = 11),
        legend.text = element_text(size = 10),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
    ) +
    geom_vline(xintercept = -log10(0.05), linetype = "dashed", color = "red", alpha = 0.5)

# Save bubble plot version
ggsave(
    filename = "enrichment_results/figures/GO_Combined_dotplot.pdf",
    plot = p_combined_bubble,
    width = 11,
    height = 8
)

ggsave(
    filename = "enrichment_results/figures/GO_Combined_dotplot.png",
    plot = p_combined_bubble,
    width = 11,
    height = 8,
    dpi = 300
)

cat("Done: Combined dotplot generated:\n")
cat("  - enrichment_results/figures/GO_Combined_dotplot.pdf\n")
cat("  - enrichment_results/figures/GO_Combined_dotplot.png\n")

# ============================================================================
# Create faceted version (one panel per category)
# ============================================================================

p_facet <- ggplot(combined_top, aes(x = NegLog10P, y = fct_reorder(Description_short, NegLog10P), fill = Category)) +
    geom_col(width = 0.7, show.legend = FALSE) +
    scale_fill_manual(values = colors) +
    facet_wrap(~ Category, scales = "free_y", ncol = 1) +
    labs(
        title = "GO Enrichment Analysis",
        x = "-log10(Adjusted P-value)",
        y = NULL
    ) +
    theme_bw(base_size = 12) +
    theme(
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10),
        axis.title.x = element_text(size = 11, face = "bold"),
        strip.text = element_text(face = "bold", size = 11),
        strip.background = element_rect(fill = "gray90"),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
    ) +
    geom_vline(xintercept = -log10(0.05), linetype = "dashed", color = "red", alpha = 0.5)

# Save faceted version
ggsave(
    filename = "enrichment_results/figures/GO_Combined_facet.pdf",
    plot = p_facet,
    width = 10,
    height = 10
)

ggsave(
    filename = "enrichment_results/figures/GO_Combined_facet.png",
    plot = p_facet,
    width = 10,
    height = 10,
    dpi = 300
)

cat("Done: Faceted barplot generated:\n")
cat("  - enrichment_results/figures/GO_Combined_facet.pdf\n")
cat("  - enrichment_results/figures/GO_Combined_facet.png\n")

cat("\nDone! Generated 3 types of combined visualization plots.\n")
