plotProfile -m wt-enhancer.mat.gz \
            -out wt_enhancer.pdf \
            --plotTitle "Mock Distal H3K27ac" \
            --yMax 75 \
            --dpi 300 \
            --colors "#304172"

plotProfile -m pi-enhancer.mat.gz \
            -out pi_enhancer.pdf \
            --plotTitle "TGEV Distal H3K27ac" \
            --yMax 75 \
            --dpi 300 \
            --colors "#c0271d"