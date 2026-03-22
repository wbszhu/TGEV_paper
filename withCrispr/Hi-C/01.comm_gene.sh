path=/path/to/rnaseq/data/00.rna-seq/
for i in TGEV_p0.01fc1chaLinkG TGEV_p0.05fc1chaLinkG
do
cat ${i}.txt |awk '{print $5}'|grep -v gene_id |sort > ${i}_geneid
done

for i in  0.01 0.05
do
cat ${path}/focus.txt |sort -n > focus.txt
comm -12 TGEV_p${i}fc1chaLinkG_geneid focus.txt > focus_TGEV_p${i}fc1.com
done

