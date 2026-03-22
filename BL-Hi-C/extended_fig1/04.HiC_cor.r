# Set working directory
pc1 <- read.table("total_rep_pc1.txt", sep="\t")
colnames(pc1) <- c("Mock_rep1", "Mock_rep2", "TGEV_rep1", "TGEV_rep2")
pc1_cor <- cor(pc1, method = "pearson", use = "pairwise.complete.obs")
heatmap <- pheatmap(pc1_cor,
                    cluster_rows = T,
                    cluster_cols = T,
                    scale="none",
                    cellwidth = 30,cellheight = 30 ,# Set heatmap cell width and height
                    display_numbers = TRUE,
                    fontsize_number = 8, # Font size of numbers on the heatmap
                    number_color="black", # Font color of numbers on the heatmap
                    number_format="%.3f", # Number format on the heatmap
                    color = colorRampPalette(c("#f5faf4","#319c87"))(100))
