total=$(wc -l < sorted_tads_bycontact.bed)

awk -v total=$total '
NR <= total*0.05                          {print > "part_1_0-5.txt"  }
NR >  total*0.05  && NR <= total*0.10     {print > "part_2_5-10.txt" }
NR >  total*0.10  && NR <= total*0.50     {print > "part_3_10-50.txt"}
NR >  total*0.50  && NR <= total*0.90     {print > "part_4_50-90.txt"}
NR >  total*0.90  && NR <= total*0.95     {print > "part_5_90-95.txt"}
NR >  total*0.95                          {print > "part_6_95-100.txt"}
' sorted_tads_bycontact.bed
