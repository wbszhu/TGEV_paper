plotCorrelation -in scores_per_100kb.npz \
                --corMethod pearson \
                --skipZeros \
                --whatToPlot heatmap \
                --plotFile heatmap_PearsonCorr_bigwigScores.pdf \
                --outFileCorMatrix PearsonCorr_bigwigScores.tab \
                --plotTitle "Pearson Correlation of Average Scores Per 100kb" \
                --colorMap PuOr \
                --plotNumbers