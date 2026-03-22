import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# Data
groups = ['WT', 'PI']
compartmentA = np.array([10994, 10537])
compartmentB = np.array([12934, 13355])

# Positions
total = compartmentA + compartmentB
g1_pct = compartmentA / total * 100
g2_pct = compartmentB /total * 100

x = np.arange(len(groups))
bar_width = 0.4

# Plot stacked bar chart
fig, ax = plt.subplots(figsize=(5,5))

colors = {'CompartmentA':'#e64b35', 'CompartmentB':'#4dbbd5'}
plt.bar(x, g2_pct, label='CompartmentB',color=colors['CompartmentB'], width=bar_width)
plt.bar(x, g1_pct, bottom=g2_pct, label='CompartmentA', color=colors['CompartmentA'], width=bar_width)  # Stacked on top of A

plt.xticks(x, groups)
plt.ylabel("Percentage (%)")
plt.ylim(0,100)
plt.legend(loc='center left', bbox_to_anchor=(1.02, 0.5), borderaxespad=0.)
plt.tight_layout()
plt.savefig('compartment_ratio_barplot.pdf')
plt.show()
