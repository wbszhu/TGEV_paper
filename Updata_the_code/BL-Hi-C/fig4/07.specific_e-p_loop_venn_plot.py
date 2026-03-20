import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
from matplotlib_venn import venn2
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

venn2(subsets=(1172-354, 1278-354, 354), set_labels=('Mock', 'TGEV'), set_colors=('#3C5488FF', '#DC0000FF'), alpha=1)
plt.title("Venn Diagram of Specific E/P target P")
plt.savefig("specific_p_anchor_venn_plot.pdf")
plt.show()