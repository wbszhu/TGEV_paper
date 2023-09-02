cat pig111.promoter.bed /public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/01.promoter/pi_new/pi-goodk4me3.bed |awk '{print $1"\t"$2"\t"$3}'|sort -k1,1 -k2,2n > total_promoter_tmp
/public/home/jingxu/00.software/bedtools merge -i total_promoter_tmp >  /public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/01.promoter/pi_new/pi-total_promoter.bed
rm -rf  total_promoter_tmp
