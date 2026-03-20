#loading package
library(org.Hs.eg.db)
library(ggplot2)
library(clusterProfiler)
gene_up <- read.table("deseq2_up_fc1_padj0.05.txt",header=T,sep="\t")
#conversion gene id and name
gene_up$ensembl_id <- row.names(gene_up)
trans <- read.table("id_name.txt",header = F,sep = "\t")
colnames(trans) <- c("ensembl_id","gene_name")
merge_all <- merge(gene_up,trans,by="ensembl_id")
write.table(merge_all, "down_SYMBOL.csv", sep = ",", row.names = F)
#MF
MF <- enrichGO(gene = merge_all$gene_name,  
               keyType = "SYMBOL",  
               OrgDb=org.Hs.eg.db,  
               ont = "MF",   
               pvalueCutoff = 1,  
               pAdjustMethod = "fdr",  
               minGSSize = 1,   
               maxGSSize = 500,  
               readable = TRUE,   
               qvalueCutoff = 1)  

MF_df <- MF@result  
MF_df <- subset(MF_df, MF_df$pvalue<0.05)     
MF_df$type <- "MF"    
MF_df <- MF_df[,c(10,1:9)]      
#BP
BP <- enrichGO(gene = merge_all$gene_name,  
               keyType = "SYMBOL",  
               OrgDb=org.Hs.eg.db,  
               ont = "BP",   
               pvalueCutoff = 1,  
               pAdjustMethod = "fdr",  
               minGSSize = 1,   
               maxGSSize = 500,  
               readable = TRUE,   
               qvalueCutoff = 1)  

BP_df <- BP@result
BP_df <- subset(BP_df, BP_df$pvalue<0.05)
BP_df$type <- "BP"
BP_df <- BP_df[,c(10,1:9)]
#CC
CC <- enrichGO(gene = merge_all$gene_name,  
               keyType = "SYMBOL",  
               OrgDb=org.Hs.eg.db,  
               ont = "CC",   
               pvalueCutoff = 1,  
               pAdjustMethod = "fdr",  
               minGSSize = 1,   
               maxGSSize = 500,  
               readable = TRUE,   
               qvalueCutoff = 1) 

CC_df <- CC@result
CC_df <- subset(CC_df, CC_df$pvalue<0.05)
CC_df$type <- "CC"
CC_df <- CC_df[,c(10,1:9)]
#merge table
all_tab <- rbind(MF_df,BP_df,CC_df)
write.table(all_tab, "GO_Mock_VS_TGEV_up_human_pvalue0.05.csv", sep = ",", row.names = F)
#show top10
MF_10 <- MF_df[1:10,]
MF_10 <- MF_10[order(MF_10$Count,decreasing = FALSE),]
BP_10 <- BP_df[1:10,]
BP_10 <- BP_10[order(BP_10$Count,decreasing = FALSE),]
CC_10 <- CC_df[1:10,]
CC_10 <- CC_10[order(CC_10$Count,decreasing = FALSE),]
all_10 <- rbind(MF_10, BP_10, CC_10)
#set description as factor
all_10$Description <- as.character(all_10$Description)
all_10$Description <- factor(all_10$Description,levels = c(all_10$Description)) #再强制加入因子
#plot
pdf("GO_up(human).pdf",width = 9,height = 5)
ggplot(all_10,aes(x=Description,y=Count,fill=type))+
  geom_bar(stat="identity")+
  labs(x="Description",y="Num of Genes",fill="Category",title = "NS's Most Enrich GO")+
  scale_fill_manual(values=c("#e64b35","#4dbbd5","#00a087"))+
  coord_flip()+
  theme(panel.grid = element_blank(),
        panel.background = element_rect(color = 'black',fill = 'transparent'))
dev.off()
