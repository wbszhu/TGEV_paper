sample=WT
# software path removed - commands used directly
fileA=/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/${sample}.tad.bed
fileB=/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/${sample}_unchange_tad.bed

bedtools intersect -a ${fileA} \
                               -b ${fileB} \
                               -v > ${sample}_change_tad.bed
