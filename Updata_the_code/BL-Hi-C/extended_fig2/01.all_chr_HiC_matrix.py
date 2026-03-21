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
    
    clr = cooler.Cooler(f'{cool}::/resolutions/100000')
    chromstarts = []
    for i in clr.chromnames:
        print(f'{i}:{clr.extent(i)}')
        chromstarts.append(clr.extent(i)[0])
    
    f, ax = plt.subplots(figsize=(7,6))
    im = ax.matshow(clr.matrix()[:],vmax=0.001,cmap='terrain')
    plt.colorbar(im, fraction=0.046, pad=0.04, label='Contact frequency')
    ax.set(xticks=chromstarts, xticklabels=clr.chromnames,
           xlabel=sample)
    ax.xaxis.set_label_position('top')
    plt.savefig(outfile)
    plt.show()

chr_mat("PI","/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/01.HiC/02.test_hic-tgev/01.cooltools/PI/PI.balanceNoMTY.mcool","pi_allchr.pdf")
