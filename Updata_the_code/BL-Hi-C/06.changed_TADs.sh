sample=WT
software=/public/home/jingxu/00.software
fileA=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/${sample}.tad.bed
fileB=/public/home/jingxu/05.HiTag/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/${sample}_unchange_tad.bed

${software}/bedtools intersect -a ${fileA} \
                               -b ${fileB} \
                               -v > ${sample}_change_tad.bed
