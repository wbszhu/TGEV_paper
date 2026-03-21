import pandas as pd
import os

# ==== 输入与输出路径 ====
input_file = "pi_loop_anno.txt"
output_dir = "00.piloops"

os.makedirs(output_dir, exist_ok=True)

# ==== 读取文件 ====
df = pd.read_csv(input_file, sep="\t", header=None)

# 假设最后两列是注释
df["ann1"] = df.iloc[:, -2]
df["ann2"] = df.iloc[:, -2]

# ==== 生成无序注释组合 ====
df["annotation_pair"] = df.apply(lambda x: "_".join(sorted([str(x["ann1"]), str(x["ann2"])])), axis=1)

# ==== 按组合类型分组输出 ====
for pair, group in df.groupby("annotation_pair"):
    out_path = os.path.join(output_dir, f"pi_{pair}_loop.txt")
    group.to_csv(out_path, sep="\t", header=False, index=False)

