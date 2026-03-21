res=100
gd=susScr11
fa=/share/org/YZWL/yzwl_hanxs/03.jingxu/01.ref/Sscrofa101/Sus_scrofa.Sscrofa11.101.dna.toplevel.fa
csz=pig11.1_from_star_chrom.sizes

for rep in rep1 rep2; do
for id in WT PI; do
cf=${id}_rep2.balanceNoMTY.mcool
echo "____eigs-cis"
cooltools eigs-cis --bigwig -o ${id}_${rep}_${res}kb_cis_eigs ${cf}::resolutions/${res}000 --phasing-track ${gd}_${res}kbGC.bed::GC
echo "____expected-cis"
cooltools expected-cis ${cf}::resolutions/${res}000 -o ${id}_${rep}_${res}kb.expected_cis_eig.tsv  -p 2
done
done