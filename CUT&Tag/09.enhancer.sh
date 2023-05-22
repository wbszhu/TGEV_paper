#!/bin/bash

# 定义变量
bed_file=$1
good_k27ac_bed=$2

# 取差集得到enhancer.bed
bedtools intersect -a "$good_k27ac_bed" -b "$bed_file" -wa -v  > enhancer.bed
