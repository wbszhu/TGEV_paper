res=100kb
# all A / B
for i in PI_A PI_B WT_A WT_B
do
bedtools intersect -a gene.bed  -b ${i}.bed -wa -wb |awk '{print $5}' |sort -u > ${i}_gene
cat ${i}_gene|while read line ;do grep $line ../../rna-seq/00.diff/all_variable_tpm.txt  >> ${i}_gene_tpm.csv;done
done

cat  PI_A_gene_tpm.csv|sort -u >  PI_A_gene_tpm.csv1
cat  PI_B_gene_tpm.csv|sort -u >  PI_B_gene_tpm.csv1
comm -12  PI_A_gene_tpm.csv1 PI_B_gene_tpm.csv1 |awk '{print $1}'|sort -u > commID_pi

cat  PI_A_gene_tpm.csv1|grep -v -f commID_pi > PI_A_gene_tpm.csv2
cat  PI_B_gene_tpm.csv1|grep -v -f commID_pi > PI_B_gene_tpm.csv2
cat  PI_A_gene_tpm.csv2|awk -v n=PI_A '{OFS=FS="\t"}{print ($2+$3+$4)/3,n}' > PI_A_gene_tpm.txt
cat  PI_B_gene_tpm.csv2|awk -v n=PI_B '{OFS=FS="\t"}{print ($2+$3+$4)/3,n}' > PI_B_gene_tpm.txt
cat  PI_A_gene_tpm.csv|grep -f commID_pi |awk -v n1=PI -v n2=WT '{OFS=FS="\t"}{print ($2+$3+$4)/3,n1"\n"($5+$6+$7)/3,n2}' > PI_AorB_gene_tpm.txt

cat  WT_A_gene_tpm.csv|sort -u >  WT_A_gene_tpm.csv1
cat  WT_B_gene_tpm.csv|sort -u >  WT_B_gene_tpm.csv1
comm -12  WT_A_gene_tpm.csv1 WT_B_gene_tpm.csv1 |awk '{print $1}'|sort -u > commID_wt

cat  WT_A_gene_tpm.csv1|grep -v -f commID_pi > WT_A_gene_tpm.csv2
cat  WT_B_gene_tpm.csv1|grep -v -f commID_pi > WT_B_gene_tpm.csv2
cat  WT_A_gene_tpm.csv2|awk -v n=WT_A '{OFS=FS="\t"}{print ($5+$6+$7)/3,n}' > WT_A_gene_tpm.txt
cat  WT_B_gene_tpm.csv2|awk -v n=WT_B '{OFS=FS="\t"}{print ($5+$6+$7)/3,n}' > WT_B_gene_tpm.txt

cat  WT_A_gene_tpm.csv|grep -f commID_wt |awk -v n1=PI -v n2=WT '{OFS=FS="\t"}{print ($2+$3+$4)/3,n1"\n"($5+$6+$7)/3,n2}' > WT_AorB_gene_tpm.txt

rm -rf PI_A_gene_tpm.csv PI_B_gene_tpm.csv WT_A_gene_tpm.csv WT_B_gene_tpm.csv PI_A_gene_tpm.csv1 PI_B_gene_tpm.csv1 WT_A_gene_tpm.csv1 WT_B_gene_tpm.csv1

cat PI_A_gene_tpm.txt PI_B_gene_tpm.txt > PI_gene_tpm.txt
cat WT_A_gene_tpm.txt WT_B_gene_tpm.txt > WT_gene_tpm.txt
