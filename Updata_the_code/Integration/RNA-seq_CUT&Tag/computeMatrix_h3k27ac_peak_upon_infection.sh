for i in WT PI; do
group=${i,,}
computeMatrix reference-point \
              -S /share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/03.cuttag/101TGEV/03.vis/02.Slm/01.deeptools/${i}-H3K27ac.bigwig \
              -R ${group}_enhancer_sort.bed \
              --referencePoint center \
              --beforeRegionStartLength 3000 \
              --afterRegionStartLength 3000 \
              --skipZeros \
              -o ${group}-enhancer.mat.gz
done