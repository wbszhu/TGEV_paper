for i in 0.01 0.05
do
#cat TGEV_p${i}fc1chaLinkG.txt|awk '{OFS=FS="\t"}{if($4=="ensembl") print $1,$2,$3,$5;else print $1,$2,$3,$4}' > TGEV_p${i}fc1chaLinkG
cat TGEV_p${i}fc1chaLinkG.txt|awk '{OFS=FS="\t"}{print $1,$2,$3,$4,$5}' > TGEV_p${i}fc1chaLinkG
done


for i in 1st 2nd 3rd focus
do
for j in 0.01 0.05
do
cat ${i}_TGEV_p${j}fc1.com|while read line ;do grep $line TGEV_p${j}fc1chaLinkG;done > ${i}_TGEV_p${j}fc1.com.bed
sed -i 's/chr//' ${i}_TGEV_p${j}fc1.com.bed
done
done
