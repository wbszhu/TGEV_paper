import cooler
import cooltools
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

# --- 步骤 1: 加载归一化后的Hi-C数据 ---
# 假设我们有一个.mcool文件，包含了多种分辨率的Hi-C数据
# .cool文件是Hi-C数据的标准格式
uri = '/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/100000' # 使用100kb分辨率
clr = cooler.Cooler(uri)
start, end = 35_000_000, 75_000_000
region = ('chr7', start, end)

# 获取这条染色体的Hi-C矩阵 (已经是归一化后的)
hic_matrix = clr.matrix(balance=True).fetch(region)

# --- 步骤 2: 计算观测/期望 (O/E) 矩阵 ---
# cooltools可以高效地计算期望值
# 'expected' 是一个DataFrame，包含了每个对角线（即每个距离）的平均互作值
expected_df = cooltools.expected_cis(clr=clr, view_df=None, nproc=2)
exp_vec = expected_df[expected_df['region1']=='chr7']['balanced.avg'].values

# 使用cooltools的API来计算O/E矩阵
dist = np.subtract.outer(np.arange(hic_matrix.shape[0]), np.arange(hic_matrix.shape[0]))
exp_mat = np.zeros_like(hic_matrix)
for d in np.unique(np.abs(dist)):
    exp_mat[np.abs(dist)==d] = exp_vec[d]  # 给所有距离为 d 的位置赋上期望值

oe_mat = hic_matrix / (exp_mat + 1e-6)

# --- 步骤 3: 计算皮尔逊相关矩阵 ---
# 使用numpy的corrcoef函数，它能高效地计算相关矩阵
oe_mat = np.nan_to_num(oe_mat, nan=1.0)
correlation_matrix = np.corrcoef(oe_mat)

# 处理计算过程中可能出现的NaN值（如果某一行/列方差为0）
correlation_matrix = np.nan_to_num(correlation_matrix, nan=0.0)


# --- 可视化 ---
#colors = ['#418e76','#747ea3']
#cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
plt.figure(figsize=(10, 10))
plt.imshow(correlation_matrix, 
           cmap='GnBu', # 'seismic'红蓝色谱非常适合展示正负相关
           vmin=-0.5, 
           vmax=0.5)
plt.colorbar(label='Pearson Correlation')
plt.title('Pearson Correlation Matrix for chr7')
plt.show()
plt.savefig("Fig1c_wt.pdf")