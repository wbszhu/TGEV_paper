for i in A-B B-A
do
bedtools intersect -a gene.bed  -b ${i}.bed -wa -wb |awk '{print $5}' |sort -u > ${i}_gene
cat ${i}_gene|while read line ;do grep $line ../../rna-seq/00.diff/all_variable_tpm.txt  >> ${i}_gene_tpm.csv;done
#############cat  ${i}_gene_tpm.csv|awk '{if($3>1&&$4>1&&$5>1&&$6>1&&$7>1&&$8>1) print $0}'|awk '{OFS=FS="\t"}{print ($3+$4+$5)/3,"TGEV""\n"($6+$7+$8)/3,"WT"}' > ${i}_gene_tpm.txt
cat  ${i}_gene_tpm.csv|awk '{OFS=FS="\t"}{print ($3+$4+$5)/3,"TGEV""\n"($6+$7+$8)/3,"WT"}' > ${i}_gene_tpm.txt
done


