import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
import matplotlib.patches as patches
import numpy as np
import pandas as pd
from matplotlib.colors import LinearSegmentedColormap

saddle1 = np.load('WT_100kb_saddle.np.saddledump.npz', allow_pickle=True)
saddle2 = np.load('PI_100kb_saddle.np.saddledump.npz', allow_pickle=True)

mat1 = saddle1['saddledata']
mat2 = saddle2['saddledata']

pseudo = 1e-6
log2fc = np.log2((mat2 + pseudo)/(mat1 + pseudo))

fig, ax = plt.subplots(figsize=(10,10))
colors = ['#3c5488', '#ffffff', '#dc0100']
cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
im = ax.imshow(log2fc,cmap=cmap, vmin= -0.6, vmax=0.6)
plt.colorbar(im, label='log2FC', pad=0.025, shrink=0.7)
plt.savefig(f"Fig2a_fc.pdf")
plt.show()