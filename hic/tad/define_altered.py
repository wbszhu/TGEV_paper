from tadlib.hitad.aligner import *

def transfer(f):
    out_s = str()
    l = [x for x in f]
    for x in range(len(l)):
        out = "\t".join(map(str, l[x]))
        out_f = out.replace(",", "\t").replace("(", "").replace(")", "").replace("'","")
        out_s = "\n".join([out_s,out_f])
    return out_s


with open('conserved.txt','w') as fc, open('semi.txt','w') as fse, open('merged.txt','w') as fm, open('split.txt','w') as fs:
    list1 = readHierDomain('WT.bed')
    list2 = readHierDomain('PI.bed')
    sample1 = DomainSet('sample1', list1, 40000)
    sample2 = DomainSet('sample2', list2, 40000)
    test_align = DomainAligner(sample1, sample2)
    test_align.align('sample1', 'sample2')
    conserved = test_align.conserved('sample1', 'sample2') 
    semi = test_align.inner_changed('sample1', 'sample2')
    merged = test_align.merged('sample1', 'sample2')
    split = test_align.split('sample1', 'sample2')
    fc.write(transfer(conserved))
    fse.write(transfer(semi))
    fm.write(transfer(merged))
    fs.write(transfer(split))
