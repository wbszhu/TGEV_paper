#设置工作路径
pc1 <- read.table("total_rep_pc1.txt", sep="\t")
colnames(pc1) <- c("Mock_rep1", "Mock_rep2", "TGEV_rep1", "TGEV_rep2")
pc1_cor <- cor(pc1, method = "pearson", use = "pairwise.complete.obs")
heatmap <- pheatmap(pc1_cor,
                    cluster_rows = T,
                    cluster_cols = T,
                    scale="none",
                    cellwidth = 30,cellheight = 30 ,# 设置热图单元格宽度和高度
                    display_numbers = TRUE,
                    fontsize_number = 8, #热图上数值的字体大小
                    number_color="black", #热图上数值的字体颜色
                    number_format="%.3f", #热图上数值的字体类型
                    color = colorRampPalette(c("#f5faf4","#319c87"))(100))
