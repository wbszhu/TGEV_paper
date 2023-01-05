for i in 1st 2nd 3rd focus
do
for j in 0.01 0.05
do
liftOver ${i}_TGEV_p${j}fc1.com.bed pig11to10_chain.txt ${i}_TGEV_p${j}fc1.comTo10.bed ${i}_${j}unmap.bed
done
done
