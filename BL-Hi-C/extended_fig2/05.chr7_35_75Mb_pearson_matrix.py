import cooler
import cooltools
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

# --- Step 1: Load normalized Hi-C data ---
# Assuming we have a .mcool file containing Hi-C data at multiple resolutions
# .cool files are the standard format for Hi-C data
uri = '/path/to/hic/data/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/100000' # Use 100kb resolution
clr = cooler.Cooler(uri)
start, end = 35_000_000, 75_000_000
region = ('chr7', start, end)

# Get the Hi-C matrix for this chromosome (already normalized)
hic_matrix = clr.matrix(balance=True).fetch(region)

# --- Step 2: Calculate observed/expected (O/E) matrix ---
# cooltools can efficiently calculate expected values
# 'expected' is a DataFrame containing the average interaction value for each diagonal (i.e., each distance)
expected_df = cooltools.expected_cis(clr=clr, view_df=None, nproc=2)
exp_vec = expected_df[expected_df['region1']=='chr7']['balanced.avg'].values

# Use cooltools API to calculate the O/E matrix
dist = np.subtract.outer(np.arange(hic_matrix.shape[0]), np.arange(hic_matrix.shape[0]))
exp_mat = np.zeros_like(hic_matrix)
for d in np.unique(np.abs(dist)):
    exp_mat[np.abs(dist)==d] = exp_vec[d]  # Assign expected value to all positions at distance d

oe_mat = hic_matrix / (exp_mat + 1e-6)

# --- Step 3: Calculate Pearson correlation matrix ---
# Use numpy's corrcoef function, which efficiently computes the correlation matrix
oe_mat = np.nan_to_num(oe_mat, nan=1.0)
correlation_matrix = np.corrcoef(oe_mat)

# Handle NaN values that may arise during computation (e.g., if a row/column has zero variance)
correlation_matrix = np.nan_to_num(correlation_matrix, nan=0.0)


# --- Visualization ---
#colors = ['#418e76','#747ea3']
#cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
plt.figure(figsize=(10, 10))
plt.imshow(correlation_matrix, 
           cmap='GnBu', # 'seismic' red-blue colormap is well suited for showing positive/negative correlations
           vmin=-0.5, 
           vmax=0.5)
plt.colorbar(label='Pearson Correlation')
plt.title('Pearson Correlation Matrix for chr7')
plt.show()
plt.savefig("Fig1c_wt.pdf")