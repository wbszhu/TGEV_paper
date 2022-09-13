##读取数据
setwd("C:\\Users\\lzhang\\Desktop\\TGEV") #设置工作目录，所有输出文件保存于此
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
  scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 50)) + #设置label
  theme(axis.title = element_text(size = 13), # 坐标轴标题大小
        axis.text = element_text(size = 11), # 坐标轴标签大小
        plot.title = element_text(size = 14,hjust = 0.5,face = "bold"), # 标题设置
        legend.title = element_text(size = 13), # 图例标题大小
        legend.text = element_text(size = 11), # 图例标签大小
        plot.margin = unit(c(0.5,0.5,0.5,0.5),"cm")) # 图边距

p

pdf("goenrichment_adjusted_p_value_up.pdf")
p
dev.off()
