cut -f 5 WT_rep1_100kb_cis_eigs.cis.vecs.tsv > tmp1
cut -f 5 WT_rep2_100kb_cis_eigs.cis.vecs.tsv > tmp2
cut -f 5 PI_rep1_100kb_cis_eigs.cis.vecs.tsv > tmp3
cut -f 5 PI_rep2_100kb_cis_eigs.cis.vecs.tsv > tmp4
paste tmp1 tmp2 tmp3 tmp4 | sed '1d' > total_rep_pc1.txt
rm tmp*
