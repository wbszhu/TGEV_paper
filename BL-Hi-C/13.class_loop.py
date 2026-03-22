import pandas as pd
import os

# ==== Input and output paths ====
input_file = "pi_loop_anno.txt"
output_dir = "00.piloops"

os.makedirs(output_dir, exist_ok=True)

# ==== Read file ====
df = pd.read_csv(input_file, sep="\t", header=None)

# Assume the last two columns are annotations
df["ann1"] = df.iloc[:, -2]
df["ann2"] = df.iloc[:, -2]

# ==== Generate unordered annotation pairs ====
df["annotation_pair"] = df.apply(lambda x: "_".join(sorted([str(x["ann1"]), str(x["ann2"])])), axis=1)

# ==== Group by annotation pair type and output ====
for pair, group in df.groupby("annotation_pair"):
    out_path = os.path.join(output_dir, f"pi_{pair}_loop.txt")
    group.to_csv(out_path, sep="\t", header=False, index=False)

