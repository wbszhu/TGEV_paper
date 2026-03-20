res=100
path=/public/home/jingxu/05.HiTag/02.test_hic-tgev/01.cooltools
paste ${path}/WT/WT_${res}kb_cis_eigs.cis.vecs.tsv ${path}/PI/PI_${res}kb_cis_eigs.cis.vecs.tsv |awk '{OFS=FS="\t"}{print $1,$2,$3,$5,$12}' > ${res}kb_ab.txt
