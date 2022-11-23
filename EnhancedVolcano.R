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
                legendPosition = 'top',
                legendLabSize = 14,
                legendIconSize = 4.0,
                drawConnectors = TRUE,
                widthConnectors = 1.0,
                colConnectors = 'black')               

dev.off()

#"	baseMean	log2FoldChange	lfcSE	stat	pvalue	padj"
#"GTSE1	63.0023921933113	-0.308150265899188	0.328892004189366	-0.936934501216285	0.348792250794352	0.513537419538704"
#"TTC38	38.9956919299181	-0.235587314100923	0.422691617127798	-0.557350334273828	0.577288091777072	0.715791326201838"
#"CDPF1	23.174387650231	0.632311628801645	0.489967722110628	1.29051690604811	0.196871245828082	0.343857563005651"
