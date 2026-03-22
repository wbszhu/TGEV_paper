for sample_id in PI_rep2 WT_rep1 WT_rep2
do
genome_size=/path/to/reference/pig11.1_from_star_chrom.sizes_NoMTY
resolutions=5000
zcat pig-${sample_id}.sorted.pairs.gz |grep -v -e "chrMT" -e "chrY"  | gzip - > pig-${sample_id}.pairsNoMTY.gz
cooler csort -c1 2 -p1 3 -c2 4 -p2 5 -o ${sample_id}.sorted.pairsNoMTY.gz pig-${sample_id}.pairsNoMTY.gz ${genome_size}
cooler cload pairix ${genome_size}:${resolutions} ${sample_id}.sorted.pairsNoMTY.gz ${sample_id}NoMTY.cool
cooler zoomify -r 5000,10000,25000,40000,100000 -o ${sample_id}.balanceNoMTY.mcool --balance ${sample_id}NoMTY.cool
done