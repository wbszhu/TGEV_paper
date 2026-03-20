pro=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/01.promoter/pi_new/pi-total_promoter.bed
enh=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/02.enhancer/pi_new/pi-good27ac.bed
software=/public/home/jingxu/00.software/
${software}/bedtools intersect -a ${enh} -b ${pro} -v  > /public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/02.enhancer/pi_new/pi-enhancer_new.bed
