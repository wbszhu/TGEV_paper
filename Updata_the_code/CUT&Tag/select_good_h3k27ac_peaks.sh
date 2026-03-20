peak_path=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/02.enhancer/pi_new
bam_path=/public/home/jingxu/03.chip-seq/101TGEV/03.vis/03.deg_slm/00.bam

multiBamSummary BED-file \
 --BED ${peak_path}/pi27ac_p5q2.sort.bed \
 --bamfiles ${bam_path}/PI-H3K27ac_rep1.bam ${bam_path}/PI-H3K27ac_rep2.bam ${bam_path}/PI-input_rep1.bam ${bam_path}/PI-input_rep2.bam \
 -p 10 \
 --labels k27ac_1 k27ac_2 input_1 input_2 \
 --outRawCounts ${peak_path}/pi-k27ac_peakReadcount.txt \
 -o ${peak_path}/pi-k27ac_results.npz
