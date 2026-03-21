DATA_DIR=/path/to/cutandtag/data/101TGEV

pro=${DATA_DIR}/05.pro_enh/01.promoter/pi_new/pi-total_promoter.bed
enh=${DATA_DIR}/05.pro_enh/02.enhancer/pi_new/pi-good27ac.bed

bedtools intersect -a ${enh} -b ${pro} -v > ${DATA_DIR}/05.pro_enh/02.enhancer/pi_new/pi-enhancer_new.bed
