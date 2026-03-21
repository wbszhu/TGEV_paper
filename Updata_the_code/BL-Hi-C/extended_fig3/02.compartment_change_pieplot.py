import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# 如果需要中文显示，取消下面这句注释
# plt.rcParams['font.sans-serif'] = ['SimHei']

values = [9961, 12322, 1049, 596]
labels = ["Stable A", "Stable B", "A-to-B", "B-to-A"]
colors = ["#2e75b5", "#f4b184", "#854788", "#e64954"]

plt.figure(figsize=(6, 6))
plt.pie(values,
        labels=labels,
        autopct="%1.1f%%",      # 显示百分比
        startangle=90,          # 让第一块从12点方向开始
        counterclock=False,
        colors = colors)     # 顺时针方向

plt.tight_layout()
plt.savefig('compartment_change_pieplot.pdf')
plt.show()

