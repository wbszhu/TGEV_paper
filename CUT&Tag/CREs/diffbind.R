# Load required packages
library(DiffBind)
library(DESeq2)
# Read csv file and convert to DBA object
samples <- read.csv("./H3K27ac.csv")
DBA_object <- dba(sampleSheet = samples)
DBA_object
# Plot heatmap
pdf("./01.pheatmap.pdf")
plot(DBA_object)
dev.off()
# Normalize by read counts in bam files (time-consuming)
DBA_object <- dba.count(DBA_object,bUseSummarizeOverlaps = TRUE)
DBA_object
# Plot new correlation heatmap
pdf("./02.pheatmap.pdf")
plot(DBA_object)
dev.off()
# Plot PCA
pdf("./03.PCA.pdf")
dba.plotPCA(DBA_object, attributes=DBA_CONDITION,label=DBA_ID)
dev.off()
# Build design and contrast model
DBA_object <- dba.contrast(DBA_object,categories=DBA_CONDITION,minMember=2)
# Differential analysis
DBA_object <- dba.analyze(DBA_object,method=DBA_DESEQ2)
# Summarize results
dba.show(DBA_object,bContrast=T)
# Extract results
comp1.deseq <- dba.report(DBA_object, method=DBA_DESEQ2, contrast = 1, th=1)
# Save results
out <- as.data.frame(comp1.deseq)
write.table(out, file="./04.diff_results.txt", sep="\t", quote=F, col.names = NA)
# Save significant results
deseq.bed <- out[ which(out$FDR < 0.05),
                  c("seqnames", "start", "end", "strand", "Fold")]
write.table(deseq.bed, file="./05.fdr0.05.bed", sep="\t", quote=F, row.names=F, col.names=F)
