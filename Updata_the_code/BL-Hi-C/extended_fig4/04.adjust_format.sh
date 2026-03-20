#去除表达量过低基因
awk '($7 >= 3 || $8 >= 3 || $9 >= 3 || $10 >= 3 || $11 >= 3 || $12 >= 3)' tmp > tmp1
#计算wt pi fpkm平均值
awk '{ avg = ($7 + $8 + $9)/3; print $0, avg }' tmp1 > tmp2
awk '{ avg = ($10 + $11 + $12)/3; print $0, avg }' tmp2 > tmp3
sed -i 's/ /\t/g' tmp3
#整理成和histone一样的格式
cut -f 1 tmp3  > tmp4
paste tmp3 tmp4 > tmp5
cut -f 2,3,4,13,14,15 tmp5 > tads_tpm.txt

rm tmp*