for i in WT PI;
do
awk 'BEGIN{OFS=FS="\t"}{$4=$3-$2;print}' ../${i}.tad.bed | awk -v var=${i} 'BEGIN{OFS=FS="\t"}{$5=var;print}' > ${i}_tadsize.bed
done

cat WT_tadsize.bed PI_tadsize.bed > total_tadsize.bed
