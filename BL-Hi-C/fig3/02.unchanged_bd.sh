tads=/path/to/hic/data/03.TAD/tadlib/domain_caller/tad_class/tad_class
#Make bed and tads overlap
awk 'BEGIN{OFS=FS="\t"}{ $2 = $2 - 20000; $3 = $3 - 20000; print }' WT_boundary.bed > tmp1
awk 'BEGIN{OFS=FS="\t"}{ $2 = $2 - 20000; $3 = $3 - 20000; print }' PI_boundary.bed > tmp2
#Get overlap
bedtools intersect -a tmp1 -b ${tads}/WT_unchange_tad.bed -wa -wb > tmp3
bedtools intersect -a tmp2 -b ${tads}/PI_unchange_tad.bed -wa -wb > tmp4
#Restore boundaries to original positions
awk 'BEGIN{OFS=FS="\t"}{ $2 = $2 + 20000; $3 = $3 + 20000; print }' tmp3 | cut -f 1-3 | sort -k1,1V -k2,2n | uniq > wt_unchanged_tads_bd.bed
awk 'BEGIN{OFS=FS="\t"}{ $2 = $2 + 20000; $3 = $3 + 20000; print }' tmp4 | cut -f 1-3 | sort -k1,1V -k2,2n | uniq > pi_unchanged_tads_bd.bed
#TADs changed, boundaries unchanged
bedtools intersect -a PI_boundary.bed -b pi_unchanged_tads_bd.bed -v > tmp5
bedtools intersect -a WT_boundary.bed -b wt_unchanged_tads_bd.bed -v > tmp6
bedtools intersect -a tmp5 -b tmp6 -wa -wb > tmp7
#Merge
cut -f 1-3 tmp7 > tmp8
cut -f 1-3 tmp7 > tmp9
cat wt_unchanged_tads_bd.bed tmp4 | sort -k1,1V -k2,2n | uniq > unchanged_bd/wt_unchanged_bd.bed
cat pi_unchanged_tads_bd.bed tmp5 | sort -k1,1V -k2,2n | uniq > unchanged_bd/pi_unchanged_bd.bed
#
rm tmp*