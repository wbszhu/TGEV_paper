#!/bin/bash

# 通过参数传递设置命令参数
bam_files=$1
labels=$2

# 执行命令
multiBamSummary bins --bamfiles $bam_files -p 20 --labels $labels -o cor_results.npz

#绘图
plotCorrelation -in cor_results.npz --whatToPlot heatmap --corMethod pearson -o cor_heatmap.png --skipZeros --colorMap RdYlBu --plotNumbers --plotTitle "Correlation"


