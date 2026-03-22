bam=/path/to/cutandtag/data/03.vis/03.deg_slm/00.bam

multiBamSummary bins \
                --binSize 100000 \
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
                -out scores_per_100kb_new.npz \
                --outRawCounts scores_per_100kb_new.tab
