#Import required libraries
import pandas as pd
import numpy as np
import cooler
#Get WT and PI matrix files
wt_mcool = cooler.Cooler('/path/to/hic/data/02.test_hic-tgev/01.cooltools/WT/WT.balanceNoMTY.mcool::/resolutions/40000')
wt_matrix = wt_mcool.matrix()
pi_mcool = cooler.Cooler('/path/to/hic/data/02.test_hic-tgev/01.cooltools/PI/PI.balanceNoMTY.mcool::/resolutions/40000')
pi_matrix = pi_mcool.matrix()
#Define function to extract contacts corresponding to positions in a given bed file
def Contact_matrix(input_file, output_file):
    with open (input_file, 'r') as f, open(output_file,'w') as w:
        for line in f:
            line1 = line.strip('\n').split('\t')
            bins = line1[0]+':'+line1[1]+'-'+line1[2]
            wt_contact = wt_matrix.fetch(bins)
            pi_contact = pi_matrix.fetch(bins)
            wt_float_contact = wt_contact.astype(float).mean()
            pi_float_contact = pi_contact.astype(float).mean()
            combined_contact = np.array([wt_float_contact, pi_float_contact])
            np.savetxt(w, combined_contact[np.newaxis], delimiter='\t')
#Call function for different types of compartments
Contact_matrix('/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/WT.tad.bed','wt_tad_contact.txt')
Contact_matrix('/path/to/hic/data/02.test_hic-tgev/03.TAD/tadlib/domain_caller/tad_class/PI.tad.bed','pi_tad_contact.txt')
