res=10

for i in WT PI; do
    apa-analysis -O ${i}_all_loop_test_default.pdf \
                 -p /path/to/hic/data/02.test_hic-tgev/01.cooltools/${i}/${i}.balanceNoMTY.mcool::/resolutions/${res}000 \
                 -I ${i}-HICCUPS-loops.txt \
                 --clr-weight-name weight \
                 -W 11 \
                 --vmax 4
done