for i in 1 2 
do
bedtools intersect -a Mock_rep${i}.tad.bed  -b ACE2-SARS-CoV2_rep${i}.tad.bed -f 0.9 -r -wa -wb |awk '{OFS=FS="\t"}{print $1,$2,$3}' > Mock_rep${i}.sta_tad.bed
bedtools intersect -a Mock_rep${i}.tad.bed  -b ACE2-SARS-CoV2_rep${i}.tad.bed -f 0.9 -r -wa -wb |awk '{OFS=FS="\t"}{print $4,$5,$6}' > ACE2-SARS-CoV2_rep${i}.sta_tad.bed

for j in Mock ACE2-SARS-CoV2
do
bedtools intersect -a ${j}_rep${i}.tad.bed  -b ACE2-SARS-CoV2_rep${i}.sta_tad.bed -v -wa |awk '{OFS=FS="\t"}{print $1,$2,$3}' > ${j}_rep${i}.cha_tad.bed
done
done
