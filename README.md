# TGEV

Code for the study of Transmissible Gastroenteritis Virus (TGEV) infection
effects on 3D genome organization and gene regulation in PK-15 cells.

## Structure

- `RNA-seq/` — Fig1: RNA-seq differential expression analysis
- `CUT&Tag/` — Fig1: CUT&Tag histone modification analysis
- `BL-Hi-C/` — Fig2-4: BL-Hi-C chromatin interaction analysis
  - `fig2/` — Compartment and integrated analysis
  - `fig3/` — TAD and integrated analysis
  - `fig4/` — Loop and integrated analysis
- `withCrispr/` — Fig5: CRISPR screening integration
  - `Hi-C/` — CRISPR and Hi-C data integration
  - `RNA-seq/` — CRISPR and RNA-seq overlap analysis
  - `CRISPR_analysis/` — CRISPR screening data processing and visualization
- `rMATS/` — Fig6: Alternative splicing analysis
  - `fig6/` — GO/KEGG enrichment of differentially spliced genes

## Requirements

- **R** (>= 4.0): DESeq2, DiffBind, clusterProfiler, pheatmap, ggplot2, EnhancedVolcano
- **Python** (>= 3.8): pandas, numpy, matplotlib, cooltools, bioframe
- **Tools**: bedtools, deeptools, HiCExplorer, hitad, ROSE, liftOver
- **Reference genome**: Sus scrofa 11.1 (Sscrofa11.1)
