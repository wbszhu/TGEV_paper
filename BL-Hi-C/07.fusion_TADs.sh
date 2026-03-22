# software path removed - commands used directly
fileA=/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/PI_change_tad.bed
fileB=/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/WT_change_tad.bed
#Find PI group TADs with 90% overlap in WT group, where WT TADs do not have 90% overlap in PI group
bedtools intersect -a ${fileA} \
                               -b ${fileB} \
                               -F 0.9 \
                               -wa -wb > tmp1.bed
#Extract duplicated rows from the first 3 columns of the PI group
cut -f 1,2,3 tmp1.bed | uniq -d > tmp2.bed
#Intersect PI duplicated entries with all entries to get PI TADs and their WT subsets
bedtools intersect -a tmp1.bed -b tmp2.bed > fusion_tad.bed
#Remove all temporary files
rm tmp*.bed

