import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# Data
groups = ['All', 'Share', 'WT', 'PI']
Up_regulated = np.array([988, 53, 50, 55])
Down_regulated = np.array([607, 6, 19, 25])

# Calculate proportions
total = Up_regulated + Down_regulated
g1_pct = Up_regulated / total * 100
g2_pct = Down_regulated / total * 100

# Positions
x = np.arange(len(groups))
bar_width = 0.8

# Plot stacked bar chart
fig, ax = plt.subplots(figsize=(7, 5))
colors = {'Up_regulated':'#c0271d', 'Down_regulated':'#304172'}

plt.bar(x, g1_pct, label='Up-Regulated', color=colors['Up_regulated'], width=bar_width)
plt.bar(x, g2_pct, bottom=g1_pct, label='Down-Regulated', color=colors['Down_regulated'], width=bar_width)

plt.xticks(x, groups)
plt.ylabel("Percentage (%)")
plt.ylim(0, 100)
plt.legend(loc='center left', bbox_to_anchor=(1.02, 0.5), borderaxespad=0.)
plt.tight_layout()
plt.savefig('panchor_DEGs_percentage_barplot.pdf')
plt.show()
