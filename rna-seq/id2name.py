import click 

@click.command()
@click.argument("gene_bed")
@click.argument("idtsv")
@click.argument("outidtsv")
def main(gene_bed, idtsv, outidtsv):
    d = idWname(gene_bed)
    with open(idtsv, "r") as f, open(outidtsv, "w") as fo:
        fo.write(""+"\t"+"baseMean"+"\t"+"log2FoldChange"+"\t"+ "lfcSE"+"\t"+"stat"+"\t"+"pvalue"+"\t"+"padj"+"\n")
        next(f)
        for line in f:
            line1 = line.split("\t")
            line1[0] = d[line1[0]]
            fo.write('\t'.join(line1))




def idWname(gene_bed):
    d = dict()
    with open(gene_bed, "r") as fi:
        for line in fi:
            line1 = line.strip("\n")
            line2 = line1.split("\t")
            d[line2[0]] = line2[1]
        return d

if __name__ == "__main__":
    main()