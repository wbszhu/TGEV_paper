library(ggplot2)
library(clusterProfiler)
library(org.Ss.eg.db)
setwd("./")
gene_all <- read.table("DEGs.txt",header=T,sep="\t")
gene_all$ensembl_id <- row.names(gene_all)
trans <- read.table("id_name.txt",header = F,sep = "\t")
colnames(trans) <- c("ensembl_id","gene_name")
merge_all <- merge(gene_all,trans,by="ensembl_id")
#keytypes(org.Ss.eg.db)
all_entrezid <- bitr(merge_all$gene_name,fromType = "SYMBOL",
                    toType = c("SYMBOL","ENTREZID"),
                    OrgDb = org.Ss.eg.db)
#kegg
kegg <- enrichKEGG(gene = all_entrezid$ENTREZID,  #Gene list (converted IDs)
               keyType = "kegg",  #Specified gene ID type, default is ENTREZID
               organism ="ssc",  #Species-specific org package
               pvalueCutoff = 0.05,  #p-value threshold
               pAdjustMethod = "fdr",  #Multiple hypothesis testing correction method
               qvalueCutoff = 0.05)  #q-value threshold
kegg <- as.data.frame(kegg)
kegg <- subset(kegg, kegg$p.adjust<0.05)
write.table(kegg, 'kegg_all.txt', sep = '\t', quote = FALSE, row.names = FALSE)
kegg <- kegg[1:20,]
#Convert x-axis fractions to decimals
ev = function(x){eval(parse(text = x))}
kegg$GeneRatio = round(sapply(kegg$GeneRatio,ev),3)   #Convert x-axis to decimal
#Sort y-axis
kegg <- kegg[order(kegg$GeneRatio,decreasing = FALSE),]
kegg$Description <- as.character(kegg$Description)
kegg$Description <- factor(kegg$Description,levels=c(kegg$Description))
#Plot
pdf("kegg_all.pdf",width = 8,height = 5)
ggplot(kegg,aes(GeneRatio,Description,color=-log10(qvalue),size=Count))+
  geom_point()+
  labs(x="GeneRatio",y="",size="Genecounts",title = "KEGG Enrichment")+
  scale_color_gradient(low="blue",high ="red")+
  theme_bw()
dev.off()
