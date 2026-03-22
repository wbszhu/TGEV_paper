import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# Data
groups = ['Part1', 'Part2', 'Part3', 'Part4', 'Part5', 'Part6']
Up_regulated = np.array([67,75,624,490,15,14])
Down_regulated = np.array([38,52,437,306,10,22])
Stable_regulated = np.array([778,878,8076,6221,499,529])

# Calculate proportions
total = Up_regulated + Down_regulated + Stable_regulated
g1_pct = Up_regulated / total * 100
g2_pct = Down_regulated / total * 100
g3_pct = Stable_regulated / total * 100
# Positions
x = np.arange(len(groups))
bar_width = 0.8

# Plot stacked bar chart
fig, ax = plt.subplots(figsize=(7, 5))
colors = {'Up_regulated':'#c0271d', 'Down_regulated':'#304172', 'Stable_regulated':'#d3d3d5'}

plt.bar(x, g3_pct, label='Stable-Regulated', color=colors['Stable_regulated'], width=bar_width)
plt.bar(x, g2_pct, bottom=g3_pct, label='Down-Regulated', color=colors['Down_regulated'], width=bar_width)
plt.bar(x, g1_pct, bottom=g2_pct + g3_pct, label='Up-Regulated', color=colors['Up_regulated'], width=bar_width)

plt.xticks(x, groups)
plt.ylabel("Percentage (%)")
plt.ylim(0, 100)
plt.legend(loc='center left', bbox_to_anchor=(1.02, 0.5), borderaxespad=0.)
plt.tight_layout()
plt.savefig('TADs_DEGs_percentage_barplot.pdf')
plt.show()
