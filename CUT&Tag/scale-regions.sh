computeMatrix scale-regions \
              -S PI-H3K27me3-Input.bigwig PI-H3K27ac-Input.bigwig PI-H3K4me3-Input.bigwig \
              -R up.bed none.bed down.bed \
              --beforeRegionStartLength 3000 \
              --regionBodyLength 5000 \
              --afterRegionStartLength 3000 \
              --skipZeros \
              -o matrix_pi.mat.gz
