#for i in WT PI
#do
#for res in  100
#do
#cat ${i}_${res}kb_cis_eigs.cis.vecs.tsv |awk '{if($5>0) print $0}' > ${i}_${res}kb_A.bed
#cat ${i}_${res}kb_cis_eigs.cis.vecs.tsv |awk '{if($5<0) print $0}' > ${i}_${res}kb_B.bed
#done
#paste WT_${res}kb_cis_eigs.cis.vecs.tsv PI_${res}kb_cis_eigs.cis.vecs.tsv |awk '{if($5>0&&$12>0) print $0}' > ${res}kb_stableA.bed
#paste WT_${res}kb_cis_eigs.cis.vecs.tsv PI_${res}kb_cis_eigs.cis.vecs.tsv |awk '{if($5<0&&$12<0) print $0}' > ${res}kb_stableB.bed
#paste WT_${res}kb_cis_eigs.cis.vecs.tsv PI_${res}kb_cis_eigs.cis.vecs.tsv |awk '{if($5>0&&$12<0) print $0}' > ${res}kb_A-B.bed
#paste WT_${res}kb_cis_eigs.cis.vecs.tsv PI_${res}kb_cis_eigs.cis.vecs.tsv |awk '{if($5<0&&$12>0) print $0}' > ${res}kb_B-A.bed
#done

for res in  100
do
paste WT_100kb_cis_eigs.cis.vecs.tsv PI_100kb_cis_eigs.cis.vecs.tsv |awk '{if($5>0&&$12>0&&($12/($5+0.0000001))<=0.5) print $0}' > ${res}kb_weakerA.bed
paste WT_100kb_cis_eigs.cis.vecs.tsv PI_100kb_cis_eigs.cis.vecs.tsv |awk '{if($5>0&&$12>0&&($12/($5+0.0000001))>=2) print $0}' > ${res}kb_strongerA.bed
paste WT_100kb_cis_eigs.cis.vecs.tsv PI_100kb_cis_eigs.cis.vecs.tsv |awk '{if($5>0&&$12>0&&($12/($5+0.0000001))<2&&($12/($5+0.0000001))>0.5) print $0}' > ${res}kb_truestableA.bed

paste WT_100kb_cis_eigs.cis.vecs.tsv PI_100kb_cis_eigs.cis.vecs.tsv |awk '{if($5<0&&$12<0&&($12/($5+0.0000001))<=0.5) print $0}' > ${res}kb_weakerB.bed
paste WT_100kb_cis_eigs.cis.vecs.tsv PI_100kb_cis_eigs.cis.vecs.tsv |awk '{if($5<0&&$12<0&&($12/($5+0.0000001))>=2) print $0}' > ${res}kb_strongerB.bed
paste WT_100kb_cis_eigs.cis.vecs.tsv PI_100kb_cis_eigs.cis.vecs.tsv |awk '{if($5<0&&$12<0&&($12/($5+0.0000001))<2&&($12/($5+0.0000001))>0.5) print $0}' > ${res}kb_truestableB.bed
done
