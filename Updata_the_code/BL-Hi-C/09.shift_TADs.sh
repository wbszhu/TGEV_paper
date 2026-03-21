software=/public/home/jingxu/00.software
change_wt=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/WT_change_tad.bed
change_pi=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/PI_change_tad.bed
fusion=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/fusion_tad.bed
separation=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/separation_tad.bed
#wt组的shift
cut -f 4,5,6 ${fusion} > tmp1.bed
cut -f 4,5,6 ${separation} | uniq > tmp2.bed
cat tmp1.bed tmp2.bed | sort -k1,1V -k2,2n | uniq > tmp3.bed
${software}/bedtools intersect -a ${change_wt} \
                               -b tmp3.bed \
                               -v > wt_shift_tad.bed
#pi组的shift
cut -f 1,2,3 ${fusion} | uniq > tmp4.bed
cut -f 1,2,3 ${separation} > tmp5.bed
cat tmp4.bed tmp5.bed | sort -k1,1V -k2,2n | uniq > tmp6.bed
${software}/bedtools intersect -a ${change_pi} \
                               -b tmp6.bed \
                               -v > pi_shift_tad.bed

#去除所有tmp文件
rm tmp*.bed

