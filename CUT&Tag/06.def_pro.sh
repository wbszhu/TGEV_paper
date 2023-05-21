#!/bin/bash

# 定义变量
bed_file=$1
good_k4me3_bed=$2

# 生成临时文件
cat "$bed_file" "$good_k4me3_bed" | awk '{print $1"\t"$2"\t"$3}' | sort -k1,1 -k2,2n > total_promoter_tmp

# 合并重叠区域
bedtools merge -i total_promoter_tmp > total_promoter.bed

# 删除临时文件
rm -rf total_promoter_tmp

