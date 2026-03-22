for enh in pi_unique_enh wt_unique_enh
do
findMotifsGenome.pl /path/to/cutandtag/data/${enh}.bed /path/to/cutandtag/data/pig11.1 ${enh}_out -size 200 -len 8
done
