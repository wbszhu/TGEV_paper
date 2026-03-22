#!/usr/bin/env python3
"""
Check if LPP gene is in the CRISPR library
"""

import pandas as pd

# Read the merged CRISPR-RNAseq file
merged_file = "/path/to/CRISPR/results/crispr_rnaseq_merged.csv"

print("="*60)
print("Searching for LPP in CRISPR library")
print("="*60)

# Read the file
df = pd.read_csv(merged_file)

print(f"\nTotal genes in library: {len(df)}")

# Search for LPP
lpp_data = df[df['gene_symbol'] == 'LPP']

if len(lpp_data) > 0:
    print(f"\n✓ LPP gene FOUND in CRISPR library!\n")
    print(lpp_data.to_string(index=False))

    # Get the details
    for _, row in lpp_data.iterrows():
        print(f"\nDetailed information:")
        print(f"  Gene ID: {row['gene_id']}")
        print(f"  Gene Symbol: {row['gene_symbol']}")
        print(f"  CRISPR Score (log2FC): {row['crispr_score']}")
        print(f"  CRISPR Category: {row['crispr_category']}")
        print(f"  RNA-seq log2FC: {row['rna_log2fc']}")
        print(f"  RNA-seq padj: {row['rna_padj']}")
        print(f"  RNA-seq DEG status: {row['rna_deg_status']}")
else:
    print(f"\n✗ LPP gene NOT found in CRISPR library")

# Also search for similar genes
print(f"\n" + "="*60)
print("Searching for genes containing 'LPP':")
print("="*60)

lpp_related = df[df['gene_symbol'].str.contains('LPP', case=False, na=False)]
if len(lpp_related) > 0:
    print(f"\nFound {len(lpp_related)} gene(s) containing 'LPP':\n")
    print(lpp_related[['gene_symbol', 'crispr_score', 'crispr_category']].to_string(index=False))
else:
    print("\nNo genes containing 'LPP' found")

print("\n" + "="*60)
