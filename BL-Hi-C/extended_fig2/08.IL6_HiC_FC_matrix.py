import cooler
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap


# === 1. Load two .cool files ===
#c1 = cooler.Cooler("/path/to/hic/data/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/100000")
#c2 = cooler.Cooler("/path/to/hic/data/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/100000")
#start, end = 35_000_000, 75_000_000
c1 = cooler.Cooler("/path/to/hic/data/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/5000")
c2 = cooler.Cooler("/path/to/hic/data/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/5000")
start, end = 91_100_000, 91_800_000
region = ('chr9', start, end)

# === 2. Extract balanced matrix for chr7 (set balance=False for raw counts) ===
mat1 = c1.matrix(balance=False).fetch(region)
mat2 = c2.matrix(balance=False).fetch(region)

# === 3. Avoid division by zero by adding a small constant (pseudocount) ===
mat1 = mat1.astype(float)
mat2 = mat2.astype(float)
eps = 1e-3  # Or slightly larger like 1e-3, to avoid log(0) or division by 0
mat1 += eps
mat2 += eps

# === 4. Calculate log2 fold change ===
log2fc = np.log2(mat2 / mat1)

# === 5. Plot heatmap ===
colors = ['#304172', '#ffffff', '#c0271d']
cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
plt.figure(figsize=(8, 8))
plt.imshow(log2fc, cmap=cmap, vmin=-1.5, vmax=1.5, origin='upper')
plt.colorbar(label='log2FC')
plt.title('PI/WT')
#plt.xlabel('chr7:35_000_000-75_000_000')
#plt.ylabel('chr7:35_000_000-75_000_000')
plt.xlabel('chr9:91_100_000, 91_800_000')
plt.ylabel('chr9:91_100_000, 91_800_000')
plt.tight_layout()
plt.show()
#plt.savefig("Fig1b_fc.pdf")
plt.savefig("IL6_fc.pdf")