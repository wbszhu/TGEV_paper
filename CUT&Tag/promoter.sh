awk 'OFS="\t" {if ($6 == "+") {print $1,$2-2500,$2+1500,$4,$5,$6} else {print $1,$3-1500,$3+2500,$4,$5,$6}}' random.bed | tr -d '";' |sort -k1,1V -k2,2n > random_TSS.bed
