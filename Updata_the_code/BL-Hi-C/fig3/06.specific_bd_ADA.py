import cooler
import cooltools
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

uri = '/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/10000' # 使用10kb分辨率
clr = cooler.Cooler(uri)
resolution = clr.binsize
sites= pd.read_csv('/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/04.new_addanalysis/11.fig3/fig3a/changed_bd/pi_changed_bd.bed', sep='\t', header=None, names=['chrom', 'start', 'end'])

expected = cooltools.expected_cis(clr, view_df=None, nproc=8, chunksize=1_000_000)
stack = cooltools.pileup(clr, sites, view_df=None, expected_df=expected, flank=300_000, nproc=8)
mtx = np.nanmean(stack, axis=0)

plt.figure(figsize=(6,6))
plt.imshow(
    np.log2(mtx),
    vmax = 1.0,
    vmin = -1.0,
    cmap='coolwarm',
    interpolation='none')

plt.colorbar(label = 'log2 mean obs/exp')
flank=300000
ticks_pixels = np.linspace(0, flank*2//resolution,5)
ticks_kbp = ((ticks_pixels-ticks_pixels[-1]/2)*resolution//1000).astype(int)
plt.xticks(ticks_pixels, ticks_kbp)
plt.yticks(ticks_pixels, ticks_kbp)
plt.xlabel('relative position, kbp')
plt.ylabel('relative position, kbp')
plt.savefig("Fig3c_pi.pdf")
plt.show()