path=~/08.TGEV/02.results/hic/99.rep
cool1=${path}/pig-PI_rep1.balance.mcool::/resolutions/40000
cool2=${path}/pig-WT_rep2.balance.mcool::/resolutions/40000
hicreppy scc -m 2000000 $cool1 $cool2
