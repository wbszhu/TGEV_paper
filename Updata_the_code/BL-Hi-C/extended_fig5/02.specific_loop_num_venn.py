import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
from matplotlib_venn import venn2
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

venn2(subsets=(12842-3175, 13822-3175, 3175), set_labels=('Mock', 'TGEV'), set_colors=('#3C5488FF', '#DC0000FF'), alpha=1)
plt.title("Venn Diagram of Loop")
plt.savefig("specific_loop_venn_plot.pdf")
plt.show()