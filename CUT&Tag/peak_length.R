peak_length <- function(dir){
  #载入需要的包
  library(ggplot2)
  #设置工作目录
  setwd(dir)
  #将工作目录下文件形成一个列表批量处理
  list_file <- list.files()
  data <- data.frame()
  for (i in list_file){
    peak <- read.table(i)
    peak_lengths <- peak$V3 - peak$V2 + 1
    peak_length_counts <- table(peak_lengths)
    lengths_df <- data.frame(Length = as.numeric(names(peak_length_counts)),
                             Count = as.numeric(peak_length_counts/nrow(peak)),
                             Sample = i)
    data <- rbind(data,lengths_df)
  }
  ggplot(data, aes(x = Length, y = Count, color = Sample, group = Sample)) +
    geom_line() +
    xlab("Length") +
    xlim(0, 2000)+
    ylab("Density") +
    ggtitle("CUT&Tag Peak Length Distribution")+
    theme_classic()
}
peak_length("C:/Users/you/Desktop/length")