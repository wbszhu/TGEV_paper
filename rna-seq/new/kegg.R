library(ggplot2)
library(clusterProfiler)
library(org.Hs.eg.db)
#setwd("C:/Users/you/Desktop/pig_TGEV_cut&tag/TGEV101")
gene_all <- read.table("DEGs.txt",header=T,sep="\t")
gene_all$ensembl_id <- row.names(gene_all)
trans <- read.table("id_name.txt",header = F,sep = "\t")
colnames(trans) <- c("ensembl_id","gene_name")
merge_all <- merge(gene_all,trans,by="ensembl_id")
#keytypes(org.Ss.eg.db)
all_entrezid <- bitr(merge_all$gene_name,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Hs.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #基因列表(转换的ID)
               keyType = "kegg",  #指定的基因ID类型，默认为ENTREZID
               organism ="hsa",  #物种对应的org包
               pvalueCutoff = 0.05,  #p值阈值
               pAdjustMethod = "fdr",  #多重假设检验校正方
               qvalueCutoff = 0.05)  #q值阈值
kegg <- as.data.frame(kegg)
kegg <- subset(kegg, kegg$p.adjust<0.05)
write.table(kegg, 'kegg_all.txt', sep = '\t', quote = FALSE, row.names = FALSE)
kegg <- kegg[1:20,]
#将横坐标分数转变为小数
ev = function(x){eval(parse(text = x))}
kegg$GeneRatio = round(sapply(kegg$GeneRatio,ev),3)   #让x轴变小数
#对纵坐标进行排序
kegg <- kegg[order(kegg$GeneRatio,decreasing = FALSE),]
kegg$Description <- as.character(kegg$Description)
kegg$Description <- factor(kegg$Description,levels=c(kegg$Description))
#绘图
pdf("kegg_all_hsa.pdf",width = 8,height = 5)
ggplot(kegg,aes(GeneRatio,Description,color=-log10(qvalue),size=Count))+
  geom_point()+
  labs(x="GeneRatio",y="",size="Genecounts",title = "KEGG Enrichment")+
  scale_color_gradient(low="blue",high ="red")+
  theme_bw()
dev.off()


#up
gene_up <- read.table("deseq2_up_fc1_padj0.05.txt",header=T,sep="\t")
gene_up$ensembl_id <- row.names(gene_up)
merge_all <- merge(gene_up,trans,by="ensembl_id")
#keytypes(org.Ss.eg.db)
all_entrezid <- bitr(merge_all$gene_name,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Ss.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #基因列表(转换的ID)
                   keyType = "kegg",  #指定的基因ID类型，默认为ENTREZID
                   organism ="ssc",  #物种对应的org包
                   pvalueCutoff = 0.05,  #p值阈值
                   pAdjustMethod = "fdr",  #多重假设检验校正方
                   qvalueCutoff = 0.05)  #q值阈值
kegg <- as.data.frame(kegg)
kegg <- subset(kegg, kegg$p.adjust<0.05)
write.table(kegg, 'kegg_up.txt', sep = '\t', quote = FALSE, row.names = FALSE)
kegg <- kegg[1:20,]
#将横坐标分数转变为小数
ev = function(x){eval(parse(text = x))}
kegg$GeneRatio = round(sapply(kegg$GeneRatio,ev),3)   #让x轴变小数
#对纵坐标进行排序
kegg <- kegg[order(kegg$GeneRatio,decreasing = FALSE),]
kegg$Description <- as.character(kegg$Description)
kegg$Description <- factor(kegg$Description,levels=c(kegg$Description))
#绘图
pdf("kegg_up.pdf",width = 8,height = 5)
ggplot(kegg,aes(GeneRatio,Description,color=-log10(qvalue),size=Count))+
  geom_point()+
  labs(x="GeneRatio",y="",size="Genecounts",title = "KEGG Enrichment")+
  scale_color_gradient(low="blue",high ="red")+
  theme_bw()
dev.off()


#down
gene_down <- read.table("deseq2_down_fc1_padj0.05.txt",header=T,sep="\t")
gene_down$ensembl_id <- row.names(gene_down)
merge_all <- merge(gene_down,trans,by="ensembl_id")
#keytypes(org.Ss.eg.db)
all_entrezid <- bitr(merge_all$gene_name,fromType = "SYMBOL",
                     toType = c("SYMBOL","ENTREZID"),
                     OrgDb = org.Ss.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #基因列表(转换的ID)
                   keyType = "kegg",  #指定的基因ID类型，默认为ENTREZID
                   organism ="ssc",  #物种对应的org包
                   pvalueCutoff = 0.05,  #p值阈值
                   pAdjustMethod = "fdr",  #多重假设检验校正方
                   qvalueCutoff = 0.05)  #q值阈值
kegg <- as.data.frame(kegg)
kegg <- subset(kegg, kegg$p.adjust<0.05)
write.table(kegg, 'kegg_down.txt', sep = '\t', quote = FALSE, row.names = FALSE)
#kegg <- kegg[1:20,]
#将横坐标分数转变为小数
ev = function(x){eval(parse(text = x))}
kegg$GeneRatio = round(sapply(kegg$GeneRatio,ev),3)   #让x轴变小数
#对纵坐标进行排序
kegg <- kegg[order(kegg$GeneRatio,decreasing = FALSE),]
kegg$Description <- as.character(kegg$Description)
kegg$Description <- factor(kegg$Description,levels=c(kegg$Description))
#绘图
pdf("kegg_down.pdf",width = 8,height = 5)
ggplot(kegg,aes(GeneRatio,Description,color=-log10(qvalue),size=Count))+
  geom_point()+
  labs(x="GeneRatio",y="",size="Genecounts",title = "KEGG Enrichment")+
  scale_color_gradient(low="blue",high ="red")+
  theme_bw()
dev.off()
