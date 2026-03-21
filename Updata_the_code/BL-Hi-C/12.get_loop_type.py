import pandas as pd

# ==== 输入文件路径 ====
bedpe_file = "pi_loop.bedpe"
bed_file = "pi_element.txt"
output_file = "pi_loop_anno.txt"

# ==== 读取文件 ====
bedpe = pd.read_csv(bedpe_file, sep="\t", header=None)
bed = pd.read_csv(bed_file, sep="\t", header=None, names=["chr", "start", "end", "annotation"])

# ==== 定义函数：找出一个anchor重叠的注释 ====
def find_annotations(chrom, start, end):
    overlaps = bed[(bed["chr"] == chrom) &
                   (bed["end"] > start) &
                   (bed["start"] < end)]
    return list(overlaps["annotation"])

# ==== 存放结果 ====
output_rows = []

for idx, row in bedpe.iterrows():
    chr1, s1, e1, chr2, s2, e2 = row[0], row[1], row[2], row[3], row[4], row[5]

    ann1 = find_annotations(chr1, s1, e1)
    ann2 = find_annotations(chr2, s2, e2)

    # 若无注释，使用 "NA"
    if not ann1:
        ann1 = ["Other"]
    if not ann2:
        ann2 = ["Other"]

    # 笛卡尔积组合
    for a1 in ann1:
        for a2 in ann2:
            output_rows.append([chr1, s1, e1, chr2, s2, e2] + [a1, a2])

# ==== 写出结果 ====
out_df = pd.DataFrame(output_rows)
out_df.to_csv(output_file, sep="\t", header=False, index=False)
