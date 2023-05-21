pieplot <- function(dir){
  #载入注释需要的包
  library(ChIPseeker)
  library(GenomicFeatures)
  Anno <- function(input,output){
    #读入peak文件
    peak <- readPeakFile(input)
    #读入txdb文件
    txdb <- loadDb("C:/Users/you/Desktop/EpiMap/TxDb.Sus_scrofa.Ensembl.Rambouilletv1.sqlite")
    #对peak进行注释
    peakAnno <- annotatePeak(peak, tssRegion = c(-1500, 2500), TxDb = txdb)
    #对注释结果绘制饼图
    pdf(output)
    plotAnnoPie(peakAnno)
    dev.off()
  }
  #设置工作目录
  setwd(dir)
  #将工作目录下文件形成一个列表批量处理
  list_file <- list.files()
  n= length(list_file)
  out_path <- paste(list_file,".pdf",sep="")
  #传入参数批量调用函数
  for (i in 1:n){
    Anno(input=list_file[i],output=out_path[i])
  }
}
pieplot("C:/Users/you/Desktop/peak")