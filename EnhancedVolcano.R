library("EnhancedVolcano")
res <- read.csv("F:\\01.data\\guanzhuang\\test.csv", sep="\t")
pdf("F:\\01.data\\guanzhuang\\VOPL.pdf",width=10, height=10)
EnhancedVolcano(res,
                lab = as.character(res$X),
                x = 'log2FoldChange',
                y = 'pvalue',
                selectLab = c('CCN1', 'FLRT3', 'DUSP5', 'MYC',
                              'CITED2', 'HOXB6', 'PCK1', 'SCD', 'IL22RA1', 'CYP1A1'),
                xlab = bquote(~Log[2]~ 'fold change'),
                pCutoff = 10e-14,
                FCcutoff = 2.0,
                pointSize = 4.0,
                labSize = 6.0,
                labCol = 'black',
                labFace = 'bold',
                boxedLabels = TRUE,
                colAlpha = 4/5,
                legendPosition = 'right',
                legendLabSize = 14,
                legendIconSize = 4.0,
                drawConnectors = TRUE,
                widthConnectors = 1.0,
                colConnectors = 'black')               

dev.off()
