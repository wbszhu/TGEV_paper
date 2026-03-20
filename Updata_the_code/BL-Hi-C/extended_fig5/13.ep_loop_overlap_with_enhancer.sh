for i in wt pi share_wt share_pi; do
awk '$7=="enhancer"{print $1,$2,$3} $8=="enhancer"{print $4,$5,$6}' ${i}_ep_loop.txt | sed 's/ /\t/g' | sort -k1,1V -k2,2n | uniq > ${i}_enhancer.bed
done

wtcres=~/03.jingxu/zuozhong_backup/TGEV/03.cuttag/101TGEV/05.pro_enh/02.enhancer/wt/enhancer.bed
picres=~/03.jingxu/zuozhong_backup/TGEV/03.cuttag/101TGEV/05.pro_enh/02.enhancer/pi/enhancer.bed

bedtools intersect -a ${wtcres} -b share_wt_enhancer.bed -wa -u | sort -k1,1V -k2,2n | uniq > share_wt_enhancer_element.txt
bedtools intersect -a ${wtcres} -b wt_enhancer.bed -wa -u | sort -k1,1V -k2,2n | uniq > wt_enhancer_element.txt
bedtools intersect -a ${picres} -b share_pi_enhancer.bed -wa -u | sort -k1,1V -k2,2n | uniq > share_pi_enhancer_element.txt
bedtools intersect -a ${picres} -b pi_enhancer.bed -wa -u | sort -k1,1V -k2,2n | uniq > pi_enhancer_element.txt