for i in WT PI; do
group=${i,,}
computeMatrix reference-point \
              -S /path/to/cutandtag/data/${i}-H3K27ac.bigwig \
              -R ${group}_enhancer_sort.bed \
              --referencePoint center \
              --beforeRegionStartLength 3000 \
              --afterRegionStartLength 3000 \
              --skipZeros \
              -o /path/to/cutandtag/data/${group}-enhancer.mat.gz
done