pro=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/01.promoter/pi/total_promoter.bed
enh=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/02.enhancer/pi/good27ac.bed
software=/public/home/jingxu/00.software/
${software}/bedtools intersect -b ${enh} -a ${pro} -wa -u > ./pi/pi-active_promoter.bed
