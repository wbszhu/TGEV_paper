# File paths
file_a = "degs.txt"
file_b = "part6.txt"
output_file = "part6_num.txt"

# Read file A and build a dictionary: key -> (val4, val5)
a_dict = {}
with open(file_a) as f:
    for line in f:
        parts = line.strip().split()
        key = parts[0]  # Use the first column as key
        a_dict[key] = parts[1]

# Iterate through file B, find corresponding values and write to new file
with open(file_b) as f, open(output_file, "w") as out:
    for line in f:
        parts = line.strip().split()
        key = parts[7]
        value = a_dict.get(key, "NA")  # Fill NA if no match found
        out.write(line.strip() + "\t" + value + "\n")

print("Processing complete, output file:", output_file)