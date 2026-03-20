import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# 数据
groups = ['WT', 'PI']
E_P = np.array([1314, 1431])
P_S = np.array([732, 822])
P_P = np.array([1504, 1225])
P_none = np.array([3738, 3642])

# 计算比例
total = E_P + P_S + P_P + P_none
g1_pct = E_P / total * 100
g2_pct = P_S / total * 100
g3_pct = P_P / total * 100
g4_pct = P_none / total * 100

# 位置
x = np.arange(len(groups))
bar_width = 0.4

# 绘制堆叠柱状图
fig, ax = plt.subplots(figsize=(5, 5))
colors = {'E_P':'#e96f5d', 'P_S':'#73c8db', 'P_P':'#33b3a1', 'P_none':'#6675a0'}

plt.bar(x, g1_pct, label='E-P', color=colors['E_P'], width=bar_width)
plt.bar(x, g2_pct, bottom=g1_pct, label='P-S', color=colors['P_S'], width=bar_width)
plt.bar(x, g3_pct, bottom=g1_pct + g2_pct, label='P-P', color=colors['P_P'], width=bar_width)
plt.bar(x, g4_pct, bottom=g1_pct + g2_pct + g3_pct, label='P-none', color=colors['P_none'], width=bar_width)

plt.xticks(x, groups)
plt.ylabel("Percentage (%)")
plt.ylim(0, 100)
plt.legend(loc='center left', bbox_to_anchor=(1.02, 0.5), borderaxespad=0.)
plt.tight_layout()
plt.savefig('P_anchor_loop_number_barplot.pdf')
plt.show()