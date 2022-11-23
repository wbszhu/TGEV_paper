df <- read.csv("C:\\Users\\luzhang\\Desktop\\all_variable_tpm.csv", header=T, sep="\t")
library("pheatmap")
library("RColorBrewer")
colors <- brewer.pal(9, "YlGnBu")
genelist <- c("AP2B1","GDF10","IL19") # 关注的基因
labels <- df$gene_id #设置label
labels[!labels %in% genelist] <- "" #将除去关注的基因，都设置为空
df1 <- df[c("TGEV_REP1", "TGEV_REP2", "TGEV_REP3", "WT_REP1", "WT_REP2", "WT_REP3")]#将需要去画图的列，提取出来
pheatmap(log10(df1+0.001), cluster_rows=F, color = colors, cluster_cols=T, labels_row = labels, cellwidth = 15, cellheight = 13, fontsize = 8, )

