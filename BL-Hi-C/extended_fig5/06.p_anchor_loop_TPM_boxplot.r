data <- read.table("final_tpm_plot_10kb.txt", sep="\t")
data <- data[,-c(7,8)]
data2 <- unique(data)
colnames(data2) <- c("loop", "group", "chr", "start", "end", "ensembl", "TPM")
data2$LogTPM <- log(data2$TPM+1)

library(ggplot2)
library(ggsci)
library(ggsignif)
data2$group <- factor(data2$group, levels = c("wt", "pi"))
data2$loop <- factor(data2$loop, levels = c("promoter_repressor", "other_promoter", "promoter_promoter", "enhancer_promoter"))
ggplot(data2, aes(x=group, y=LogTPM)) +
  geom_boxplot(aes(fill=loop), outlier.shape = NA) +
  scale_fill_npg() +
  theme_classic() +
  ylim(0,8)

ggsave("group_ccres_loop_tpm_10kb.pdf", width=5, height = 4)
