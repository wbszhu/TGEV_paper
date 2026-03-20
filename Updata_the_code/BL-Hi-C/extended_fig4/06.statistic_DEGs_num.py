# 文件路径
file_a = "degs.txt"
file_b = "part6.txt"
output_file = "part6_num.txt"

# 读取 A 文件并构建字典：key → (val4, val5)
a_dict = {}
with open(file_a) as f:
    for line in f:
        parts = line.strip().split()
        key = parts[0]  # 取第一列列为 key
        a_dict[key] = parts[1]

# 遍历 B 文件，查找对应的 value 并写入新文件
with open(file_b) as f, open(output_file, "w") as out:
    for line in f:
        parts = line.strip().split()
        key = parts[7]
        value = a_dict.get(key, "NA")  # 如果没匹配上，则填 NA
        out.write(line.strip() + "\t" + value + "\n")

print("处理完成，输出文件：", output_file)