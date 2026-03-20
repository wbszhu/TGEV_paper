cut -f 1-8 ../../../00.piloops/pi_enhancer_promoter_loop.txt | bedtools pairtobed -a - -b pi_promoter_anchor.txt -type xor > pi_ep_loop.txt
cut -f 1-8 ../../../00.wtloops/wt_enhancer_promoter_loop.txt | bedtools pairtobed -a - -b wt_promoter_anchor.txt -type xor > wt_ep_loop.txt

cut -f 1-8 ../../../00.wtloops/wt_enhancer_promoter_loop.txt | bedtools pairtobed -a - -b share_promoter_anchor.txt -type xor > share_wt_ep_loop.txt
cut -f 1-8 ../../../00.piloops/pi_enhancer_promoter_loop.txt | bedtools pairtobed -a - -b share_promoter_anchor.txt -type xor > share_pi_ep_loop.txt