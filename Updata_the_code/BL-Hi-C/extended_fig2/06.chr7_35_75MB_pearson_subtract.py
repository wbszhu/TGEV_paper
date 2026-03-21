import cooler
import cooltools
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

# --- 步骤 1: 加载归一化后的Hi-C数据 ---
# 假设我们有一个.mcool文件，包含了多种分辨率的Hi-C数据
# .cool文件是Hi-C数据的标准格式
uri1 = '/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/100000' # 使用100kb分辨率
clr1 = cooler.Cooler(uri1)
uri2 = '/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/100000' # 使用100kb分辨率
clr2 = cooler.Cooler(uri2)
start, end = 35_000_000, 75_000_000
region = ('chr7', start, end)

# 获取这条染色体的Hi-C矩阵 (已经是归一化后的)
hic_matrix1 = clr1.matrix(balance=True).fetch(region)
hic_matrix2 = clr2.matrix(balance=True).fetch(region)

# --- 步骤 2: 计算观测/期望 (O/E) 矩阵 ---
# cooltools可以高效地计算期望值
# 'expected' 是一个DataFrame，包含了每个对角线（即每个距离）的平均互作值
expected_df1 = cooltools.expected_cis(clr=clr1, view_df=None, nproc=2)
exp_vec1 = expected_df1[expected_df1['region1']=='chr7']['balanced.avg'].values
expected_df2 = cooltools.expected_cis(clr=clr2, view_df=None, nproc=2)
exp_vec2 = expected_df2[expected_df2['region1']=='chr7']['balanced.avg'].values

# 使用cooltools的API来计算O/E矩阵
dist1 = np.subtract.outer(np.arange(hic_matrix1.shape[0]), np.arange(hic_matrix1.shape[0]))
exp_mat1 = np.zeros_like(hic_matrix1)
for d in np.unique(np.abs(dist1)):
    exp_mat1[np.abs(dist1)==d] = exp_vec1[d]  # 给所有距离为 d 的位置赋上期望值

oe_mat1 = hic_matrix1 / (exp_mat1 + 1e-6)

dist2 = np.subtract.outer(np.arange(hic_matrix2.shape[0]), np.arange(hic_matrix2.shape[0]))
exp_mat2 = np.zeros_like(hic_matrix2)
for d in np.unique(np.abs(dist2)):
    exp_mat2[np.abs(dist2)==d] = exp_vec2[d]  # 给所有距离为 d 的位置赋上期望值

oe_mat2 = hic_matrix2 / (exp_mat2 + 1e-6)
# --- 步骤 3: 计算皮尔逊相关矩阵 ---
# 使用numpy的corrcoef函数，它能高效地计算相关矩阵
oe_mat1 = np.nan_to_num(oe_mat1, nan=1.0)
oe_mat2 = np.nan_to_num(oe_mat2, nan=1.0)

correlation_matrix1 = np.corrcoef(oe_mat1)
correlation_matrix2 = np.corrcoef(oe_mat2)
correlation_matrix = correlation_matrix2 - correlation_matrix1

# 处理计算过程中可能出现的NaN值（如果某一行/列方差为0）
correlation_matrix = np.nan_to_num(correlation_matrix, nan=0.0)

# --- 可视化 ---
colors = ['#304172','#ffffff','#c0271d']
cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
plt.figure(figsize=(10, 10))
plt.imshow(correlation_matrix, 
           cmap=cmap, # 'seismic'红蓝色谱非常适合展示正负相关
           vmin=-0.15, 
           vmax=0.15)
plt.colorbar(label='Pearson Correlation')
plt.title('Pearson Correlation Matrix for chr7')
plt.show()
plt.savefig("Fig1c_subtract.pdf")