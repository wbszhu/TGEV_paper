import cooler
import cooltools
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

# --- Step 1: Load normalized Hi-C data ---
# Assuming we have a .mcool file containing Hi-C data at multiple resolutions
# .cool files are the standard format for Hi-C data
uri1 = '/path/to/hic/data/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/100000' # Use 100kb resolution
clr1 = cooler.Cooler(uri1)
uri2 = '/path/to/hic/data/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/100000' # Use 100kb resolution
clr2 = cooler.Cooler(uri2)
start, end = 35_000_000, 75_000_000
region = ('chr7', start, end)

# Get the Hi-C matrix for this chromosome (already normalized)
hic_matrix1 = clr1.matrix(balance=True).fetch(region)
hic_matrix2 = clr2.matrix(balance=True).fetch(region)

# --- Step 2: Calculate observed/expected (O/E) matrix ---
# cooltools can efficiently calculate expected values
# 'expected' is a DataFrame containing the average interaction value for each diagonal (i.e., each distance)
expected_df1 = cooltools.expected_cis(clr=clr1, view_df=None, nproc=2)
exp_vec1 = expected_df1[expected_df1['region1']=='chr7']['balanced.avg'].values
expected_df2 = cooltools.expected_cis(clr=clr2, view_df=None, nproc=2)
exp_vec2 = expected_df2[expected_df2['region1']=='chr7']['balanced.avg'].values

# Use cooltools API to calculate the O/E matrix
dist1 = np.subtract.outer(np.arange(hic_matrix1.shape[0]), np.arange(hic_matrix1.shape[0]))
exp_mat1 = np.zeros_like(hic_matrix1)
for d in np.unique(np.abs(dist1)):
    exp_mat1[np.abs(dist1)==d] = exp_vec1[d]  # Assign expected value to all positions at distance d

oe_mat1 = hic_matrix1 / (exp_mat1 + 1e-6)

dist2 = np.subtract.outer(np.arange(hic_matrix2.shape[0]), np.arange(hic_matrix2.shape[0]))
exp_mat2 = np.zeros_like(hic_matrix2)
for d in np.unique(np.abs(dist2)):
    exp_mat2[np.abs(dist2)==d] = exp_vec2[d]  # Assign expected value to all positions at distance d

oe_mat2 = hic_matrix2 / (exp_mat2 + 1e-6)
# --- Step 3: Calculate Pearson correlation matrix ---
# Use numpy's corrcoef function, which efficiently computes the correlation matrix
oe_mat1 = np.nan_to_num(oe_mat1, nan=1.0)
oe_mat2 = np.nan_to_num(oe_mat2, nan=1.0)

correlation_matrix1 = np.corrcoef(oe_mat1)
correlation_matrix2 = np.corrcoef(oe_mat2)
correlation_matrix = correlation_matrix2 - correlation_matrix1

# Handle NaN values that may arise during computation (e.g., if a row/column has zero variance)
correlation_matrix = np.nan_to_num(correlation_matrix, nan=0.0)

# --- Visualization ---
colors = ['#304172','#ffffff','#c0271d']
cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
plt.figure(figsize=(10, 10))
plt.imshow(correlation_matrix, 
           cmap=cmap, # 'seismic' red-blue colormap is well suited for showing positive/negative correlations
           vmin=-0.15, 
           vmax=0.15)
plt.colorbar(label='Pearson Correlation')
plt.title('Pearson Correlation Matrix for chr7')
plt.show()
plt.savefig("Fig1c_subtract.pdf")