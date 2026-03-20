cut -f 4,5,6 fusion_tad.bed | awk 'BEGIN{OFS=FS="\t"}{$4="fusion"; print}' > tmp1.bed
cut -f 4,5,6 separation_tad.bed | uniq | awk 'BEGIN{OFS=FS="\t"}{$4="separation"; print}' > tmp2.bed
awk 'BEGIN{OFS=FS="\t"}{$4="shift"; print}' wt_shift_tad.bed > tmp3.bed
awk 'BEGIN{OFS=FS="\t"}{$4="stable"; print}' WT_unchange_tad.bed > tmp4.bed
cat tmp*.bed | sort -k1,1V -k2,2n | uniq > WT_tad_marked.bed
rm tmp*bed
