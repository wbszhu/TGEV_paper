cat ctl-exp.tsv|awk '{if($3>1&&$6<0.05) print $0}'|sort -n -k 3 -r|head -n 50 |awk '{print $1}' > up_id
cat ctl-exp.tsv|awk '{if($3<-1&&$6<0.05) print $0}'|sort -n -k 3 |head -n 50 |awk '{print $1}' > down_id
cat up_id down_id > all_variable_id
cat all_variable_id |while read line;do grep $line  ../star_rsem/rsem.merged.gene_tpm.tsv  ;done > all_variable_tpm.tsv
cat all_variable_tpm.tsv|awk '{OFS=FS="\t"}{print $1,$3,$4,$5,$6,$7,$8}' > TOP100_variable_tpm.txt
python  id2name1.py gene.bed TOP100_variable_tpm.txt TOP100_variable_tpm.csv
rm -rf up_id down_id all_variable_tpm.tsv TOP100_variable_tpm.tsv
