def chr_mat(sample,cool,outfile):
    # import standard python libaries
    import matplotlib as mpl
    mpl.rcParams['pdf.fonttype'] = 42
    import numpy as np
    import matplotlib.pyplot as plt
    import seaborn as sns
    import pandas as pd
    import os
    import cooltools
    import cooler
    import cooltools.lib.plotting
    
    clr = cooler.Cooler(f'{cool}::/resolutions/5000')

    f, ax = plt.subplots(figsize=(7,6))
    start, end = 91_100_000, 91_800_000
    region = ('chr9', start, end)
    im = ax.matshow(clr.matrix().fetch(region),vmax=0.02,cmap='terrain',extent=(start,end,end,start))
    plt.colorbar(im, fraction=0.046, pad=0.04, label='Contact frequency')
    ax.set(xlabel=sample,ylabel=f'chr9:{start:,}-{end:,}')
    ax.xaxis.set_label_position('top')
    plt.savefig(outfile)
    plt.show()

chr_mat("WT","/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/WT/WT.balanceNoMTY.mcool","IL6_wt.pdf")
