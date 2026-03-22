for i in a2b b2a stablea stableb; do
awk -v var="$i" 'BEGIN{OFS=FS="\t"}{$6=var; print}' /path/to/hic/project/figc/${i}.txt >> compartment.txt
done

sort -k1,1V -k2,2n compartment.txt | uniq > tmp1
mv tmp1 compartment.txt
bedtools intersect -a compartment.txt -b gene_tpm.txt -wa -wb | cut -f 6-17 | sort -k1,1V -k2,2V -k3,3n | uniq > tmp