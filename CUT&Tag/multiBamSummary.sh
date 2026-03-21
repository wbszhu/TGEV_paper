multiBamSummary BED-file \
 --BED random_TSS.bed \
 --bamfiles ./00.bam/WT-H3K27ac_rep1.bam ./00.bam/WT-H3K27ac_rep2.bam ./00.bam/WT-input_rep1.bam ./00.bam/WT-input_rep2.bam ./00.bam/PI-H3K27ac_rep1.bam ./00.bam/PI-H3K27ac_rep2.bam ./00.bam/PI-input_rep1.bam ./00.bam/PI-input_rep2.bam \
 -p 20 \
 --labels wt-k27ac_1 wt-k27ac_2 wt-input_1 wt-input_2 pi-k27ac_1 pi-k27ac_2 pi-input_1 pi-input_2 \
 --outRawCounts random_peakReadcount.txt \
 -o random_results.npz

