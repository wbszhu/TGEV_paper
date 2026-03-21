import pandas as pd

DATA_DIR = "/path/to/cutandtag/data/101TGEV"
ENHANCER_DIR = f"{DATA_DIR}/05.pro_enh/02.enhancer/pi_new"

df = pd.read_table(f"{ENHANCER_DIR}/pi-k27ac_peakReadcount.txt")
df.columns = ["chr", "start", "end", "H3K27ac_1", "H3K27ac_2", "input_1", "input_2"]
# Normalization of sequence depth
df["H3K27ac_1nor"] = df["H3K27ac_1"]/38
df["H3K27ac_2nor"] = df["H3K27ac_2"]/59
df["igg_1nor"] = df["input_1"]/8
df["igg_2nor"] = df["input_2"]/9
# Calculate the mean of H3K27ac
def mean_of_cols(row):
        return row[["H3K27ac_1nor","H3K27ac_2nor"]].mean()

df["27ac_mean"] = df.apply(mean_of_cols, axis=1)
# Calculate the mean of input
def mean_of_cols(row):
        return row[["igg_1nor","igg_2nor"]].mean()

df["igg_mean"] = df.apply(mean_of_cols, axis=1)
# Calculate the change and foldchange
df["change"] = df["27ac_mean"]-df["igg_mean"]
df["foldchange"] = df["27ac_mean"]/df["igg_mean"]
# Selection
df_out = df[(df["foldchange"]>2)&(df["change"]>1)]
# Write to the output file
col_list = ["chr", "start", "end"]
df_out.to_csv(f"{ENHANCER_DIR}/pi-good27ac.bed", columns=col_list, sep="\t", index=False, header=False)
