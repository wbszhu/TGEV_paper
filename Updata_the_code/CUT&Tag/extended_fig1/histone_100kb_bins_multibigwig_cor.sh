multiBigwigSummary bins \
                   --binSize 100000 \
                   -b Mock-H3K27ac-rep1.bw Mock-H3K27ac-rep2.bw \
                    Mock-H3K4me3-rep1.bw Mock-H3K4me3-rep2.bw \
                    Mock-H3K27me3-rep1.bw Mock-H3K27me3-rep2.bw \
                    TGEV-H3K27ac-rep1.bw TGEV-H3K27ac-rep2.bw \
                    TGEV-H3K4me3-rep1.bw TGEV-H3K4me3-rep2.bw \
                    TGEV-H3K27me3-rep1.bw TGEV-H3K27me3-rep2.bw \
                   -out scores_per_100kb.npz \
                   --outRawCounts scores_per_100kb.tab \
                   -p 16