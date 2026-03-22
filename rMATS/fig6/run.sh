export LD_LIBRARY_PATH=/path/to/anaconda/envs/rmat/lib:$LD_LIBRARY_PATH

rmats.py \
  --b1 wt2.txt \
  --b2 pi2.txt \
  --gtf /path/to/ref/Sus_scrofa.Sscrofa11.1.101.chr.gtf \
  --od ./2output \
  -t paired \
  --readLength 150 \
  --nthread 8 \
  --libType fr-firststrand
