sample=pi
input_path=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/03.superEnh/${sample}
output_path=/public/home/jingxu/03.chip-seq/101TGEV/05.pro_enh/03.superEnh/${sample}/se_results

python ROSE_main.py \
       -g SS11 \
       -i ${input_path}/pi-enhancer.gff \
       -c ${input_path}/pi-27ac_pooled.bam \
       -r ${input_path}/pi-input_pooled.bam \
       -o ${output_path} \
       -s 12500 \
       -t 2000
