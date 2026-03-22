import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import numpy as np

# If Chinese display is needed, uncomment the line below
# plt.rcParams['font.sans-serif'] = ['SimHei']

values = [9961, 12322, 1049, 596]
labels = ["Stable A", "Stable B", "A-to-B", "B-to-A"]
colors = ["#2e75b5", "#f4b184", "#854788", "#e64954"]

plt.figure(figsize=(6, 6))
plt.pie(values,
        labels=labels,
        autopct="%1.1f%%",      # Show percentages
        startangle=90,          # Start the first slice from the 12 o'clock position
        counterclock=False,
        colors = colors)     # Clockwise direction

plt.tight_layout()
plt.savefig('compartment_change_pieplot.pdf')
plt.show()

