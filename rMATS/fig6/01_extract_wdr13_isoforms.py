import pysam
import sys

GTF_FILE = "/path/to/ref/Sus_scrofa.Sscrofa11.1.101.chr.gtf"
FASTA_FILE = "/path/to/ref/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa"
OUTPUT_FILE = "/path/to/rMATS/output/WDR13_isoforms.fasta"

TRANSCRIPT_ID = "ENSSSCT00000023209"
TARGET_EXON_START = 42724313  # 1-based start from GTF
TARGET_EXON_END = 42724553    # 1-based end from GTF

CODON_TABLE = {
    'ATA':'I', 'ATC':'I', 'ATT':'I', 'ATG':'M',
    'ACA':'T', 'ACC':'T', 'ACG':'T', 'ACT':'T',
    'AAC':'N', 'AAT':'N', 'AAA':'K', 'AAG':'K',
    'AGC':'S', 'AGT':'S', 'AGA':'R', 'AGG':'R',
    'CTA':'L', 'CTC':'L', 'CTG':'L', 'CTT':'L',
    'CCA':'P', 'CCC':'P', 'CCG':'P', 'CCT':'P',
    'CAC':'H', 'CAT':'H', 'CAA':'Q', 'CAG':'Q',
    'CGA':'R', 'CGC':'R', 'CGG':'R', 'CGT':'R',
    'GTA':'V', 'GTC':'V', 'GTG':'V', 'GTT':'V',
    'GCA':'A', 'GCC':'A', 'GCG':'A', 'GCT':'A',
    'GAC':'D', 'GAT':'D', 'GAA':'E', 'GAG':'E',
    'GGA':'G', 'GGC':'G', 'GGG':'G', 'GGT':'G',
    'TCA':'S', 'TCC':'S', 'TCG':'S', 'TCT':'S',
    'TTC':'F', 'TTT':'F', 'TTA':'L', 'TTG':'L',
    'TAC':'Y', 'TAT':'Y', 'TAA':'*', 'TAG':'*',
    'TGC':'C', 'TGT':'C', 'TGA':'*', 'TGG':'W',
}

def reverse_complement(seq):
    complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A', 'N': 'N', 
                  'a': 't', 'c': 'g', 'g': 'c', 't': 'a', 'n': 'n'}
    return "".join(complement.get(base, base) for base in reversed(seq))

def translate_dna(dna_seq):
    protein = []
    dna_seq = dna_seq.upper()
    for i in range(0, len(dna_seq), 3):
        codon = dna_seq[i:i+3]
        if len(codon) == 3:
            protein.append(CODON_TABLE.get(codon, 'X'))
    return "".join(protein)

def get_transcript_cds_coords(gtf_path, transcript_id):
    """
    Parses GTF to get CDS coordinates for a specific transcript.
    Returns a list of (chrom, start, end, strand) tuples, sorted by genomic position.
    Note: GTF is 1-based.
    """
    cds_parts = []
    print(f"Parsing GTF: {gtf_path} for {transcript_id}...")
    
    with open(gtf_path, 'r') as f:
        for line in f:
            if line.startswith("#"): continue
            parts = line.strip().split('\t')
            if len(parts) < 9: continue
            
            feature_type = parts[2]
            if feature_type != "CDS": continue
            
            attributes = parts[8]
            if f'transcript_id "{transcript_id}"' not in attributes: continue
            
            chrom = parts[0]
            start = int(parts[3])
            end = int(parts[4])
            strand = parts[6]
            
            cds_parts.append((chrom, start, end, strand))
            
    cds_parts.sort(key=lambda x: x[1])
    return cds_parts

def main():
    # 1. Get CDS coordinates
    cds_list = get_transcript_cds_coords(GTF_FILE, TRANSCRIPT_ID)
    if not cds_list:
        print(f"Error: No CDS found for {TRANSCRIPT_ID}")
        sys.exit(1)
        
    print(f"Found {len(cds_list)} CDS exons.")
    chrom = cds_list[0][0]
    strand = cds_list[0][3]
    
    # 2. Open Fasta
    print(f"Opening FASTA: {FASTA_FILE}...")
    fasta = pysam.FastaFile(FASTA_FILE)
    
    # 3. Construct WT and mutant (exon-skipped) sequences
    genomic_seq_parts_wt = []
    genomic_seq_parts_mut = []
    
    target_found = False
    
    for (c, s, e, st) in cds_list:
        seq_chunk = fasta.fetch(c, s - 1, e)
        genomic_seq_parts_wt.append(seq_chunk)
        
        if s == TARGET_EXON_START and e == TARGET_EXON_END:
            print(f"  Skipping Target Exon for Mutant: {s}-{e}")
            target_found = True
        else:
            genomic_seq_parts_mut.append(seq_chunk)
            
    if not target_found:
        print(f"Warning: Target exon {TARGET_EXON_START}-{TARGET_EXON_END} not exactly matched in CDS list.")
        print("Available CDS:", [(x[1], x[2]) for x in cds_list])
    
    full_genomic_wt = "".join(genomic_seq_parts_wt)
    full_genomic_mut = "".join(genomic_seq_parts_mut)
    
    if strand == '-':
        final_rna_wt = reverse_complement(full_genomic_wt)
        final_rna_mut = reverse_complement(full_genomic_mut)
    else:
        final_rna_wt = full_genomic_wt
        final_rna_mut = full_genomic_mut
        
    prot_wt = translate_dna(final_rna_wt)
    prot_mut = translate_dna(final_rna_mut)
    
    print(f"\nWT Protein Length: {len(prot_wt)} aa")
    print(f"Mutant Protein Length: {len(prot_mut)} aa")
    
    if "*" in prot_wt[:-1]:
        print("Warning: WT sequence contains internal stop codons!")
    if "*" in prot_mut[:-1]:
        print("Warning: Mutant sequence contains internal stop codons! (Expected if frameshift occurred)")
        first_stop = prot_mut.find("*")
        print(f"  First stop at index: {first_stop}")
        
    with open(OUTPUT_FILE, 'w') as f:
        f.write(f">WDR13_WT_Inclusion\n{prot_wt}\n")
        f.write(f">WDR13_Mutant_Skipping\n{prot_mut}\n")
        
    print(f"Saved to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
