software=/public/home/jingxu/00.software
fileA=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/PI_change_tad.bed
fileB=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/WT_change_tad.bed
#计算pi组90%位于wt组，而wt组没有90%位于pi组
${software}/bedtools intersect -a ${fileA} \
                               -b ${fileB} \
                               -f 0.9 \
                               -wa -wb > tmp1.bed
#计算出来的结果前三列为pi组，后三列为wt组，wt是有重叠的，我们将wt组放前三列
awk -v OFS='\t' '{temp1=$1; temp2=$2; temp3=$3; $1=$4; $2=$5; $3=$6; $4=temp1; $5=temp2; $6=temp3; print}' tmp1.bed > tmp2.bed
#取出wt组中重叠的位置信息
cut -f 1,2,3 tmp2.bed | uniq -d > tmp3.bed
#取wt组重叠的信息和所有组别的交集，就可以获得wt组和其pi组的子集了
${software}/bedtools intersect -a tmp2.bed -b tmp3.bed > tmp4.bed
#将文档顺序转化回去，依然是前三列为pi组，后三列为wt组
awk -v OFS='\t' '{temp1=$1; temp2=$2; temp3=$3; $1=$4; $2=$5; $3=$6; $4=temp1; $5=temp2; $6=temp3; print}' tmp4.bed > separation_tad.bed
#删除tmp文件
rm tmp*.bed
