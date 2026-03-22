bam=/path/to/cutandtag/data/03.vis/03.deg_slm/00.bam

for i in up none down; do
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
                -out ${i}_scores.npz \
                --outRawCounts ${i}_scores.tab
awk -v var="$i" 'BEGIN{OFS=FS="\t"}{$20=var; print}' ${i}_scores.tab | sed '/^#/d' > ${i}-tmp
done

cat *-tmp > total_degs_promoter_histonesignal.txt