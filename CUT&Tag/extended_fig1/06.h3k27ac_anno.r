library(ChIPseeker)
library(GenomicFeatures)
pig <- makeTxDbFromGFF('/path/to/cutandtag/data/Sus_scrofa.Sscrofa11.1.101.chr.gff3')
wt_peak <- readPeakFile('wt_27ac_sort.bed')
pi_peak <- readPeakFile('pi_27ac_sort.bed')
peaks <- list(wt = wt_peak, pi = pi_peak)

peakAnnoList <- lapply(peaks, annotatePeak, TxDb = pig, tssRegion = c(-2500,1500), addFlankGeneInfo = TRUE, flankDistance = 5000)

write.table(peakAnnoList[1], file = 'wt_27ac.txt',sep = '\t', quote = FALSE, row.names = FALSE)
write.table(peakAnnoList[2], file = 'pi_27ac.txt',sep = '\t', quote = FALSE, row.names = FALSE)
pdf("/path/to/cutandtag/datah3k27ac_peak_anno.pdf",width = 7,height = 4)
plotAnnoBar(peakAnnoList)
dev.off()