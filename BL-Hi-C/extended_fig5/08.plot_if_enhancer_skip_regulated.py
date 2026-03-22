import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# Data
groups = ['WT', 'PI']
skipping = np.array([940, 1050])
nonskipping = np.array([232, 228])

# Calculate proportions
total = skipping + nonskipping
g1_pct = skipping / total * 100
g2_pct = nonskipping / total * 100

# Positions
x = np.arange(len(groups))
bar_width = 0.4

# Plot stacked bar chart
fig, ax = plt.subplots(figsize=(5, 5))
colors = {'non-skipping':'#00a087', 'skipping':'#f39b7f'}

plt.bar(x, g1_pct, label='skipping', color=colors['skipping'], width=bar_width)
plt.bar(x, g2_pct, bottom=g1_pct, label='non-skipping', color=colors['non-skipping'], width=bar_width)

plt.xticks(x, groups)
plt.ylabel("Percentage (%)")
plt.ylim(0, 100)
plt.legend(loc='center left', bbox_to_anchor=(1.02, 0.5), borderaxespad=0.)
plt.tight_layout()
plt.savefig('enhancer_regulate_promoter_barplot.pdf')
plt.show()
