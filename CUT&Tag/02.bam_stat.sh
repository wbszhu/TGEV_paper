#!/bin/bash

# 指定BAM文件所在的目录
bam_dir=$1

# 检查目录是否存在
if [ ! -d "$bam_dir" ]; then
    echo "目录不存在！"
    exit 1
fi

# 进入BAM文件所在的目录
cd "$bam_dir"

# 循环处理目录下的每个BAM文件
for bam_file in *.bam; do
    # 批量处理
    samtools stats "$bam_file" > "${bam_file%.*}.stats.txt"
done
