# for no Y MT
sample_id=WT
pairs=pig-${sample_id}.pairsNoMTY.gz
genome_size=/path/to/genome/susScr11_xy/pig11.1_from_star_chrom.sizes_NoMTY
resolutions=5000
zcat ${sample_id}.pairs.gz|grep -v -e "chrMT" -e "chrY"  |gzip - > pig-${sample_id}.pairsNoMTY.gz
cooler csort -c1 2 -p1 3 -c2 4 -p2 5 -o ${sample_id}.pairsNoMTY.gz ${pairs} ${genome_size}
cooler cload pairix ${genome_size}:${resolutions} ${sample_id}.pairsNoMTY.gz  ${sample_id}NoMTY.cool
cooler zoomify -r 5000,10000,25000,40000,100000 -o ${sample_id}.balanceNoMTY.mcool --balance ${sample_id}NoMTY.cool

# for no X Y MT
sample_id=PI
pairs=pig-PI.pairsNoMTY.gz
genome_size=/path/to/genome/susScr11_xy/pig11.1_from_star_chrom.sizes_NoMTY
resolutions=5000
zcat ../pig-PI.pairs.gz  |head -n 413482267|grep -v -e "chrMT" -e "chrY"  |gzip - > pig-PI.pairsNoMTY.gz
cooler csort -c1 2 -p1 3 -c2 4 -p2 5 -o ${sample_id}.pairsNoMTY.gz ${pairs} ${genome_size}
cooler cload pairix ${genome_size}:${resolutions} ${sample_id}.pairsNoMTY.gz  ${sample_id}NoMTY.cool
cooler zoomify -r 5000,10000,25000,40000,100000 -o ${sample_id}.balanceNoMTY.mcool --balance ${sample_id}NoMTY.cool