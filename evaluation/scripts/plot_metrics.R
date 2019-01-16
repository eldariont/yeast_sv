library(tidyverse)

args = commandArgs(trailingOnly=TRUE)

data <- read_tsv(args[1], col_names=c("graph", "strain", "class", "tp", "tpb", "fp", "fn", "precision", "recall", "f1"))
data_precision <- data %>% select(-tp, -tpb, -fp, -fn, -recall, -f1) %>% spread(key = graph, value = precision, drop=FALSE) %>% mutate(metric="precision")
data_recall <- data %>% select(-tp, -tpb, -fp, -fn, -precision, -f1) %>% spread(key = graph, value = recall, drop=FALSE) %>% mutate(metric="recall")
data_f1 <- data %>% select(-tp, -tpb, -fp, -fn, -precision, -recall) %>% spread(key = graph, value = f1, drop=FALSE) %>% mutate(metric="f1")
data_all <- rbind(data_precision, data_recall, data_f1)

samples <- read_tsv("/Users/eldarion/Documents/Projects/ucsc/toilvg/strains.tsv", col_names = c("strain", "clade"))


ggplot(data_all %>% inner_join(samples), aes(x=construct, cactus, color=strain, pch=clade)) +
  geom_point() +
  coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
  geom_abline(intercept=0) +
  facet_wrap(metric~class) +
  theme_bw()
  #geom_vline(aes(xintercept=construct, color=strain)) +
  #geom_hline(aes(yintercept=cactus, color=strain))

ggsave(args[2], device = "pdf", width = 6, height=6)
