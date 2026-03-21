import cooler
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap


# === 1. 载入两个 .cool 文件 ===
#c1 = cooler.Cooler("/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/100000")
#c2 = cooler.Cooler("/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/100000")
#start, end = 35_000_000, 75_000_000
c1 = cooler.Cooler("/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/5000")
c2 = cooler.Cooler("/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/5000")
start, end = 55_000_000, 55_700_000
region = ('chr7', start, end)

# === 2. 提取 chr7 上的平衡矩阵（可以设 balance=False 获取原始 count） ===
mat1 = c1.matrix(balance=False).fetch(region)
mat2 = c2.matrix(balance=False).fetch(region)

# === 3. 避免除以零，加上一个小常数（伪计数） ===
mat1 = mat1.astype(float)
mat2 = mat2.astype(float)
eps = 1e-3  # 或更大一点比如 1e-3，避免 log(0) 或除以 0
mat1 += eps
mat2 += eps

# === 4. 计算 log2 fold change ===
log2fc = np.log2(mat2 / mat1)

# === 5. 绘制热图 ===
colors = ['#304172', '#ffffff', '#c0271d']
cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
plt.figure(figsize=(8, 8))
plt.imshow(log2fc, cmap=cmap, vmin=-1.5, vmax=1.5, origin='upper')
plt.colorbar(label='log2FC')
plt.title('PI/WT')
#plt.xlabel('chr7:35_000_000-75_000_000')
#plt.ylabel('chr7:35_000_000-75_000_000')
plt.xlabel('chr7:55_000_000-55_700_000')
plt.ylabel('chr7:55_000_000-55_700_000')
plt.tight_layout()
plt.show()
#plt.savefig("Fig1b_fc.pdf")
plt.savefig("Fig1d_fc2.pdf")