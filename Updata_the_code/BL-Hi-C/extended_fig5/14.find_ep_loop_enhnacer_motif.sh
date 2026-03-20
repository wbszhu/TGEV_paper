#CSUB -J homer
#CSUB -q c01
#CSUB -o homer.out.%J
#CSUB -e homer.err.%J
#CSUB -n 16
#CSUB -R "span[hosts=1]"

source /share/apps/anaconda3/bin/activate
conda activate test
export PATH=/share/org/YZWL/yzwl_hanxs/00.software/homer/bin:$PATH

findMotifsGenome.pl \
  share_enhancer_element.txt \
  ~/00.software/homer/data/genomes/susScr11 \
  share \
  -mknown ~/00.software/motif_database/JASPAR2024_CORE_vertebrates_non-redundant_pfms_jaspar.homer.motif \
  -size 250 -mask -p 16 -nomotif
done