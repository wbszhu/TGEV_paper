bam=/path/to/cutandtag/data/03.vis/03.deg_slm/00.bam

for i in part_1_0-5 part_2_5-10 part_3_10-50 part_4_50-90 part_5_90-95 part_6_95-100; do
multiBamSummary BED-file \
                --BED ../${i}.txt \
                --bamfiles ${bam}/WT-H3K27ac_rep1.bam \
                           ${bam}/WT-H3K27ac_rep2.bam \
                           ${bam}/WT-H3K4me3_rep1.bam \
                           ${bam}/WT-H3K4me3_rep2.bam \
                           ${bam}/WT-H3K27me3_rep1.bam \
                           ${bam}/WT-H3K27me3_rep2.bam \
                           ${bam}/WT-input_rep1.bam \
                           ${bam}/WT-input_rep2.bam \
                           ${bam}/PI-H3K27ac_rep1.bam \
                           ${bam}/PI-H3K27ac_rep2.bam \
                           ${bam}/PI-H3K4me3_rep1.bam \
                           ${bam}/PI-H3K4me3_rep2.bam \
                           ${bam}/PI-H3K27me3_rep1.bam \
                           ${bam}/PI-H3K27me3_rep2.bam \
                           ${bam}/PI-input_rep1.bam \
                           ${bam}/PI-input_rep2.bam \
                --labels WT-H3K27ac-rep1 \
                         WT-H3K27ac-rep2 \
                         WT-H3K4me3-rep1 \
                         WT-H3K4me3-rep2 \
                         WT-H3K27me3-rep1 \
                         WT-H3K27me3-rep2 \
                         WT-input-rep1 \
                         WT-input-rep2 \
                         PI-H3K27ac-rep1 \
                         PI-H3K27ac-rep2 \
                         PI-H3K4me3-rep1 \
                         PI-H3K4me3-rep2 \
                         PI-H3K27me3-rep1 \
                         PI-H3K27me3-rep2 \
                         PI-input-rep1 \
                         PI-input-rep2 \
                -p 32 \
                -out ${i}_scores_per_100kb_new.npz \
                --outRawCounts ${i}_scores_per_100kb_new.tab
awk -v var="$i" 'BEGIN{OFS=FS="\t"}{$20=var; print}' ${i}_scores_per_100kb_new.tab | sed '/^#/d' > ${i}-tmp
done

cat *-tmp > total_tads_histonesignal.txt