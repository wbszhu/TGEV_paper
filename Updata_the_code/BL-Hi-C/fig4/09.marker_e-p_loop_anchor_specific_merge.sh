for i in wt_specific pi_specific merge; do
cut -f 1-3 ../${i}_p_anchor_degs.txt | sort -k1,1V -k2,2n | uniq | awk -v var="$i" 'BEGIN{OFS=FS="\t"}{print $0, var}' >> tmp1
done
sort -k1,1V -k2,2n tmp1 | uniq > total_p_anchor.txt
rm tmp1
