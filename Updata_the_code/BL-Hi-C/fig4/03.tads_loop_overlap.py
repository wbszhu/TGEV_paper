# 假设文件名如下：
a_file = "pi_loop.bedpe"
b_file = "/share/org/YZWL/yzwl_hanxs/03.jingxu/zuozhong_backup/TGEV/04.new_addanalysis/12.fig4/04.paper/02.tad_loop/PI.tad.bed"
output_file = "pi_intra_tads.txt"

# 1️⃣ 读取 b 文件的第2和第3列
b_ranges = []
with open(b_file, 'r') as bf:
    for line in bf:
        if line.strip() == "":
            continue
        cols = line.strip().split()
        b1 = cols[0]
        b2 = float(cols[1])
        b3 = float(cols[2])
        b_ranges.append((b1, b2, b3))

# 2️⃣ 遍历 a 文件的每一行
with open(a_file, 'r') as af, open(output_file, 'w') as out:
    for line in af:
        if line.strip() == "":
            continue
        cols = line.strip().split()
        a1 = cols[0]
        a2 = float(cols[2])
        a6 = float(cols[4])

        # 检查是否存在任意 b 满足条件
        for b1, b2, b3 in b_ranges:
            if b1 == a1 and a2 > b2 and a6 < b3:
                out.write(line)
                break  # 满足条件后立即跳出循环，进入下一行 a
