for i in WT PI 
do
bedtools intersect -a pig11.1.promoter.bed -b ${i}.cha_tad.bed -wa -u  > ${i}.chaLinkG.txt
done
cat WT.chaLinkG.txt PI.chaLinkG.txt|sort -u  > chaLinkG.txt
