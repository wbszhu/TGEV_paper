for id in WT PI; do
cf=${id}.balanceNoMTY.mcool
res=100
gd=susScr11
fa=/public/home/jingxu/01.ref/Sscrofa101/Sus_scrofa.Sscrofa11.101.dna.toplevel.fa
csz=/public/home/jingxu/01.ref/Sscrofa101/pig11.1_from_star_chrom.sizes_NoMTY

echo "____binnify"
cooltools genome binnify $csz ${res}000 > ${gd}_${res}kb.bed
echo "____gc"
cooltools genome gc ${gd}_${res}kb.bed $fa > ${gd}_${res}kbGC.bed
echo "____genecov"
cooltools genome genecov ${gd}_${res}kb.bed ${gd} > ${gd}_${res}kbgenecov.bed
echo "____eigs-cis"
cooltools eigs-cis --bigwig -o ${id}_${res}kb_cis_eigs ${cf}::resolutions/${res}000 --phasing-track ${gd}_${res}kbGC.bed::GC
echo "____expected-cis"
cooltools expected-cis ${cf}::resolutions/${res}000 -o ${id}_${res}kb.expected_cis_eig.tsv  -p 20
echo "____insulation"
cooltools insulation -o ${id}_${res}kb.IS.tsv ${cf}::resolutions/${res}000 ${res}000
echo "____saddle plot"
cooltools saddle  -o ${id}_${res}kb.saddle.txt \
 ${cf}::resolutions/${res}000  \
 ${id}_${res}kb_cis_eigs.cis.vecs.tsv::E1 \
 ${id}_${res}kb.expected_cis_eig.tsv \
 --strength \
 --fig pdf \
 -o ${id}_${res}kb_saddle.np \
 --qrange 0.02 0.98

done