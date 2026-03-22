# identify specific enhancer
# pi_enhancer.bed ; wt_enhancer.bed
# get wt specific enhancer
bedtools interact -a wt_enhancer.bed -b pi_enhancer.bed -wa -u > wt_sp_enhancer.bed
# get pi specific enhancer
bedtools interact -a pi_enhancer.bed -b wt_enhancer.bed -wa -u > pi_sp_enhancer.bed

