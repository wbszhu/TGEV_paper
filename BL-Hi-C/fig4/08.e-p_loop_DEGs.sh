for i in wt_specific pi_specific merge; do
bedtools intersect -a ${i}_p_anchor.bed -b degs_promoter.txt -wa -wb > ${i}_p_anchor_degs.txt
done