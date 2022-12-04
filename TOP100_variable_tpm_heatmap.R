df <- read.csv("C:\\Users\\luzhang\\Desktop\\TOP100_variable_tpm.txt", header=T, sep="\t")
library("pheatmap")
library("RColorBrewer")
gene <- c()
labels <- df$gene #设置label
labels[!labels %in% genelist] <- "" #将除去关注的基因，都设置为空
df1 <- df[c("WT_REP1", "WT_REP2", "WT_REP3", "TGEV_REP1", "TGEV_REP2", "TGEV_REP3")]#将需要去画图的列，提取出来
pheatmap(log10(df1+0.001), 
         cluster_rows=F, 
         cluster_cols=T, 
         labels_row = labels,
         color = colorRampPalette(c("navy", "white", "firebrick3"))(50),
         legend_breaks = c(-3, -2, 1, 0, 1, 2, 3),
         main = "Top 100 differential genes",
         cellheight = 3,
         fontsize = 20
)



#> head(df)
#                  id TGEV_REP1 TGEV_REP2 TGEV_REP3 WT_REP1 WT_REP2 WT_REP3
#1 ENSSSCG00000029403      0.00      4.06      4.30    0.00    0.00    0.00
#2 ENSSSCG00000010376      1.95      1.49      1.82    0.00    0.00    0.04
#3 ENSSSCG00000020970     69.98     67.53     59.43    0.86    0.00    0.32
#4 ENSSSCG00000021569      7.71      7.05     10.93    0.06    0.16    0.04
#5 ENSSSCG00000000668     23.66     23.67     19.38    0.21    0.44    0.14
#6 ENSSSCG00000047565      0.55      0.74      0.61    0.00    0.00    0.03
