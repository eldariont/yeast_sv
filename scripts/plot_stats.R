library(tidyverse)
library(ggrepel)

args = commandArgs(trailingOnly=TRUE)

construct <- read_tsv(args[1], col_names = c("mapped", "all", "graph", "sample"))
cactus <- read_tsv(args[2], col_names = c("mapped", "all", "graph", "sample"))
d <- rbind(construct, cactus)
d %>% 
  mutate(mapped_frac = mapped / all) %>% 
  select(sample, graph, mapped_frac) %>%
  spread(key = graph, value = mapped_frac) %>%
  ggplot(aes(construct, cactus, label=sample)) +
  geom_point() +
  geom_label_repel(aes(label = sample),
                   box.padding   = 0.15, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +
  coord_cartesian(xlim=c(0.7,1), ylim=c(0.7,1)) +
  geom_abline(intercept=0) +
  theme_bw()

ggsave(args[3], device = "pdf", width = 5, height=5)