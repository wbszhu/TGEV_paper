rmats2sashimiplot --b1 Mock1.bam,Mock2.bam,Mock3.bam \
--b2 TGEV1.bam,TGEV2.bam,TGEV3.bam \
-c chrX:+:42722785:42730199:/share/org/YZWL/yzwl_hanxs/03.jingxu/01.ref/Sscrofa101/Sus_scrofa.Sscrofa11.1.101.chr.gff3 \
--l1 Mock --l2 TGEV --exon_s 1 --intron_s 5 -o sashimiplot_WDR13_2 --group-info grouping.gf --color "#304172","#c0271d"