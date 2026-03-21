DATA_DIR=/path/to/project/02.results/hic/00.tad_calling

sample=PI
cool=${DATA_DIR}/piDownsample/PI.balance.mcool::/resolutions/40000
domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrMT chrY  --DI-output ${sample}.DIs.bedGraph --removeCache


#sample=WT
#cool=${DATA_DIR}/WT.balance.mcool::/resolutions/40000
#domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrMT chrY  --DI-output ${sample}.DIs.bedGraph --removeCache
