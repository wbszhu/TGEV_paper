#Recommended to use the pig annotation package directly
library(org.Ss.eg.db)
#Load packages required for GO analysis and plotting, and input files
library(ggplot2)
library(clusterProfiler)
setwd("./")
gene_up <- read.table("deseq2_up.txt",header=T,sep="\t")
#Convert gene ID to gene name
gene_up$ensembl_id <- row.names(gene_up)
trans <- read.table("id_name.txt",header = F,sep = "\t")
colnames(trans) <- c("ensembl_id","gene_name")
merge_all <- merge(gene_up,trans,by="ensembl_id")
#MF
MF <- enrichGO(gene = merge_all$gene_name,  #Gene list (converted IDs)
               keyType = "SYMBOL",  #Specified gene ID type, default is ENTREZID
               OrgDb=org.Ss.eg.db,  #Species-specific org package
               ont = "MF",   #CC: Cellular Component, MF: Molecular Function, BP: Biological Process
               pvalueCutoff = 0.05,  #p-value threshold
               pAdjustMethod = "fdr",  #Multiple hypothesis testing correction method
               minGSSize = 1,   #Minimum gene set size for annotation, default is 10
               maxGSSize = 500,  #Maximum gene set size for annotation, default is 500
               readable = TRUE,   #Display as gene SYMBOL for easier reading
               qvalueCutoff = 0.05)  #q-value threshold

MF_df <- MF@result  #dataframe format
MF_df <- subset(MF_df, MF_df$p.adjust<0.05)      #Significant results
MF_df$type <- "MF"     #Add a column for category label
MF_df <- MF_df[,c(10,1:9)]      #Move label to the first column
#BP
 #Species-specific org package
BP <- enrichGO(gene = merge_all$gene_name,  #Gene list (converted IDs)
               keyType = "SYMBOL",  #Specified gene ID type, default is ENTREZID
               OrgDb=org.Ss.eg.db,  #p-value threshold
               ont = "BP",   #CC: Cellular Component, MF: Molecular Function, BP: Biological Process
               pvalueCutoff = 0.05,
               pAdjustMethod = "fdr",  #Multiple hypothesis testing correction method
               minGSSize = 1,   #Minimum gene set size for annotation, default is 10
               maxGSSize = 500,  #Maximum gene set size for annotation, default is 500
               readable = TRUE,    #Display as gene SYMBOL
               qvalueCutoff = 0.05)  #p-value threshold


BP_df <- BP@result
BP_df <- subset(BP_df, BP_df$p.adjust<0.05)
BP_df$type <- "BP"
BP_df <- BP_df[,c(10,1:9)]
#CC
CC <- enrichGO(gene = merge_all$gene_name,  #Gene list (converted IDs)
               keyType = "SYMBOL",  #Specified gene ID type, default is ENTREZID
               OrgDb=org.Ss.eg.db,  #Species-specific org package
               ont = "CC",   #CC: Cellular Component, MF: Molecular Function, BP: Biological Process
               pvalueCutoff = 0.05,  #p-value threshold
               pAdjustMethod = "fdr",  #Multiple hypothesis testing correction method
               minGSSize = 1,   #Minimum gene set size for annotation, default is 10
               maxGSSize = 500,  #Maximum gene set size for annotation, default is 500
               readable = TRUE,
               qvalueCutoff = 0.05)  #p-value threshold


CC_df <- CC@result
CC_df <- subset(CC_df, CC_df$p.adjust<0.05)
CC_df$type <- "CC"
CC_df <- CC_df[,c(10,1:9)]
#Combine all tables
all_tab <- rbind(MF_df,BP_df,CC_df)
write.table(all_tab, "./GO_Mock_VS_TGEV_up(pig).csv", sep = ",", row.names = F)
#Select top 10
MF_10 <- MF_df[1:10,]
MF_10 <- MF_10[order(MF_10$Count,decreasing = FALSE),]
BP_10 <- BP_df[1:10,]
BP_10 <- BP_10[order(BP_10$Count,decreasing = FALSE),]
CC_10 <- CC_df[1:10,]
CC_10 <- CC_10[order(CC_10$Count,decreasing = FALSE),]
all_10 <- rbind(MF_10, BP_10, CC_10)
#Convert x-axis to factor to keep groups together in the plot
all_10$Description <- as.character(all_10$Description)
all_10$Description <- factor(all_10$Description,levels = c(all_10$Description)) #Force as factor
#Plot
pdf("GO_up(pig).pdf",width = 9,height = 5)
ggplot(all_10,aes(x=Description,y=Count,fill=type))+
  geom_bar(stat="identity")+
  labs(x="Description",y="Num of Genes",fill="Category",title = "Up's Most Enrich GO")+
  scale_fill_manual(values=c("#66c3a5","#fd8d62","#8da1cb"))+
  coord_flip()+
  theme(panel.grid = element_blank(),
        panel.background = element_rect(color = 'black',fill = 'transparent'))
dev.off()
