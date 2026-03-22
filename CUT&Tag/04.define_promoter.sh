cat pig111.promoter.bed /path/to/cutandtag/data/05.pro_enh/01.promoter/pi_new/pi-goodk4me3.bed |awk '{print $1"\t"$2"\t"$3}'|sort -k1,1 -k2,2n > total_promoter_tmp
bedtools merge -i total_promoter_tmp >  /path/to/cutandtag/data/05.pro_enh/01.promoter/pi_new/pi-total_promoter.bed
rm -rf  total_promoter_tmp
