##Read data
setwd("./") #Set working directory; all output files will be saved here
df <- read.csv("GOtermplot.csv")
## colors for bar // green, blue, orange
CPCOLS <- c("#8DA1CB", "#FD8D62", "#66C3A5")

df$term_name <- factor(df$term_name,levels = rev(df$term_name))

library(ggplot2)
p <- ggplot(data=df, aes(x=term_name, y=negative_log10_of_adjusted_p_value, fill=source)) +
  geom_bar(stat="identity", width=0.9) + coord_flip() +
  scale_fill_manual(values = CPCOLS) + theme_bw() +
  scale_x_discrete(labels=labels) +
  theme_bw()+
  labs(x = "GO terms",y = "-log10(adjusted_p_value)",title = "Barplot of Enriched GO Terms")+
  coord_flip()+theme_bw()+
  scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 50)) + #Set label wrapping
  theme(axis.title = element_text(size = 13), # Axis title size
        axis.text = element_text(size = 11), # Axis label size
        plot.title = element_text(size = 14,hjust = 0.5,face = "bold"), # Title settings
        legend.title = element_text(size = 13), # Legend title size
        legend.text = element_text(size = 11), # Legend label size
        plot.margin = unit(c(0.5,0.5,0.5,0.5),"cm")) # Plot margins

p

pdf("goenrichment_adjusted_p_value_up.pdf")
p
dev.off()
