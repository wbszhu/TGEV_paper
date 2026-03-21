bam=/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/03.cuttag/101TGEV/03.vis/03.deg_slm/00.bam

for i in wt_specific pi_specific merge; do
multiBamSummary BED-file \
                --BED ../../${i}_p_anchor.bed \
                --bamfiles ${bam}/WT-H3K27ac_rep1.bam \
                           ${bam}/WT-H3K27ac_rep2.bam \
                           ${bam}/WT-H3K4me3_rep1.bam \
                           ${bam}/WT-H3K4me3_rep2.bam \
                           ${bam}/WT-input_rep1.bam \
                           ${bam}/WT-input_rep2.bam \
                           ${bam}/PI-H3K27ac_rep1.bam \
                           ${bam}/PI-H3K27ac_rep2.bam \
                           ${bam}/PI-H3K4me3_rep1.bam \
                           ${bam}/PI-H3K4me3_rep2.bam \
                           ${bam}/PI-input_rep1.bam \
                           ${bam}/PI-input_rep2.bam \
                --labels WT-H3K27ac-rep1 \
                         WT-H3K27ac-rep2 \
                         WT-H3K4me3-rep1 \
                         WT-H3K4me3-rep2 \
                         WT-input-rep1 \
                         WT-input-rep2 \
                         PI-H3K27ac-rep1 \
                         PI-H3K27ac-rep2 \
                         PI-H3K4me3-rep1 \
                         PI-H3K4me3-rep2 \
                         PI-input-rep1 \
                         PI-input-rep2 \
                -p 8 \
                -out ${i}_scores_per_100kb_new.npz \
                --outRawCounts ${i}_scores_per_100kb_new.tab
awk -v var="$i" 'BEGIN{OFS=FS="\t"}{$16=var; print}' ${i}_scores_per_100kb_new.tab | sed '/^#/d' > ${i}-tmp
done

cat *-tmp > total_promoter_histonesignal.txt
rm *-tmp