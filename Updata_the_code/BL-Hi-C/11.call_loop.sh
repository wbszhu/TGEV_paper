for sample in WT PI; do
res=10
mcool=/public/home/jingxu/05.HiTag/02.test_hic-tgev/01.cooltools/${sample}/${sample}.balanceNoMTY.mcool

pyHICCUPS -O ${sample}-HICCUPS-loops.txt \
          -p ${mcool}::/resolutions/${res}000 \
          --pw 1 2 4 \
          --ww 3 5 7 \
          --only-anchors \
          --nproc 5
done