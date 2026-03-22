pro=/path/to/cutandtag/data/05.pro_enh/01.promoter/pi/total_promoter.bed
enh=/path/to/cutandtag/data/05.pro_enh/02.enhancer/pi/good27ac.bed
# software path removed - commands used directly
bedtools intersect -b ${enh} -a ${pro} -wa -u > /path/to/cutandtag/data/pi/pi-active_promoter.bed
