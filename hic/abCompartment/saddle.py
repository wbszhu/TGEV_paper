import click
import sys

@click.command("python saddle.py npz sampleid")
@click.argument("npz")
@click.argument("sampleid")
def saddle(npz, sampleid):
    import matplotlib.pyplot as plt
    from matplotlib.colors import LogNorm
    import matplotlib.patches as patches
    import numpy as np
    import pandas as pd

    saddle = np.load(npz, allow_pickle=True)
    x = saddle['saddledata'].shape
    y = x[0]-10
    up1 = saddle['saddledata'][:10,:10]  #左 上三角
    up2 = saddle['saddledata'][y:,:10] #右 上三角
    down1 = saddle['saddledata'][:10,y:]  #左 下三角
    down2 = saddle['saddledata'][y:,y:] #右 下三角

    up1_m = np.mean(up1)
    up2_m = np.mean(up2)
    down1_m = np.mean(down1)
    down2_m = np.mean(down2)

    print(up1_m, up2_m, down1_m, down2_m)
    print(up1.shape, up2.shape, down1.shape, down2.shape)

    fig, ax = plt.subplots(figsize=(10,10))
    norm = LogNorm(vmin=10**(-1), vmax=10**1)
    ax.imshow(saddle['saddledata'],cmap='coolwarm',norm = norm)
    ax.add_patch(patches.Rectangle((-1, -1),10,10,edgecolor='black',fill=False,lw=1))
    ax.add_patch(patches.Rectangle((y, y),10,10,edgecolor='black',fill=False,lw=1))
    ax.add_patch(patches.Rectangle((-1, y),10,10,edgecolor='black',fill=False,lw=1))
    ax.add_patch(patches.Rectangle((y, -1),10,10,edgecolor='black',fill=False,lw=1))
    text = ax.text(2.5, 5, "%.2f" % up1_m, fontsize = 20)
    text = ax.text(44.5, 5, "%.2f" % up2_m, color = "w", fontsize = 20)
    text = ax.text(2.5, 47.5, "%.2f" % down1_m, color = "w", fontsize = 20)
    text = ax.text(44.5, 47.5, "%.2f" % down2_m, fontsize = 20)
    ax.set_title(f"Compartmentalization saddle plots for {sampleid}", fontsize = 20)
    plt.show()
    plt.savefig(f"Compartmentalization_saddle_plots_for_{sampleid}.pdf")
    
if __name__ == "__main__":
    saddle()
