import pandas as pd

DATA_DIR = "/path/to/cutandtag/data/101TGEV"
PROMOTER_DIR = f"{DATA_DIR}/05.pro_enh/01.promoter/pi_new"

df = pd.read_table(f"{PROMOTER_DIR}/pi-k4me3_peakReadcount.txt")
df.columns = ["chr", "start", "end", "k4me3_1", "k4me3_2", "input_1", "input_2"]
# Normalization of sequence depth
df["k4me3_1nor"] = df["k4me3_1"]/13
df["k4me3_2nor"] = df["k4me3_2"]/58
df["igg_1nor"] = df["input_1"]/8
df["igg_2nor"] = df["input_2"]/9
# Calculate the mean of H3K4me3
def mean_of_cols(row):
        return row[["k4me3_1nor","k4me3_2nor"]].mean()

df["k4me3_mean"] = df.apply(mean_of_cols, axis=1)
# Calculate the mean of input
def mean_of_cols(row):
        return row[["igg_1nor","igg_2nor"]].mean()

df["igg_mean"] = df.apply(mean_of_cols, axis=1)
# Calculate change and foldchange
df["change"] = df["k4me3_mean"]-df["igg_mean"]
df["foldchange"] = df["k4me3_mean"]/df["igg_mean"]
# Selection
df_out = df[(df["foldchange"]>2)&(df["change"]>1)]
# Write to the output file
col_list = ["chr", "start", "end"]
df_out.to_csv(f"{PROMOTER_DIR}/pi-goodk4me3.bed", columns=col_list, sep="\t", index=False, header=False)
