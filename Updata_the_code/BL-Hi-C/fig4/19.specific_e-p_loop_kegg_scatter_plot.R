library(ggplot2)

data <- read.table("kegg_plot.txt", header=T, sep="\t")
data2 <- data[,c(4,7,13)]
data2$type <- c('WT_specific','WT_specific','WT_specific','Common','Common','Common','Common','Common'
                ,'Common','Common','Common'
                ,'WT_specific','WT_specific','PI_specific','PI_specific','PI_specific','PI_specific')

data2$group <- factor(data2$group, levels = c('WT','Share','PI'))
data2$Description <- factor(data2$Description, levels = c('Focal adhesion','Adherens junction','MAPK signaling pathway',
                                                          'FoxO signaling pathway','JAK-STAT signaling pathway',
                                                          'PI3K-Akt signaling pathway','p53 signaling pathway',
                                                          'TNF signaling pathway','Apoptosis','NF-kappa B signaling pathway'))

ggplot(data2, aes(x = group, y = Description)) +
  geom_point(aes(size = -log10(pvalue), color = type )) +
  scale_size_continuous(name = "-log10(pvalue)", range = c(1, 6)) +
  scale_color_manual(values = c("WT_specific" = "#3c5488", 
                                "PI_specific" = "#dc0000", 
                                "Common" = "#00a087")) +
  theme_bw() +
  theme(
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 10),
    axis.title = element_blank(),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9)
  )

ggsave("specific_loop_kegg_10kb_bubbleplot3.pdf",width = 5,height = 10)
