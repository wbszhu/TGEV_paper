bam=/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/03.cuttag/101TGEV/03.vis/03.deg_slm/00.bam

multiBamSummary BED-file \
                --BED wt_enhancer_sort.bed \
                --bamfiles ${bam}/WT-H3K27ac_rep1.bam \
                           ${bam}/WT-H3K27ac_rep2.bam \
                           ${bam}/WT-input_rep1.bam \
                           ${bam}/WT-input_rep2.bam \
                --labels WT-H3K27ac-rep1 \
                         WT-H3K27ac-rep2 \
                         WT-input-rep1 \
                         WT-input-rep2 \
                -p 8 \
                -out wt_27ac_scores_per_100kb_new.npz \
                --outRawCounts wt_27ac_scores_per_100kb_new.tab

multiBamSummary BED-file \
                --BED pi_enhancer_sort.bed \
                --bamfiles ${bam}/PI-H3K27ac_rep1.bam \
                           ${bam}/PI-H3K27ac_rep2.bam \
                           ${bam}/PI-input_rep1.bam \
                           ${bam}/PI-input_rep2.bam \
                --labels PI-H3K27ac-rep1 \
                         PI-H3K27ac-rep2 \
                         PI-input-rep1 \
                         PI-input-rep2 \
                -p 8 \
                -out pi_27ac_scores_per_100kb_new.npz \
                --outRawCounts pi_27ac_scores_per_100kb_new.tab