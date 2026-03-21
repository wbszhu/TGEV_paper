# <Differential gene analysis>
# 1. Check if BiocManager package exists; install if not
#options(repos=structure(c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))) #Set Tsinghua mirror to speed up downloads

#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#if (!requireNamespace("DESeq2", quietly = TRUE))
#  BiocManager::install('DESeq2')  #Install DESeq2 via BiocManager
library(DESeq2) #Load library

setwd("./") #Set working directory; all output files will be saved here

#Input data requirements
# DESeq2 requires an input matrix composed of integers
# DESeq2 requires the matrix to be unnormalized

##2. Read in the raw read count expression matrix for all genes (rows = genes, columns = samples)

A <- read.table("./rsem.merged.gene_counts.tsv", header = T, row.names = 1)
B <- as.matrix(A) #Convert to matrix format to ensure all values are numeric

#View(B)
## 3. Experimental grouping
# The sample information matrix (colData in the code above) is a dataframe,
# where the first column is sample name and the second column is the treatment condition
# (control or treatment, etc.), i.e., condition
coldata <- read.table("sample_info.txt",header = T,row.names = 1)
coldata <- coldata[, c("condition", "type")]
#View(coldata)	#View grouping information

## 4. Create dds object; build the data format required for differential gene analysis
dds <- DESeqDataSetFromMatrix(countData = B, colData = coldata, design = ~ condition);

# countData = B, read count matrix
# colData = coldata, grouping information used for comparison between 2 groups
# design = ~ condition, formula indicating analysis by condition

## 5. Differential analysis results
dds <- DESeq(dds)	#Perform differential analysis

## 6. Extract results; compare between treated and untreated groups
res <- results(dds, contrast = c("condition", "WT", "PI"))
# results extracts a results table from the DESeq analysis, providing base mean, log2 fold change, standard error, test statistic, p-value, and adjusted p-value for each gene
sum(res$padj < 0.05, na.rm = TRUE)	#Count genes with padj < 0.05 (significantly differentially expressed)

##8. Filter upregulated and downregulated genes
filter_up <- subset(res, pvalue < 0.05 & log2FoldChange > 1) #Filter upregulated genes
filter_down <- subset(res, pvalue < 0.05 & log2FoldChange < -1) #Filter downregulated genes
filter_diff  <- subset(res, padj < 0.05)	#Filter genes with padj < 0.05 (significantly differentially expressed)

print(paste('Number of upregulated DEGs: ', nrow(filter_up)))  #Print number of upregulated genes
print(paste('Number of downregulated DEGs: ', nrow(filter_down)))  #Print number of downregulated genes

##9. Save to file
write.table(filter_diff, file = "./differential_gene.txt", sep = "\t") #log2FoldChange + pvalue + padj
write.table(filter_up, file="./filter_up_gene.txt", quote = F, sep = "\t")
write.table(filter_down, file="./filter_down_gene.txt", quote = F, sep = "\t")


#------------------------------------------------------
library(EnhancedVolcano)
#devtools::install_github('kevinblighe/EnhancedVolcano')
EnhancedVolcano(res,
                lab = rownames(res),
                x = 'log2FoldChange',
                y = 'pvalue',
                xlim = c(-20,20),
                title ='resistant versus control',
                pCutoff = 10e-17,
                FCcutoff = 1 ,
                colAlpha = 1,
                col=c(' black','blue',' green','red1'),

)

#----------------------------------------------------------

library("biomaRt")
mart <- useDataset("sscrofa_gene_ensembl", useMart("ensembl"))
my_ensembl_gene_id <- row.names(filter_diff)
head(my_ensembl_gene_id)
pig_symbols <- getBM(attributes = c('ensembl_gene_id','external_gene_name','description'),filters = 'ensembl_gene_id', values = my_ensembl_gene_id, mart = mart)
head(pig_symbols)
ensembl_gene_id <- rownames(filter_diff)
filter_diff <- cbind(ensembl_gene_id,filter_diff)
colnames(filter_diff)[1]<-c("ensembl_gene_id")
diff_name <-merge(filter_diff, pig_symbols, by="ensembl_gene_id")
diff_name
write.table(diff_name, file="./all_diff_genename.txt", quote = F, sep = "\t")
