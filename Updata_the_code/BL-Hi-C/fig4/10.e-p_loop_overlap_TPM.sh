bedtools intersect -a total_p_anchor.txt -b degs_promoter_tpm.txt -wa -wb | cut -f 4-13 > tmp1

awk 'BEGIN{OFS=FS="\t"}{print "All", $0}' degs_promoter_tpm.txt > tmp2

cat tmp1 tmp2 | sort -k2,2V -k3,3n | uniq > total_p_anchor_tpm.txt

rm tmp1 tmp2