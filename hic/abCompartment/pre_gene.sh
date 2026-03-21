cat ../../rna-seq/00.diff/gene.bed |awk '{OFS=FS="\t"}{print $3,$2,$1}'|grep -v Chromosome > gene.bed
sed -i 's/:/\t/' gene.bed
sed -i 's/-/\t/' gene.bed

