df <- read.csv("key_tpm.csv", header=T, sep="\t")
library("pheatmap")
library("RColorBrewer")
colors <- brewer.pal(9, "YlGnBu")
genelist <- c('CCN1', 'FLRT3', 'DUSP5', 'MYC', "WSCD1",
              'CITED2', 'HOXB6', 'PCK1', 'SCD', 'IL22RA1', 'CYP1A1') # 关注的基因
labels <- df$gene_id #设置label
labels[!labels %in% genelist] <- "" #将除去关注的基因，都设置为空
df1 <- df[c("TGEV_REP1", "TGEV_REP2", "TGEV_REP3", "WT_REP1", "WT_REP2", "WT_REP3")]#将需要去画图的列，提取出来
pdf("key_tpm.pdf")
pheatmap(log10(df1+0.001), 
         cluster_rows=F, 
         color = colors,
         cluster_cols=T, 
         labels_row = labels,
         legend_breaks = c(-2, -1, 0, 1, 2, max(log10(df1+0.001))),
         legend_labels = c("-2", "-1", "0", "1", "2", "log10(TPM)\n"),
         fontsize = 20
         )

dev.off()
#key_tpm.csv
#gene_id TGEV_REP1       TGEV_REP2       TGEV_REP3       WT_REP1 WT_REP2 WT_REP3
#CCN1    1039.70 859.87  914.02  44.51   50.14   38.50
#FLRT3   322.69  287.43  254.29  23.45   20.12   22.83
#DUSP5   135.58  140.06  140.43  7.12    7.45    6.83
#MYC     590.88  595.21  748.01  31.06   40.75   30.37
#CITED2  122.18  119.62  103.33  4.91    6.03    6.81
#HOXB6   14.43   13.32   15.82   54.22   61.53   55.72
#PCK1    2.11    3.49    2.09    15.03   17.47   18.10
#SCD     35.54   31.77   29.25   71.73   94.66   93.74
#WSCD1   0.83    0.68    1.27    1.76    1.67    1.53
#IL22RA1 1.19    1.69    1.89    6.92    16.63   6.50
#CYP1A1  3.46    4.08    3.13    18.18   11.55   13.45
