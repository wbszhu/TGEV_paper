for i in wt pi; do
sed '1d' ${i}_h3k27ac_change.txt | awk -v var=$i 'BEGIN{OFS=FS="\t"}{print $0, var}' >> enhancer_27ac.txt
done