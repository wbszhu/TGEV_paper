cat ../star_rsem/rsem.merged.gene_counts.tsv |grep -v "gene"|awk '{OFS=FS="\t"}{print $1,int($3),int($4),int($5),int($6),int($7),int($8)}' > gene_count.txt
sed -i '1i\gene_id\tTGEV_REP1\tTGEV_REP2\tTGEV_REP3\tWT_REP1\tWT_REP2\tWT_REP3' gene_count.txt
