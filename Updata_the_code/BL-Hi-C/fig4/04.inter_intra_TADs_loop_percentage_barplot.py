import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# 数据
groups = ['WT', 'PI']
intraTAD = np.array([8109, 7796])
interTAD = np.array([4733, 6026])

# 位置
total = intraTAD + interTAD
g1_pct = intraTAD / total * 100
g2_pct = interTAD /total * 100

x = np.arange(len(groups))
bar_width = 0.4

# 绘制堆叠柱状图
fig, ax = plt.subplots(figsize=(5,5))

colors = {'inter-TAD':'#e64b35', 'intra-TAD':'#4dbbd5'}
plt.bar(x, g2_pct, label='inter-TAD',color=colors['inter-TAD'], width=bar_width)
plt.bar(x, g1_pct, bottom=g2_pct, label='intra-TAD', color=colors['intra-TAD'], width=bar_width)  # 堆叠在 A 上

plt.xticks(x, groups)
plt.ylabel("Percentage (%)")
plt.ylim(0,100)
plt.legend(loc='center left', bbox_to_anchor=(1.02, 0.5), borderaxespad=0.)
plt.tight_layout()
plt.savefig('tad_loop_barplot.pdf')
plt.show()
