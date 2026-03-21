#!/bin/bash

# Replace "input.bed" with the path to your input BED file
input_file="total.bed"
output_file="random_selection.bed"

# Count the total number of lines in the input file
total_lines=$(wc -l < "$input_file")

# Specify the number of lines to randomly select
lines_to_select=1227

# Use shuf to randomly shuffle the lines and then select the first 1227 lines
shuf "$input_file" | head -n "$lines_to_select" > "$output_file"

echo "Random selection complete. Results saved to $output_file."

