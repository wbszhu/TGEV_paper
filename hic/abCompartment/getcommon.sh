cat TGEV_p0.05fc1chaLinkG.txt|awk '{print $4}'|sort > TGEV_gene
cat ACE2-SARS-CoV2_p0.01fc2chaLinkG.txt|awk '{print $5}'|sort > ACE2-SARS-CoV2_gene
comm -12 TGEV_gene ACE2-SARS-CoV2_gene > commgene.txt
