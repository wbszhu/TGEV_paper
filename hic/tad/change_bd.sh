#cat WT.cha_tad.bed PI.cha_tad.bed|awk '{OFS=FS="\t"}{print $1,$2-20000,$2+20000"\n"$1,$3-20000,$3+20000}'|awk '{OFS=FS="\t"}{if($2<0) {print $1,0,$3} else {print $1,$2,$3}}' > cha_bd.bed
cat bd_change.bed|grep -v "chrom" > bd_change.bed1
mv bd_change.bed1 bd_change.bed
bedtools intersect -a WT.cha_tad.bed -b bd_change.bed -wa -u > WT.Tcha_tad.bed
bedtools intersect -a PI.cha_tad.bed -b bd_change.bed -wa -u > PI.Tcha_tad.bed
for i in WT PI 
do
bedtools intersect -a pig11.1.promoter.bed -b ${i}.Tcha_tad.bed -wa -u  > ${i}.chaLinkG.txt
done
cat WT.chaLinkG.txt PI.chaLinkG.txt|sort -u  > chaLinkG.txt
