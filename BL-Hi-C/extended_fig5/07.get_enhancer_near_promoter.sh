#all promoter
for i in wt pi; do
grep "promoter" /path/to/project/04.new_addanalysis/12.fig4/04.paper/${i}_element.txt | grep -v "chrY" - > ${i}_all_promoter.txt
#loop enhancer
awk 'BEGIN{OFS=FS="\t"}{ 
    if ($7 == "enhancer") 
        print $1, $2, $3; 
    else if ($8 == "enhancer") 
        print $4, $5, $6; 
}' ../${i}_loop_withccres.txt | sort -k1,1V -k2,2n | uniq > ${i}_enhancer.txt
done
#enhancer closest promoter
bedtools closest -a wt_enhancer.txt -b wt_all_promoter.txt -t first | cut -f 4-7 - | sort -k1,1V -k2,2n | uniq > wt_closest_promoter.txt
bedtools closest -a pi_enhancer.txt -b pi_all_promoter.txt -t first | cut -f 4-7 - | sort -k1,1V -k2,2n | uniq > pi_closest_promoter.txt
#how much overlap with loop promoter
#loop promoter
for i in wt pi; do
awk 'BEGIN{OFS=FS="\t"}{ 
    if ($7 == "promoter") 
        print $1, $2, $3; 
    else if ($8 == "promoter") 
        print $4, $5, $6; 
}' ../${i}_loop_withccres.txt | sort -k1,1V -k2,2n | uniq > ${i}_promoter.txt

bedtools intersect -a ${i}_promoter.txt -b ${i}_closest_promoter.txt -u > ${i}_enhancer_regulate_closest_promoter.txt
bedtools intersect -a ${i}_promoter.txt -b ${i}_closest_promoter.txt -v > ${i}_enhancer_skip_regulate_closest_promoter.txt
done
