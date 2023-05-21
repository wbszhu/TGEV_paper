#!/bin/bash

# 通过参数传递设置命令参数
bw_files=$1
bed_files=$2
out_png=$3

#计算矩阵
computeMatrix scale-regions -S $bw_files -R $bed_files --beforeRegionStartLength 3000 --regionBodyLength 5000 --afterRegionStartLength 3000 --skipZeros -o matrix.mat.gz

#绘制热图
plotHeatmap -m matrix.mat.gz -o "$out_png" --colorMap RdYlBu --zMin 0 --zMax 100 --startLabel "" --endLabel "" --regionsLabel pro enh --yMin 0 --yMax 100 --legendLocation upper-right
