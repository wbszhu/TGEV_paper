# Read files for gene names and IDs (those that cannot be converted to names)
name <- read.table("name_merged",header = F,sep='\t')
id <- read.table("id_merged",header = F,sep='\t')
# Read the file with one-to-one mapping between IDs and names
id_name <- read.table("id_name.txt",header = F,sep = '\t')
colnames(name) <- 'V2'
# Merge name file with ID-name mapping file by name column to get corresponding IDs
name_to_id <- merge(name,id_name,by='V2')
id2 <- data.frame(name_to_id$V1)
colnames(id2) <- 'V1'
# Combine IDs converted from names with the original ID file
id_all <- rbind(id,id2)
# Read differentially expressed gene list
des <- read.table('deseq2_all.txt',header = T,sep = '\t')
up <- des[des$sig == 'up',]
down <- des[des$sig == 'down',]
none <- des[des$sig == 'none',]
up$V1 <- row.names(up)
down$V1 <- row.names(down)
none$V1 <- row.names(none)
# Intersect up-regulated, down-regulated, and non-differential genes with the target gene list respectively
tar_up <- merge(up,id_all,by='V1')
tar_down <- merge(down,id_all,by='V1')
tar_none <- merge(none,id_all,by="V1")
# Calculate the number of up-regulated, down-regulated, and non-differential genes and the total
num_up <- nrow(tar_up)
num_down <- nrow(tar_down)
num_none <- nrow(tar_none)
num_total <- num_up + num_down + num_none
# Convert to percentages
data <- c(num_none/num_total,num_up/num_total,num_down/num_total)
library(scales)
data <- percent(data, accuracy = 0.01)
data <- data.frame(data)
row.names(data) <- c("none","up","down")
colnames(data) <- "Percent"
data$gene <- row.names(data)
library(ggplot2)
pdf("sunlimeng_barplot.pdf",width = 3,height=3)
ggplot(data,mapping = aes(x=gene,y=Percent))+
  geom_bar(stat = "identity",fill=c("#15365f","#75a2b9","#bdd9e7"))+
  geom_text(aes(label=Percent),vjust=-0.5,hjust=0.5)+
  theme(axis.line = element_line(colour = "black"),panel.background = element_blank())
dev.off() 
