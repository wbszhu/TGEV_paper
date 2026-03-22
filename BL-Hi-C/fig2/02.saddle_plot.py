import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import click
import sys
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
import matplotlib.patches as patches
import numpy as np
import pandas as pd
from matplotlib.colors import LinearSegmentedColormap

@click.command("python saddle.py npz sampleid")
@click.argument("npz")
@click.argument("sampleid")
def saddle(npz, sampleid):
    saddle = np.load(npz, allow_pickle=True)
    x = saddle['saddledata'].shape
    y = x[0]-10
    up1 = saddle['saddledata'][:10,:10]  #Top-left quadrant
    up2 = saddle['saddledata'][y:,:10] #Bottom-left quadrant
    down1 = saddle['saddledata'][:10,y:]  #Top-right quadrant
    down2 = saddle['saddledata'][y:,y:] #Bottom-right quadrant

    up1_m = np.mean(up1)
    up2_m = np.mean(up2)
    down1_m = np.mean(down1)
    down2_m = np.mean(down2)

    fig, ax = plt.subplots(figsize=(10,10))
    norm = LogNorm(vmin=0.2, vmax=3)
    colors = ["#01a087", "#ffffff", "#e99c85"]
    cmap = LinearSegmentedColormap.from_list("custom_cmap", colors)
    im = ax.imshow(saddle['saddledata'],cmap=cmap,norm = norm)
    ax.add_patch(patches.Rectangle((-1, -1),10,10,edgecolor='black',fill=False,lw=1))
    ax.add_patch(patches.Rectangle((y, y),10,10,edgecolor='black',fill=False,lw=1))
    ax.add_patch(patches.Rectangle((-1, y),10,10,edgecolor='black',fill=False,lw=1))
    ax.add_patch(patches.Rectangle((y, -1),10,10,edgecolor='black',fill=False,lw=1))
    text = ax.text(2.5, 5, "%.2f" % up1_m, fontsize = 20)
    text = ax.text(44.5, 5, "%.2f" % up2_m, color = "w", fontsize = 20)
    text = ax.text(2.5, 47.5, "%.2f" % down1_m, color = "w", fontsize = 20)
    text = ax.text(44.5, 47.5, "%.2f" % down2_m, fontsize = 20)
    plt.colorbar(im, label='obs/exp', pad=0.025, shrink=0.7)
    plt.show()
    plt.savefig(f"Fig2a_{sampleid}2.pdf")
    
if __name__ == "__main__":
    saddle()
