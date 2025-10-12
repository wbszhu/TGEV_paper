for i in 1 2 3 
do
cat all.com.gene |while read line ;do grep -w $line ~/08.TGEV/00.data/CRISPR_results/sunlimeng${i}.txt; done > ${i}all.comgenesgRNA
#cat all.com.gene |while read line ;do grep -w $line ~/08.TGEV/00.data/CRISPR_results/sunlimeng_focus.txt ; done > focusall.comgenesgRNA
done

cat 1all.comgenesgRNA  2all.comgenesgRNA 3all.comgenesgRNA |sort -u > all_sgRNA.txt
#focusall.comgenesgRNA |sort -u > all_sgRNA.txt
