for i in wt pi; do
awk -v var="$i" 'BEGIN{OFS=FS="\t"}{print $0, var}' ../00.${i}loops/${i}_total_p_loop.bedpe >> tmp1
awk -v var="$i" 'BEGIN{OFS=FS="\t"}{print $0, var}' ../00.${i}loops/${i}_promoter_promoter_loop.txt >> tmp2
done

bedtools pairtobed -a tmp2 -b gene_promoter_tpm.txt -type both > tmp3
bedtools pairtobed -a tmp1 -b gene_promoter_tpm.txt -type xor >> tmp3

sort -k1,1V -k2,2n -k4,4V -k5,5n tmp3 | uniq > tmp4
cut -f 9-16 tmp4 > tpm-tmp

rm tmp*