# TGEV

Code for the study of Transmissible Gastroenteritis Virus (TGEV) infection
effects on 3D genome organization and gene regulation in porcine cells.

## Structure

- `rna-seq/` — RNA-seq differential expression analysis
- `CUT&Tag/` — CUT&Tag chromatin profiling (H3K27ac, H3K4me3, H3K27me3)
- `hic/` — Hi-C 3D genome analysis (A/B compartments, TADs)
- `withCrispr/` — CRISPR screening integration

## Requirements

- **R** (>= 4.0): DESeq2, DiffBind, clusterProfiler, pheatmap, ggplot2, EnhancedVolcano
- **Python** (>= 3.8): pandas, numpy, matplotlib, cooltools, bioframe
- **Tools**: bedtools, deeptools, HiCExplorer, hitad, ROSE, liftOver
- **Reference genome**: Sus scrofa 11.1 (Sscrofa11.1)
