import pandas as pd
import bioframe as bf
import sys

all_bd=sys.argv[1]
tbd=sys.argv[2]
mock_is=sys.argv[3]
pi_is=sys.argv[4]

def c_p():
    from scipy.stats import ttest_ind
    p = []
    for _, row in out.iterrows():
        stat,pvalue = ttest_ind(row['wt_is'], row['pi_is'])
        p.append(pvalue)
    return p

def Average(lst):
    return sum(lst) / len(lst)

def c_fc():
    from scipy.stats import ttest_ind
    fc = []
    for _, row in out.iterrows():
        f = Average(row['wt_is'])/Average(row['pi_is'])
        fc.append(f)
    return fc

bd = pd.read_csv(all_bd, sep="\t",header=None)
bd.columns = ["chrom", "start", "end"]
wt = pd.read_csv(mock_is, sep="\t")
wt_final = wt[wt["is_bad_bin"]==False]
olwt = bf.overlap(bd, wt_final, how="inner", suffixes=('_1','_2'))
olwt_final = olwt.groupby(["chrom_1","start_1","end_1"])["log2_insulation_score_1000000_2"].apply(list).reset_index(name="wt_is")
pi = pd.read_csv(pi_is, sep="\t")
pi_final = pi[pi["is_bad_bin"]==False]
olpi = bf.overlap(bd, pi_final, how="inner", suffixes=('_1','_2'))
olpi_final = olpi.groupby(["chrom_1","start_1","end_1"])["log2_insulation_score_1000000_2"].apply(list).reset_index(name="pi_is")
out = pd.merge(olwt_final, olpi_final)
p=c_p()
out["p-value"] = p
fc=c_fc()
out["fc"] = fc
bd_change = out[(out["p-value"]<0.01)&(out["fc"]>2)]
bd_change.to_csv(tbd, sep="\t", index=False)
