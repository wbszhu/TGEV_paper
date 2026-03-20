software=/public/home/jingxu/00.software
fileA=PI.tad.bed
fileB=WT.tad.bed

${software}/bedtools intersect -a ${fileA} \
                               -b ${fileB} \
                               -f 0.9 \
                               -r -wa -wb > unchange_tad.bed

cut -f 1,2,3 unchange_tad.bed > PI_unchange_tad.bed
cut -f 4,5,6 unchange_tad.bed > WT_unchange_tad.bed
