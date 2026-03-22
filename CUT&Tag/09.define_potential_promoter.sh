pro=/path/to/cutandtag/data/05.pro_enh/01.promoter/pi_new/pi-total_promoter.bed
enh=/path/to/cutandtag/data/05.pro_enh/02.enhancer/pi_new/pi-good27ac.bed
# software path removed - commands used directly
bedtools intersect -b ${enh} -a ${pro} -v  > ./pi_new/pi-potential_promoter_new.bed
