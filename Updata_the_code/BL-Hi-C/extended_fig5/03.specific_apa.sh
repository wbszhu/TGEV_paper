res=10

for i in WT PI; do
for j in WT PI; do
    apa-analysis -O ${i}_specific_loop_test_default.pdf \
                 -p /public/home/jingxu/05.HiTag/02.test_hic-tgev/01.cooltools/${i}/${i}.balanceNoMTY.mcool::/resolutions/${res}000 \
                 -I ${j}_specific_loops.txt \
                 --clr-weight-name weight \
                 -W 11 \
                 --vmax 4
done
done