dir=/path/to/project/04.new_addanalysis/11.fig3/extended/04.tads_gene_fpkm

bedtools intersect -a ${dir}/merge_tad.txt -b ${dir}/gene_fpkm.txt -wa -wb | cut -f 1-9 | sort -k1,1V -k2,2n | uniq | grep -v "ensembl" > tads_gene.txt

awk -F'\t' '{print > $4".txt"}' tads_gene.txt
