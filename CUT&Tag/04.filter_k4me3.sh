#!/bin/bash

# 通过参数传递设置命令参数
bed_file=$1
bam_files=$2
labels=$3
out_raw_counts=$4
output_file=$5

# 执行命令
multiBamSummary BED-file \
 --BED "$bed_file" \
 --bamfiles $bam_files \
 -p 20 \
 --labels $labels \
 --outRawCounts "$out_raw_counts" \
 -o "$output_file"

#参数解释：“$bed_file"表示参数，$bam_files表示参数列表
#bash script.sh h3k4me3.consensus_peaks.bed \
#"P13_S1_L002_R1_001_val_1.srt.nodup.bam P14_S63_L002_R1_001_val_1.srt.nodup.bam P19_S65_L002_R1_001_val_1.srt.nodup.bam P20_S66_L002_R1_001_val_1.srt.nodup.bam" \
#"k4me3_1 k4me3_2 input_1 input_2" \
#k4me3_peakReadcount.txt \
#k4me3_results.npz

