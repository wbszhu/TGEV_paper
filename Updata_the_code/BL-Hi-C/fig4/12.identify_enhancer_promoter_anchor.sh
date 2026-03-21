wtep=/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/04.new_addanalysis/12.fig4/05.paper_10kb/00.wtloops/wt_enhancer_promoter_loop.txt
piep=/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/04.new_addanalysis/12.fig4/05.paper_10kb/00.piloops/pi_enhancer_promoter_loop.txt

pianchor=/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/04.new_addanalysis/12.fig4/05.paper_10kb/03.ep_loop/03.p_anchor_specific/pi_specific_p_anchor.bed
wtanchor=/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/04.new_addanalysis/12.fig4/05.paper_10kb/03.ep_loop/03.p_anchor_specific/wt_specific_p_anchor.bed
shareanchor=/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/04.new_addanalysis/12.fig4/05.paper_10kb/03.ep_loop/03.p_anchor_specific/merge_p_anchor.bed

cut -f 1-8 ${wtep} > wt_ep_loop.bedpe
cut -f 1-8 ${piep} > pi_ep_loop.bedpe
#wt
bedtools pairtobed -a wt_ep_loop.bedpe -b ${wtanchor} -type xor | awk '$7=="enhancer"{print $1,$2,$3} $8=="enhancer"{print $4,$5,$6}' | sed 's/ /\t/g' - | sort -k1,1V -k2,2n | uniq > wt_specific_enhancer.txt
#pi
bedtools pairtobed -a pi_ep_loop.bedpe -b ${pianchor} -type xor | awk '$7=="enhancer"{print $1,$2,$3} $8=="enhancer"{print $4,$5,$6}' | sed 's/ /\t/g' - | sort -k1,1V -k2,2n | uniq > pi_specific_enhancer.txt
#share
bedtools pairtobed -a wt_ep_loop.bedpe -b ${shareanchor} -type xor | awk '$7=="enhancer"{print $1,$2,$3} $8=="enhancer"{print $4,$5,$6}' | sed 's/ /\t/g' - | sort -k1,1V -k2,2n | uniq > share_wt_enhancer.txt
bedtools pairtobed -a pi_ep_loop.bedpe -b ${shareanchor} -type xor | awk '$7=="enhancer"{print $1,$2,$3} $8=="enhancer"{print $4,$5,$6}' | sed 's/ /\t/g' - | sort -k1,1V -k2,2n | uniq > share_pi_enhancer.txt