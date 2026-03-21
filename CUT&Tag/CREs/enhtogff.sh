DATA_DIR=/path/to/cutandtag/data/101TGEV/05.pro_enh/03.superEnh

awk '{print NR,$0}' ${DATA_DIR}/wt/wt-enhancer_new.bed | sed 's/ /\t/g' | awk 'BEGIN{OFS=" "}{$5="@"}{$6=$1}{$7="."}{$8="@"}{$9="@"}{print $2,$1,$5,$3,$4,$8,$7,$9,$6}' | sed 's/@/./g' | sed 's/ /\t/g' > wt-enhancer.gff
