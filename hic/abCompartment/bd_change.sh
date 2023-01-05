rep=rep1

cat ACE2-SARS-CoV2_${rep}.cha_tad.bed Mock_${rep}.cha_tad.bed|awk '{OFS=FS="\t"}{print $1,$2-20000,$2+20000"\n"$1,$3-20000,$3+20000}'|awk '{OFS=FS="\t"}{if($2<0) {print $1,0,$3} else {print $1,$2,$3}}' |sort -u > ${rep}_cha_bd.bed

python bd_trueChange.py  ${rep}_cha_bd.bed ${rep}_cha_Tbd.bed ../is/Mock_${rep}_is.tsv  ../is/ACE2-SARS-CoV2_${rep}_is.tsv

cat ${rep}_cha_Tbd.bed|grep -v "chrom" > ${rep}_bd_change.bed
rm -rf ${rep}_cha_Tbd.bed
bedtools intersect -a Mock_${rep}.cha_tad.bed -b ${rep}_bd_change.bed -wa -u > Mock_${rep}.Tcha_tad.bed
bedtools intersect -a ACE2-SARS-CoV2_${rep}.cha_tad.bed -b ${rep}_bd_change.bed -wa -u > ACE2-SARS-CoV2_${rep}.Tcha_tad.bed

for i in ACE2-SARS-CoV2 Mock
do
bedtools intersect -a ~/22.genome/GRCh37/hg19.promoter.bed -b ${i}_${rep}.Tcha_tad.bed -wa -u  > ${i}_${rep}.chaLinkG.txt
done
cat ACE2-SARS-CoV2_${rep}.chaLinkG.txt Mock_${rep}.chaLinkG.txt|sort -u  > chaLinkG.txt
