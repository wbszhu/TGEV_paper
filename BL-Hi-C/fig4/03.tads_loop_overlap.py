# Assume file names are as follows:
a_file = "pi_loop.bedpe"
b_file = "/path/to/project/04.new_addanalysis/12.fig4/04.paper/02.tad_loop/PI.tad.bed"
output_file = "pi_intra_tads.txt"

# 1. Read columns 2 and 3 from file b
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

# 2. Iterate through each line of file a
with open(a_file, 'r') as af, open(output_file, 'w') as out:
    for line in af:
        if line.strip() == "":
            continue
        cols = line.strip().split()
        a1 = cols[0]
        a2 = float(cols[2])
        a6 = float(cols[4])

        # Check if any b satisfies the condition
        for b1, b2, b3 in b_ranges:
            if b1 == a1 and a2 > b2 and a6 < b3:
                out.write(line)
                break  # Break immediately after condition is met, move to next line of a
