#library(gground)
library(ggprism)
library(tidyverse)
library(ggsci)
library(org.Hs.eg.db)
library(clusterProfiler)

use.pathway <- read.table("C:/Users/Administrator/Desktop/b2a_select.txt", sep="\t")
colnames(use.pathway) <- c("Description", "Pvalue", "Gene", "Count", "ONTOLOGY")
use.pathway$ONTOLOGY <- factor(use.pathway$ONTOLOGY, levels = rev(c('MF', 'CC', 'BP', 'KEGG')))
use.pathway$Description <- factor(use.pathway$Description, levels = use.pathway$Description)
use.pathway <- tibble::rowid_to_column(use.pathway, var = "index")

width <- 0.5
xaxis_max <- max(-log10(use.pathway$Pvalue)) +1
rect.data <- group_by(use.pathway, ONTOLOGY) %>%
  summarise(n=n()) %>%
  ungroup() %>%
  mutate(
    xmin = -3 * width,
    xmax = -2 * width,
    ymax = cumsum(n),
    ymin = lag(ymax, default = 0) + 0.6,
    ymax = ymax + 0.4
  )

ggplot(use.pathway, aes(x = -log10(Pvalue), y = index, fill = ONTOLOGY)) +
  geom_col(aes(y = Description), width = 0.6, alpha =0.8) +
  geom_text(aes(x = 0.05, label = Description), hjust=0, size=5) +
  geom_text(aes(x=0.1, label=Gene, colour = ONTOLOGY), hjust=0, vjust=3.1, size=3.2, fontface='italic', show.legend = FALSE) +
  geom_point(aes(x=-width, size=Count), shape=21) +
  geom_text(aes(x=-width, label=Count)) +
  scale_size_continuous(name='Count', range = c(5,12)) +
  geom_rect(aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill = ONTOLOGY), data = rect.data, inherit.aes = FALSE) +
  geom_text(aes(x=(xmin+xmax)/2, y=(ymin+ymax)/2, label=ONTOLOGY), data = rect.data, inherit.aes = FALSE) +
  geom_segment(aes(x=0, y=0,xend=xaxis_max, yend=0), linewidth=1.5, inherit.aes = FALSE) +
  labs(y=NULL) +
  scale_fill_npg(name="Category") +
  scale_colour_npg() +
  scale_x_continuous(breaks = seq(0,xaxis_max,2), expand = expansion(c(0,0))) +
  theme_prism() +
  theme(axis.text.y = element_blank(), axis.line = element_blank(),
        axis.ticks.y = element_blank(), legend.title = element_text())
  
ggsave("b2a_goplot.pdf", width = 9, height = 7)