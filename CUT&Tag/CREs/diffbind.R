#载入需要的包
library(DiffBind)
library(DESeq2)
#读入csv文件，转换为DBA对象
samples <- read.csv("/public/home/jingxu/03.chip-seq/101TGEV/06.diff_peak/H3K27ac/H3K27ac.csv")
DBA_object <- dba(sampleSheet = samples)
DBA_object
#绘制热图
pdf("/public/home/jingxu/03.chip-seq/101TGEV/06.diff_peak/H3K27ac/01.pheatmap.pdf")
plot(DBA_object)
dev.off()
#根据bam文件reads数进行校正，耗时长
DBA_object <- dba.count(DBA_object,bUseSummarizeOverlaps = TRUE)
DBA_object
#绘制新的相关性热图
pdf("/public/home/jingxu/03.chip-seq/101TGEV/06.diff_peak/H3K27ac/02.pheatmap.pdf")
plot(DBA_object)
dev.off()
#绘制PCA图
pdf("/public/home/jingxu/03.chip-seq/101TGEV/06.diff_peak/H3K27ac/03.PCA.pdf")
dba.plotPCA(DBA_object, attributes=DBA_CONDITION,label=DBA_ID)
dev.off()
#构建design和contrasta模型
DBA_object <- dba.contrast(DBA_object,categories=DBA_CONDITION,minMember=2)
#差异分析
DBA_object <- dba.analyze(DBA_object,method=DBA_DESEQ2)
#结果汇总
dba.show(DBA_object,bContrast=T)
#提取结果
comp1.deseq <- dba.report(DBA_object, method=DBA_DESEQ2, contrast = 1, th=1)
#结果保存
out <- as.data.frame(comp1.deseq)
write.table(out, file="/public/home/jingxu/03.chip-seq/101TGEV/06.diff_peak/H3K27ac/04.diff_results.txt", sep="\t", quote=F, col.names = NA)
#显著结果保存
deseq.bed <- out[ which(out$FDR < 0.05), 
                  c("seqnames", "start", "end", "strand", "Fold")]
write.table(deseq.bed, file="/public/home/jingxu/03.chip-seq/101TGEV/06.diff_peak/H3K27ac/05.fdr0.05.bed", sep="\t", quote=F, row.names=F, col.names=F)
