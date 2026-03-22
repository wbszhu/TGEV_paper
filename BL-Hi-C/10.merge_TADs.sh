#fusion tads
#Find the intersection of large TADs and small TADs
bedtools intersect -a pi_fusion_tad.bed -b wt_fusion_tad.bed -wa -wb > tmp1
#Find the minimum start position of overlapping TAD pairs
bedtools groupby -i tmp1 -g 1,2,3 -c 5 -o min > tmp2
#Find the maximum end position of overlapping TAD pairs
bedtools groupby -i tmp1 -g 1,2,3 -c 6 -o max > tmp3
#Compare and merge TAD pairs
paste tmp2 tmp3 | cut -f 1,2,3,4,8 | awk -v OFS="\t" '{if ($4 < $2) $2 = $4; print}' - | awk -v OFS="\t" '{if ($5 > $3) $3 = $5; print}' - | cut -f 1,2,3 > fusion_merge_tads.bed

#separation tads
bedtools intersect -a wt_separation_tad.bed -b pi_separation_tad.bed -wa -wb > tmp1
bedtools groupby -i tmp1 -g 1,2,3 -c 5 -o min > tmp2
bedtools groupby -i tmp1 -g 1,2,3 -c 6 -o max > tmp3
paste tmp2 tmp3 | cut -f 1,2,3,4,8 | awk -v OFS="\t" '{if ($4 < $2) $2 = $4; print}' - | awk -v OFS="\t" '{if ($5 > $3) $3 = $5; print}' - | cut -f 1,2,3 > separation_merge_tads.bed

#shift tads
bedtools intersect -a wt_shift_tad.bed -b pi_shift_tad.bed -wa -wb > tmp1
awk -v OFS="\t" '{if ($5 < $2) $2 = $5; print}' tmp1 | awk -v OFS="\t" '{if ($6 > $3) $3 = $6; print}' - | sort -k1,1V -k2,2n | uniq | cut -f 1,2,3 > shift_merge_tads.bed

#stable tads
awk -v OFS="\t" '{if ($5 < $2) $2 = $5; print}' unchange_tad.bed | awk -v OFS="\t" '{if ($6 > $3) $3 = $6; print}' - | uniq | cut -f 1,2,3 > stable_merge_tads.bed
