for i in wt pi; do
awk 'BEGIN{OFS=FS="\t"}{ 
    if ($7 == "promoter") 
        print $1, $2, $3; 
    else if ($8 == "promoter") 
        print $4, $5, $6; 
}' ../${i}_loop_withccres.txt | sort -k1,1V -k2,2n | uniq > ${i}_promoter.txt
done

bedtools intersect -a wt_promoter.txt -b pi_promoter.txt -wa -u> merge_p_anchor.bed
bedtools intersect -a wt_promoter.txt -b pi_promoter.txt -v > wt_specific_p_anchor.bed
bedtools intersect -a pi_promoter.txt -b wt_promoter.txt -v > pi_specific_p_anchor.bed