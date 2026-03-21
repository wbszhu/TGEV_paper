DATA_DIR=/path/to/cutandtag/data/101TGEV
PROMOTER_DIR=${DATA_DIR}/05.pro_enh/01.promoter/pi_new

cat pig111.promoter.bed ${PROMOTER_DIR}/pi-goodk4me3.bed |awk '{print $1"\t"$2"\t"$3}'|sort -k1,1 -k2,2n > total_promoter_tmp
bedtools merge -i total_promoter_tmp > ${PROMOTER_DIR}/pi-total_promoter.bed
rm -rf  total_promoter_tmp
