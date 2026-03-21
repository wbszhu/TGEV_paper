sed '1d' h3k27ac_change.txt > tmp1
sed '1d' h3k4me3_change.txt > tmp2
sed '1d' h3k27me3_change.txt > tmp3
awk 'BEGIN{OFS=FS="\t"}{print $0, "H3K27ac"}' tmp1 > histone_change_signal.txt
awk 'BEGIN{OFS=FS="\t"}{print $0, "H3K4me3"}' tmp2 >> histone_change_signal.txt
awk 'BEGIN{OFS=FS="\t"}{print $0, "H3K27me3"}' tmp3 >> histone_change_signal.txt