# Remove genes with too low expression
awk '($7 >= 3 || $8 >= 3 || $9 >= 3 || $10 >= 3 || $11 >= 3 || $12 >= 3)' tmp > tmp1
# Calculate WT and PI FPKM averages
awk '{ avg = ($7 + $8 + $9)/3; print $0, avg }' tmp1 > tmp2
awk '{ avg = ($10 + $11 + $12)/3; print $0, avg }' tmp2 > tmp3
sed -i 's/ /\t/g' tmp3
# Reformat to match the histone data format
cut -f 1 tmp3  > tmp4
paste tmp3 tmp4 > tmp5
cut -f 2,3,4,13,14,15 tmp5 > tads_tpm.txt

rm tmp*