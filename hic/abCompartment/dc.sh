DATA_DIR=/path/to/project/02.results/hic/06.compare_SARS-COV2

#sample=Mock_rep1
#cool=${DATA_DIR}/GSM5411173_NS74-NS67-HiC1.mcool::/resolutions/40000
#domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrM chrY  --DI-output ${sample}.DIs.bedGraph --removeCache

#sample=Mock_rep2
#cool=${DATA_DIR}/GSM5411174_NS74-NS67-HiC2.mcool::/resolutions/40000
#domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrM chrY  --DI-output ${sample}.DIs.bedGraph --removeCache

sample=ACE2-SARS-CoV2_rep1
cool=${DATA_DIR}/GSM5411175_NS74-NS67-HiC7.mcool::/resolutions/40000
domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrM chrY  --DI-output ${sample}.DIs.bedGraph --removeCache

#sample=ACE2-SARS-CoV2_rep2
#cool=${DATA_DIR}/GSM5411176_NS74-NS67-HiC8.mcool::/resolutions/40000
#domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrM chrY  --DI-output ${sample}.DIs.bedGraph --removeCache

