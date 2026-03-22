# software path removed - commands used directly
fileA=/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/PI_change_tad.bed
fileB=/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/WT_change_tad.bed
#Find PI group TADs with 90% overlap in WT group, where WT TADs do not have 90% overlap in PI group
bedtools intersect -a ${fileA} \
                               -b ${fileB} \
                               -f 0.9 \
                               -wa -wb > tmp1.bed
#The result has PI group in the first 3 columns and WT group in the last 3 columns; swap to put WT group first
awk -v OFS='\t' '{temp1=$1; temp2=$2; temp3=$3; $1=$4; $2=$5; $3=$6; $4=temp1; $5=temp2; $6=temp3; print}' tmp1.bed > tmp2.bed
#Extract duplicated position entries from the WT group
cut -f 1,2,3 tmp2.bed | uniq -d > tmp3.bed
#Intersect WT duplicated entries with all entries to get WT TADs and their PI subsets
bedtools intersect -a tmp2.bed -b tmp3.bed > tmp4.bed
#Swap columns back so that the first 3 columns are PI group and the last 3 columns are WT group
awk -v OFS='\t' '{temp1=$1; temp2=$2; temp3=$3; $1=$4; $2=$5; $3=$6; $4=temp1; $5=temp2; $6=temp3; print}' tmp4.bed > separation_tad.bed
#Remove temporary files
rm tmp*.bed
