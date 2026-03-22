input_file = "tpm-tmp"
output_file = "final_tpm_plot.txt"

with open(input_file, 'r') as fin, open(output_file, 'w') as fout:
    for line in fin:
        parts = line.strip().split('\t')
        if len(parts) < 8:
            continue  # Skip rows with insufficient columns
        
        group = parts[1]  # Column 8 (Python index starts from 0)
        col12 = parts[6] # Column 12
        col13 = parts[7] # Column 13

        # Select output based on column 8
        if group.lower() == "wt":
            selected_value = col12
        elif group.lower() == "pi":
            selected_value = col13
        else:
            selected_value = "NA"
        
        # Output: original line + selected column value
        fout.write('\t'.join(parts + [selected_value]) + '\n')
