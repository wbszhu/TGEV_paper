software=/public/home/jingxu/00.software
fileA=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/PI_change_tad.bed
fileB=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/WT_change_tad.bed
#计算pi组90%位于wt组，而wt组没有90%位于pi组
${software}/bedtools intersect -a ${fileA} \
                               -b ${fileB} \
                               -F 0.9 \
                               -wa -wb > tmp1.bed
#取出pi组前三列的重复行
cut -f 1,2,3 tmp1.bed | uniq -d > tmp2.bed
#取pi组重叠的信息和所有组别的交集，就可以获得pi组和其wt组的子集了
${software}/bedtools intersect -a tmp1.bed -b tmp2.bed > fusion_tad.bed
#删除所有tmp文件
rm tmp*.bed

