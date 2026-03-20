import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
import matplotlib.pyplot as plt
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("100kb_ab.txt", sep="\t")
df.columns = ["chrom", "start","end", "E1_WT", "E1_PI"]
df['type'] = None

df.loc[(df["E1_WT"]>0)&(df["E1_PI"]<0), 'type'] = 'AB'
df.loc[(df["E1_WT"]<0)&(df["E1_PI"]>0), 'type'] = 'BA'
df.loc[(df["E1_WT"]<0)&(df["E1_PI"]<0), 'type'] = 'StableB'
df.loc[(df["E1_WT"]>0)&(df["E1_PI"]>0), 'type'] = 'StableA'

fig, ax = plt.subplots(figsize=(10,10))
sns.scatterplot(x=df["E1_WT"], y=df["E1_PI"], data=df, hue=df["type"], s=20, edgecolors=None, palette=['#e64b35', '#4dbbd5', '#01a087', '#3c5488'])
plt.gca().set_aspect(1.0)
plt.axhline(y=0, linestyle='--', color="black", linewidth=1)
plt.axvline(x=0, linestyle='--', color="black", linewidth=1)
plt.xlabel("Eigenvectors1 WT")
plt.ylabel("Eigenvectors1 PI")
plt.savefig("Fig2b.pdf")