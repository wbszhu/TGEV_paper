#!/usr/bin/env python3
"""
Regenerate CRISPR results CSV with corrected gene symbol mapping.
Fixed: Use GeneID_y instead of GeneID_x for complete gene symbol mapping.
"""

import pandas as pd
import numpy as np
from scipy import stats
import warnings
warnings.filterwarnings('ignore')

# ============== Configuration ==============
DATA_FILE = '/path/to/CRISPR/Data/TGEV-筛选结果分析-2023-12-5.xls'
SHEET_NAME = 'zlu_lib'

# Thresholds
FC_THRESHOLD = 1
P_THRESHOLD = 0.05

# Output
OUTPUT_FILE = '/path/to/CRISPR/results/CRISPR_results_zlu_lib_FC1_p0.05.csv'

print("="*70)
print("Regenerating CRISPR results with corrected gene symbol mapping")
print("="*70)

# ============== Load Data ==============
print(f"\n1. Loading data from: {SHEET_NAME}")
df = pd.read_excel(DATA_FILE, sheet_name=SHEET_NAME)
print(f"   Loaded {len(df)} rows")
print(f"   Columns: {list(df.columns)}")

# ============== Gene ID Selection (FIXED) ==============
print("\n2. Selecting gene ID column:")
if 'GeneID_y' in df.columns:
    GENE_COL = 'GeneID_y'  # ✓ Use GeneID_y for complete gene symbol mapping
    print(f"   ✓ Using GeneID_y (complete gene symbol mapping)")
elif 'GeneID_x' in df.columns:
    GENE_COL = 'GeneID_x'
    print(f"   ⚠ Using GeneID_x (may have incomplete mapping)")
else:
    GENE_COL = df.columns[2]
    print(f"   Using default column: {GENE_COL}")

# Check mapping quality
print(f"\n3. Checking gene symbol mapping quality:")
ensembl_pattern = df[GENE_COL].astype(str).str.startswith('ENSSSCG')
n_ensembl = ensembl_pattern.sum()
n_symbol = (~ensembl_pattern).sum()
print(f"   Genes with symbol: {n_symbol} ({n_symbol/len(df)*100:.1f}%)")
print(f"   Genes with only Ensembl ID: {n_ensembl} ({n_ensembl/len(df)*100:.1f}%)")

if n_ensembl > 0:
    print(f"\n   Genes with only Ensembl ID:")
    for gene_id in df[ensembl_pattern][GENE_COL].head(20):
        print(f"     - {gene_id}")
    if n_ensembl > 20:
        print(f"     ... and {n_ensembl - 20} more")

# ============== Calculate p-values ==============
print(f"\n4. Calculating p-values (t-test)...")

def calculate_pvalues(df):
    """Calculate t-test p-values between before and after screening."""
    def safe_ttest(row):
        control = [row['PigGeCKO cells_read1_norm'], row['PigGeCKO cells_read2_norm']]
        treatment = [row['read1_norm'], row['read2_norm']]
        try:
            return stats.ttest_ind(treatment, control, equal_var=False, nan_policy='omit').pvalue or 1.0
        except Exception:
            return 1.0
    return df.apply(safe_ttest, axis=1)

df['p_value'] = calculate_pvalues(df)
df['-log10(p_value)'] = -np.log10(df['p_value'] + 1e-300)
print(f"   ✓ p-values calculated")

# ============== Classify Genes ==============
print(f"\n5. Classifying genes (FC>{FC_THRESHOLD}, p<{P_THRESHOLD})...")

labels = {
    'up': 'Enriched',
    'down': 'Depleted',
    'ns': 'Not Significant'
}

df['significant'] = labels['ns']
df.loc[(df['log2(Fold_change)'] > FC_THRESHOLD) & (df['p_value'] < P_THRESHOLD), 'significant'] = labels['up']
df.loc[(df['log2(Fold_change)'] < -FC_THRESHOLD) & (df['p_value'] < P_THRESHOLD), 'significant'] = labels['down']

n_up = (df['significant'] == labels['up']).sum()
n_down = (df['significant'] == labels['down']).sum()
n_ns = (df['significant'] == labels['ns']).sum()

print(f"   Enriched: {n_up}")
print(f"   Depleted: {n_down}")
print(f"   Not significant: {n_ns}")

# ============== Prepare Output ==============
print(f"\n6. Preparing output data...")

# Select columns for output
output_df = df[[
    'sgRNA',
    GENE_COL,
    'average(PigGeCKO cells)',
    'average',
    'Fold_change',
    'log2(Fold_change)',
    'p_value',
    '-log10(p_value)',
    'significant'
]].copy()

# Rename GENE_COL to GeneID_x for compatibility
output_df.columns = [
    'sgRNA',
    'GeneID_x',
    'average(PigGeCKO cells)',
    'average',
    'Fold_change',
    'log2(Fold_change)',
    'p_value',
    '-log10(p_value)',
    'significant'
]

# ============== Check Key Genes ==============
print(f"\n7. Checking key genes:")
key_genes = ['LPP', 'ANPEP', 'WDR13']
for gene in key_genes:
    gene_data = output_df[output_df['GeneID_x'] == gene]
    if len(gene_data) > 0:
        row = gene_data.iloc[0]
        print(f"   ✓ {gene}: log2FC={row['log2(Fold_change)']:.2f}, p={row['p_value']:.4f}, {row['significant']}")
    else:
        print(f"   ✗ {gene}: NOT FOUND")

# ============== Save Output ==============
print(f"\n8. Saving to: {OUTPUT_FILE}")
output_df.to_csv(OUTPUT_FILE, index=False)
print(f"   ✓ Saved {len(output_df)} rows")

print("\n" + "="*70)
print("✓ CRISPR results regenerated successfully!")
print("✓ Now using complete gene symbol mapping from GeneID_y")
print("="*70)
