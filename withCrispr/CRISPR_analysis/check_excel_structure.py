#!/usr/bin/env python3
"""
Check Excel file structure to find complete CRISPR data with p-values
"""

import pandas as pd

excel_file = "/path/to/CRISPR/Data/TGEV-筛选结果分析-2023-12-5.xls"

# Read the Excel file
print("Reading Excel file...")
xls = pd.ExcelFile(excel_file)

print(f"\nSheet names: {xls.sheet_names}")

# Check each sheet
for sheet_name in xls.sheet_names:
    print(f"\n{'='*60}")
    print(f"Sheet: {sheet_name}")
    print(f"{'='*60}")

    df = pd.read_excel(excel_file, sheet_name=sheet_name)

    print(f"Shape: {df.shape}")
    print(f"\nColumns: {list(df.columns)}")
    print(f"\nFirst 3 rows:")
    print(df.head(3))

    # Check if this sheet has p-value
    if any('p' in col.lower() for col in df.columns):
        print(f"\n✓ This sheet contains p-value columns!")

        # Check for LPP
        if 'Gene' in df.columns or 'GeneID' in df.columns or any('gene' in col.lower() for col in df.columns):
            gene_col = [col for col in df.columns if 'gene' in col.lower()][0]
            lpp_data = df[df[gene_col].str.contains('LPP', case=False, na=False)]
            if len(lpp_data) > 0:
                print(f"\n✓ LPP found in this sheet!")
                print(lpp_data)
