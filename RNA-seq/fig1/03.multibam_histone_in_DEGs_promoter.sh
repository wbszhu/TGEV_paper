for i in up none down; do
multiBamSummary BED-file \
                --BED /path/to/rnaseq/data/${i}.txt \
                --bamfiles /path/to/cutandtag/data/WT-H3K27ac_rep1.bam \
                           /path/to/cutandtag/data/WT-H3K27ac_rep2.bam \
                           /path/to/cutandtag/data/WT-H3K4me3_rep1.bam \
                           /path/to/cutandtag/data/WT-H3K4me3_rep2.bam \
                           /path/to/cutandtag/data/WT-H3K27me3_rep1.bam \
                           /path/to/cutandtag/data/WT-H3K27me3_rep2.bam \
                           /path/to/cutandtag/data/WT-input_rep1.bam \
                           /path/to/cutandtag/data/WT-input_rep2.bam \
                           /path/to/cutandtag/data/PI-H3K27ac_rep1.bam \
                           /path/to/cutandtag/data/PI-H3K27ac_rep2.bam \
                           /path/to/cutandtag/data/PI-H3K4me3_rep1.bam \
                           /path/to/cutandtag/data/PI-H3K4me3_rep2.bam \
                           /path/to/cutandtag/data/PI-H3K27me3_rep1.bam \
                           /path/to/cutandtag/data/PI-H3K27me3_rep2.bam \
                           /path/to/cutandtag/data/PI-input_rep1.bam \
                           /path/to/cutandtag/data/PI-input_rep2.bam \
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
#markered different histone signal multibam result
awk -v var="$i" 'BEGIN{OFS=FS="\t"}{$20=var; print}' /path/to/cutandtag/data/${i}_scores.tab | sed '/^#/d' > /path/to/cutandtag/data/${i}-tmp
done
#merge all histone signal result
cat /path/to/cutandtag/data/*-tmp > /path/to/cutandtag/data/total_degs_promoter_histonesignal.txt