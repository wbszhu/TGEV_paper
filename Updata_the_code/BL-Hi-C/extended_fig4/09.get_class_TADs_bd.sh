for i in {1..6}
do
cut -f 1-3 part${i}.txt | awk 'BEGIN{OFS=FS="\t"}{print $1,$2+30000,$3+30000}' > tmp
bedtools intersect -b part${i}.txt -a ../../../fig3a/WT_boundary.bed -u > wt_part${i}_bd.txt
bedtools intersect -b part${i}.txt -a ../../../fig3a/PI_boundary.bed -u > pi_part${i}_bd.txt
done
rm tmp