sample=PI
cool=/public/home/luzhang/08.TGEV/02.results/hic/00.tad_calling/piDownsample/PI.balance.mcool::/resolutions/40000
domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrMT chrY  --DI-output ${sample}.DIs.bedGraph --removeCache


#sample=WT
#cool=/public/home/luzhang/08.TGEV/02.results/hic/00.tad_calling/WT.balance.mcool::/resolutions/40000
#domaincaller --uri $cool  -O ${sample}.tad.bed --exclude chrMT chrY  --DI-output ${sample}.DIs.bedGraph --removeCache
