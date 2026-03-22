for i in WT PI; do
group=${i,,}
computeMatrix reference-point \
              -R ${group}_enhancer_sort.bed \
              --referencePoint center \
              --beforeRegionStartLength 3000 \
              --afterRegionStartLength 3000 \
              --skipZeros \
              -o ${group}-enhancer.mat.gz
done