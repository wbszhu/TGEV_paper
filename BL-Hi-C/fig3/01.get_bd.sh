tads=/path/to/hic/data/03.TAD/tadlib/domain_caller/tad_class
#Get specific boundaries
awk 'BEGIN{OFS=FS="\t"}{print $1,$2+10000,$2+50000 "\n" $1,$3+10000,$3+50000}' ${tads}/WT.tad.bed | awk 'BEGIN{OFS=FS="\t"}($2 > 10000)' | uniq > WT_boundary.bed
awk 'BEGIN{OFS=FS="\t"}{print $1,$2+10000,$2+50000 "\n" $1,$3+10000,$3+50000}' ${tads}/PI.tad.bed | awk 'BEGIN{OFS=FS="\t"}($2 > 10000)' | uniq > PI_boundary.bed