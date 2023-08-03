#建议直接使用猪的注释包
library(org.Ss.eg.db)
#载入GO分析和绘图所需要的包以及文件
library(ggplot2)
library(clusterProfiler)
setwd("C:/Users/you/Desktop/TGEV101")
gene_up <- read.table("deseq2_up.txt",header=T,sep="\t")
#转换id为name
gene_up$ensembl_id <- row.names(gene_up)
trans <- read.table("id_name.txt",header = F,sep = "\t")
colnames(trans) <- c("ensembl_id","gene_name")
merge_all <- merge(gene_up,trans,by="ensembl_id")
#MF
MF <- enrichGO(gene = merge_all$gene_name,  #基因列表(转换的ID)
               keyType = "SYMBOL",  #指定的基因ID类型，默认为ENTREZID
               OrgDb=org.Ss.eg.db,  #物种对应的org包
               ont = "MF",   #CC细胞组件，MF分子功能，BF生物学过程
               pvalueCutoff = 0.05,  #p值阈值
               pAdjustMethod = "fdr",  #多重假设检验校正方式
               minGSSize = 1,   #注释的最小基因集，默认为10
               maxGSSize = 500,  #注释的最大基因集，默认为500
               readable = TRUE,   #显示为基因SYMBOL，方便阅读
               qvalueCutoff = 0.05)  #q值阈值

MF_df <- MF@result  #dataframe格式
MF_df <- subset(MF_df, MF_df$p.adjust<0.05)      #显著的
MF_df$type <- "MF"     #加一列标识
MF_df <- MF_df[,c(10,1:9)]      #把标识放第一列
#BP
 #物种对应的org包
BP <- enrichGO(gene = merge_all$gene_name,  #基因列表(转换的ID)
               keyType = "SYMBOL",  #指定的基因ID类型，默认为ENTREZID
               OrgDb=org.Ss.eg.db,  #p值阈值
               ont = "BP",   #CC细胞组件，MF分子功能，BF生物学过程
               pvalueCutoff = 0.05, 
               pAdjustMethod = "fdr",  #多重假设检验校正方式
               minGSSize = 1,   #注释的最小基因集，默认为10
               maxGSSize = 500,  #注释的最大基因集，默认为500
               readable = TRUE,    #显示为基因SYMBOL
               qvalueCutoff = 0.05)  #p值阈值 


BP_df <- BP@result
BP_df <- subset(BP_df, BP_df$p.adjust<0.05)
BP_df$type <- "BP"
BP_df <- BP_df[,c(10,1:9)]
#CC
CC <- enrichGO(gene = merge_all$gene_name,  #基因列表(转换的ID)
               keyType = "SYMBOL",  #指定的基因ID类型，默认为ENTREZID
               OrgDb=org.Ss.eg.db,  #物种对应的org包
               ont = "CC",   #CC细胞组件，MF分子功能，BF生物学过程
               pvalueCutoff = 0.05,  #p值阈值
               pAdjustMethod = "fdr",  #多重假设检验校正方式
               minGSSize = 1,   #注释的最小基因集，默认为10
               maxGSSize = 500,  #注释的最大基因集，默认为500
               readable = TRUE,
               qvalueCutoff = 0.05)  #p值阈值 


CC_df <- CC@result
CC_df <- subset(CC_df, CC_df$p.adjust<0.05)
CC_df$type <- "CC"
CC_df <- CC_df[,c(10,1:9)]
#把表合起来
all_tab <- rbind(MF_df,BP_df,CC_df)
write.table(all_tab, "C:/Users/you/Desktop/GO_Mock_VS_TGEV_up(pig).csv", sep = ",", row.names = F)
#选取top10
MF_10 <- MF_df[1:10,]
MF_10 <- MF_10[order(MF_10$Count,decreasing = FALSE),]
BP_10 <- BP_df[1:10,]
BP_10 <- BP_10[order(BP_10$Count,decreasing = FALSE),]
CC_10 <- CC_df[1:10,]
CC_10 <- CC_10[order(CC_10$Count,decreasing = FALSE),]
all_10 <- rbind(MF_10, BP_10, CC_10)
#将横轴以因子形式表示，以保证绘图时在一起
all_10$Description <- as.character(all_10$Description)
all_10$Description <- factor(all_10$Description,levels = c(all_10$Description)) #再强制加入因子
#绘图
pdf("GO_up(pig).pdf",width = 9,height = 5)
ggplot(all_10,aes(x=Description,y=Count,fill=type))+
  geom_bar(stat="identity")+
  labs(x="Description",y="Num of Genes",fill="Category",title = "Up's Most Enrich GO")+
  scale_fill_manual(values=c("#66c3a5","#fd8d62","#8da1cb"))+
  coord_flip()+
  theme(panel.grid = element_blank(),
        panel.background = element_rect(color = 'black',fill = 'transparent'))
dev.off()
