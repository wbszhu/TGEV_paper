input_file = "tpm-tmp"
output_file = "final_tpm_plot.txt"

with open(input_file, 'r') as fin, open(output_file, 'w') as fout:
    for line in fin:
        parts = line.strip().split('\t')
        if len(parts) < 8:
            continue  # 跳过列数不足的行
        
        group = parts[1]  # 第8列（Python索引从0开始）
        col12 = parts[6] # 第12列
        col13 = parts[7] # 第13列

        # 根据第8列选择输出哪个
        if group.lower() == "wt":
            selected_value = col12
        elif group.lower() == "pi":
            selected_value = col13
        else:
            selected_value = "NA"
        
        # 输出：原行 + 选中的列值
        fout.write('\t'.join(parts + [selected_value]) + '\n')
