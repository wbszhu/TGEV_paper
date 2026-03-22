# TGEV

Code for the study of Transmissible Gastroenteritis Virus (TGEV) infection
effects on 3D genome organization and gene regulation in PK-15 cells.

## Structure

- `BL-Hi-C/` — BL-Hi-C chromatin interaction analysis
- `CUT&Tag/` — CUT&Tag histone modification analysis
- `RNA-seq/` — RNA-seq differential expression analysis
- `rMATS/` — Alternative splicing analysis
  - `fig6/` — GO/KEGG enrichment of differentially spliced genes
- `withCrispr/` — Fig5: CRISPR screening integration
  - `Hi-C/` — CRISPR and Hi-C data integration
  - `RNA-seq/` — CRISPR and RNA-seq overlap analysis
  - `CRISPR_analysis/` — CRISPR screening data processing and visualization

## Requirements

- **R** (>= 4.0): DESeq2, DiffBind, clusterProfiler, pheatmap, ggplot2, EnhancedVolcano
- **Python** (>= 3.8): pandas, numpy, matplotlib, cooltools, bioframe
- **Tools**: bedtools, deeptools, HiCExplorer, hitad, ROSE, liftOver
- **Reference genome**: Sus scrofa 11.1 (Sscrofa11.1)
