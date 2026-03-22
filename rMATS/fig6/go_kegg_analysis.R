################################################################################
# Core script for GO and KEGG enrichment analysis (streamlined version)
#
# Functions:
#   1. GO enrichment analysis (BP, CC, MF)
#   2. KEGG pathway enrichment analysis
#   3. Basic visualization (barplot, dotplot)
#   4. Results export
#
# Input: rmats_significant_unique_gene_names.txt
# Output: enrichment_results/
#
# Dependencies: clusterProfiler v4.10+, org.Ss.eg.db
# Species: Sus scrofa (pig)
################################################################################

# ==============================================================================
# 1. Load packages and initialize
# ==============================================================================

suppressPackageStartupMessages({
    library(clusterProfiler)
    library(org.Ss.eg.db)
    library(enrichplot)
    library(ggplot2)
    library(dplyr)
    library(readr)
    library(openxlsx)
})

set.seed(12345)
theme_set(theme_bw(base_size = 12))

cat("\n================================================================================\n")
cat("GO and KEGG Enrichment Analysis\n")
cat("================================================================================\n\n")

# ==============================================================================
# 2. Create output directories
# ==============================================================================

output_dir <- "enrichment_results"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(file.path(output_dir, "GO_results"), showWarnings = FALSE)
dir.create(file.path(output_dir, "KEGG_results"), showWarnings = FALSE)
dir.create(file.path(output_dir, "figures"), showWarnings = FALSE)
dir.create(file.path(output_dir, "tables"), showWarnings = FALSE)

# ==============================================================================
# 3. Read gene list and convert IDs
# ==============================================================================

cat(">>> Reading gene list...\n")
gene_list <- read_lines("rmats_significant_unique_gene_names.txt")
gene_list <- gene_list[gene_list != ""]
cat(sprintf("Done: Read %d genes\n\n", length(gene_list)))

cat(">>> Gene ID conversion (Symbol -> Entrez ID)...\n")
gene_entrez <- bitr(gene_list, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = org.Ss.eg.db)
cat(sprintf("Done: Successfully converted %d genes (%.1f%%)\n\n",
            nrow(gene_entrez), 100 * nrow(gene_entrez) / length(gene_list)))

write.csv(gene_entrez, file.path(output_dir, "tables", "gene_id_conversion.csv"), row.names = FALSE)
entrez_ids <- gene_entrez$ENTREZID

# ==============================================================================
# 4. GO enrichment analysis
# ==============================================================================

cat("================================================================================\n")
cat("GO Enrichment Analysis\n")
cat("================================================================================\n\n")

pvalue_cutoff <- 0.05
qvalue_cutoff <- 0.05

# GO BP
cat(">>> GO Biological Process...\n")
go_bp <- enrichGO(gene = entrez_ids, OrgDb = org.Ss.eg.db, ont = "BP",
                  pAdjustMethod = "BH", pvalueCutoff = pvalue_cutoff,
                  qvalueCutoff = qvalue_cutoff, readable = TRUE)
if (!is.null(go_bp) && nrow(go_bp) > 0) {
    cat(sprintf("  Done: Enriched %d BP terms\n", nrow(go_bp)))
    write.csv(as.data.frame(go_bp), file.path(output_dir, "GO_results", "GO_BP_enrichment.csv"), row.names = FALSE)
} else {
    cat("  No significant enrichment\n")
}

# GO CC
cat(">>> GO Cellular Component...\n")
go_cc <- enrichGO(gene = entrez_ids, OrgDb = org.Ss.eg.db, ont = "CC",
                  pAdjustMethod = "BH", pvalueCutoff = pvalue_cutoff,
                  qvalueCutoff = qvalue_cutoff, readable = TRUE)
if (!is.null(go_cc) && nrow(go_cc) > 0) {
    cat(sprintf("  Done: Enriched %d CC terms\n", nrow(go_cc)))
    write.csv(as.data.frame(go_cc), file.path(output_dir, "GO_results", "GO_CC_enrichment.csv"), row.names = FALSE)
} else {
    cat("  No significant enrichment\n")
}

# GO MF
cat(">>> GO Molecular Function...\n")
go_mf <- enrichGO(gene = entrez_ids, OrgDb = org.Ss.eg.db, ont = "MF",
                  pAdjustMethod = "BH", pvalueCutoff = pvalue_cutoff,
                  qvalueCutoff = qvalue_cutoff, readable = TRUE)
if (!is.null(go_mf) && nrow(go_mf) > 0) {
    cat(sprintf("  Done: Enriched %d MF terms\n\n", nrow(go_mf)))
    write.csv(as.data.frame(go_mf), file.path(output_dir, "GO_results", "GO_MF_enrichment.csv"), row.names = FALSE)
} else {
    cat("  No significant enrichment\n\n")
}

# ==============================================================================
# 5. KEGG pathway enrichment analysis
# ==============================================================================

cat("================================================================================\n")
cat("KEGG Pathway Enrichment Analysis\n")
cat("================================================================================\n\n")

cat(">>> KEGG pathway (organism: ssc)...\n")
kegg_result <- enrichKEGG(gene = entrez_ids, organism = "ssc",
                          pAdjustMethod = "BH", pvalueCutoff = pvalue_cutoff,
                          qvalueCutoff = qvalue_cutoff)
if (!is.null(kegg_result) && nrow(kegg_result) > 0) {
    cat(sprintf("  Done: Enriched %d KEGG pathways\n\n", nrow(kegg_result)))
    kegg_result_readable <- setReadable(kegg_result, OrgDb = org.Ss.eg.db, keyType = "ENTREZID")
    write.csv(as.data.frame(kegg_result_readable),
              file.path(output_dir, "KEGG_results", "KEGG_enrichment.csv"), row.names = FALSE)
} else {
    cat("  No significant enrichment\n\n")
}

# ==============================================================================
# 6. Basic visualization
# ==============================================================================

cat("================================================================================\n")
cat("Generating visualizations\n")
cat("================================================================================\n\n")

# Helper function: safe plotting
safe_plot <- function(result, prefix, title) {
    if (!is.null(result) && nrow(result) > 0) {
        cat(sprintf("  Generating %s plots...\n", prefix))

        # Barplot
        tryCatch({
            p_bar <- barplot(result, showCategory = 20, title = paste(title, "- Top 20"))
            ggsave(file.path(output_dir, "figures", paste0(prefix, "_barplot.pdf")), p_bar, width = 10, height = 8)
            ggsave(file.path(output_dir, "figures", paste0(prefix, "_barplot.png")), p_bar, width = 10, height = 8, dpi = 300)
        }, error = function(e) cat(sprintf("  Warning - Barplot error: %s\n", e$message)))

        # Dotplot
        tryCatch({
            p_dot <- dotplot(result, showCategory = 20, title = paste(title, "- Top 20"))
            ggsave(file.path(output_dir, "figures", paste0(prefix, "_dotplot.pdf")), p_dot, width = 10, height = 8)
            ggsave(file.path(output_dir, "figures", paste0(prefix, "_dotplot.png")), p_dot, width = 10, height = 8, dpi = 300)
        }, error = function(e) cat(sprintf("  Warning - Dotplot error: %s\n", e$message)))

        cat(sprintf("  Done: %s completed\n\n", prefix))
    } else {
        cat(sprintf("  %s has no results, skipping\n\n", prefix))
    }
}

# Generate all plot types
safe_plot(go_bp, "GO_BP", "GO Biological Process")
safe_plot(go_cc, "GO_CC", "GO Cellular Component")
safe_plot(go_mf, "GO_MF", "GO Molecular Function")
safe_plot(kegg_result, "KEGG", "KEGG Pathway")

# ==============================================================================
# 7. Generate summary report
# ==============================================================================

cat("================================================================================\n")
cat("Generating summary report\n")
cat("================================================================================\n\n")

wb <- createWorkbook()

# Analysis overview
addWorksheet(wb, "Summary")
summary_data <- data.frame(
    Item = c("Input gene count", "Successfully converted", "Conversion rate", "GO BP enriched terms", "GO CC enriched terms",
             "GO MF enriched terms", "KEGG enriched pathways", "p-value cutoff", "q-value cutoff", "Analysis date"),
    Value = c(length(gene_list), nrow(gene_entrez),
              sprintf("%.1f%%", 100 * nrow(gene_entrez) / length(gene_list)),
              ifelse(!is.null(go_bp), nrow(go_bp), 0),
              ifelse(!is.null(go_cc), nrow(go_cc), 0),
              ifelse(!is.null(go_mf), nrow(go_mf), 0),
              ifelse(!is.null(kegg_result), nrow(kegg_result), 0),
              pvalue_cutoff, qvalue_cutoff, as.character(Sys.Date()))
)
writeData(wb, "Summary", summary_data)

# Add Top10 results
if (!is.null(go_bp) && nrow(go_bp) > 0) {
    addWorksheet(wb, "GO_BP_Top10")
    writeData(wb, "GO_BP_Top10", head(as.data.frame(go_bp), 10))
}
if (!is.null(go_cc) && nrow(go_cc) > 0) {
    addWorksheet(wb, "GO_CC_Top10")
    writeData(wb, "GO_CC_Top10", head(as.data.frame(go_cc), 10))
}
if (!is.null(go_mf) && nrow(go_mf) > 0) {
    addWorksheet(wb, "GO_MF_Top10")
    writeData(wb, "GO_MF_Top10", head(as.data.frame(go_mf), 10))
}
if (!is.null(kegg_result) && nrow(kegg_result) > 0) {
    addWorksheet(wb, "KEGG_Top10")
    writeData(wb, "KEGG_Top10", head(as.data.frame(kegg_result), 10))
}

saveWorkbook(wb, file.path(output_dir, "tables", "Enrichment_Summary.xlsx"), overwrite = TRUE)
cat("Done: Summary report generated\n\n")

# Save session info
writeLines(capture.output(sessionInfo()), file.path(output_dir, "session_info.txt"))

cat("================================================================================\n")
cat("Analysis complete!\n")
cat("================================================================================\n\n")
cat("Result files:\n")
cat("  • enrichment_results/tables/Enrichment_Summary.xlsx\n")
cat("  • enrichment_results/GO_results/\n")
cat("  • enrichment_results/KEGG_results/\n")
cat("  • enrichment_results/figures/\n\n")
