peak_path=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/01.promoter/pi_new
bam_path=/public/home/jingxu/03.chip-seq/101TGEV/03.vis/03.deg_slm/00.bam

multiBamSummary BED-file \
 --BED ${peak_path}/pi43_p5q2.sort.bed \
 --bamfiles ${bam_path}/PI-H3K4me3_rep1.bam ${bam_path}/PI-H3K4me3_rep2.bam ${bam_path}/PI-input_rep1.bam ${bam_path}/PI-input_rep2.bam \
 -p 10 \
 --labels k4me3_1 k4me3_2 input_1 input_2 \
 --outRawCounts ${peak_path}/pi-k4me3_peakReadcount.txt \
 -o ${peak_path}/pi-k4me3_results.npz
