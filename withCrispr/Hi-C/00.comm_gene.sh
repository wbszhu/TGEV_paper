path=../00.rna-seq/
for i in TGEV_p0.01fc1chaLinkG TGEV_p0.05fc1chaLinkG
do
cat ${i}.txt |awk '{if($4=="ensembl") print $5; else print $4}'|grep -v geneN |sort > ${i}_gene
done

for i in  1st 2nd 3rd 
do
cat ${path}/${i}.txt|sort > ${i}.txt
comm -12 TGEV_p0.01fc1chaLinkG_gene ${i}.txt > ${i}_TGEV_p0.01fc1.com
done

for i in  1st 2nd 3rd
do
comm -12 TGEV_p0.05fc1chaLinkG_gene ${i}.txt > ${i}_TGEV_p0.05fc1.com
done
