#hicPlotDistVsCounts -m WT.balance.mcool::/resolutions/100000 PI.balance.mcool::/resolutions/100000 \
# -o counts_vs_dist_100k.pdf \
# --chromosomeExclude chrMT chrY chrX \
# --labels 'WT' 'PI' \
# --maxdepth 20000000 \
# --plotsize 5 4.2


path=/path/to/project/02.results/hic/99.rep
hicPlotDistVsCounts -m \
 ${path}/pig-WT_rep1.balance.mcool::/resolutions/100000 \
 ${path}/pig-WT_rep2.balance.mcool::/resolutions/100000 \
 ${path}/pig-PI_rep1.balance.mcool::/resolutions/100000 \
 ${path}/pig-PI_rep2.balance.mcool::/resolutions/100000 \
 -o counts_vs_dist_100krep.pdf \
 --chromosomeExclude chrMT chrY chrX \
 --labels 'WT_rep1' 'WT_rep2' 'PI_rep1' 'PI_rep2' \
 --maxdepth 20000000 \
 --plotsize 5 4.2

