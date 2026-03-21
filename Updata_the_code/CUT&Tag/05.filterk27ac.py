import pandas as pd 

df = pd.read_table("/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/02.enhancer/pi_new/pi-k27ac_peakReadcount.txt")
df.columns = ["chr", "start", "end", "H3K27ac_1", "H3K27ac_2", "input_1", "input_2"]
#normalization of sequence depth
df["H3K27ac_1nor"] = df["H3K27ac_1"]/38
df["H3K27ac_2nor"] = df["H3K27ac_2"]/59
df["igg_1nor"] = df["input_1"]/8
df["igg_2nor"] = df["input_2"]/9
#Calculate the mean of 27ac
def mean_of_cols(row):
        return row[["H3K27ac_1nor","H3K27ac_2nor"]].mean()

df["27ac_mean"] = df.apply(mean_of_cols, axis=1)
#Calculate the mean of input
def mean_of_cols(row):
        return row[["igg_1nor","igg_2nor"]].mean()

df["igg_mean"] = df.apply(mean_of_cols, axis=1)
#Calculate the change and foldchange
df["change"] = df["27ac_mean"]-df["igg_mean"]
df["foldchange"] = df["27ac_mean"]/df["igg_mean"]
#selection
df_out = df[(df["foldchange"]>2)&(df["change"]>1)]
#Write to the document
col_list = ["chr", "start", "end"]
df_out.to_csv("/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/02.enhancer/pi_new/pi-good27ac.bed", columns=col_list, sep="\t", index=False, header=False)
