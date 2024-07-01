#!/usr/bin/env Rscript

library(ggplot2, quietly = TRUE, warn.conflicts=FALSE)
library(vegan, quietly = TRUE, warn.conflicts=FALSE)
library(dplyr, quietly = TRUE, warn.conflicts=FALSE)
library(optparse)

source("workflow/scripts/multi_merge.R")

option_list <- list(
  make_option(c("--profile"),help="Microbial profile"),
  make_option(c("--metadata"), help = "Metadata information"),
  make_option(c("--out1"), help = "Distance plots output name"),
  make_option(c("--out2"), help = "Figure S2 output name")
)

opt.parser <- OptionParser(option_list = option_list,
                           description="Usage: Figure-1.R [options]")

opts <- parse_args(opt.parser)

profile <- read.table(file = opts$profile, sep = "\t")
metadata <- read.table(opts$metadata, header = T,sep="\t")
#profile <- read.table(file = "../harpix-metagenomics-last/Data/microbial-profile.txt", sep="\t")

# Read the sample source file
sample_desc <- metadata
rownames(sample_desc) <- sample_desc$sample_id
loc <- sample_desc$body_site
names(loc) <- sample_desc$sample_id

loc[loc %in% c("ble004", "ble007", "ble008", "Syltholm")] <- "mastics"

# Keep only bacterial profiles

profile <- subset(profile, grepl(rownames(profile), pattern = "k__Bacteria"))

# Calculate the distance matrix
cat("Calculating distances\n")
d <- as.matrix(vegdist(x = t(profile), method = "bray"))

# Organize the distance matrix create plots
b <- data.frame(distance=as.vector(d), x=rownames(d), y=rep(colnames(d),
                each=ncol(d)), stringsAsFactors = FALSE)

areas <- c("nasalcavity","oralcavity","skin","stool","vagina","ancient dental calculus", "mastics")

b$Loc_X <- factor(loc[b$x], levels = areas)
b$Loc_Y <- factor(loc[b$y], levels = areas)

pdf(file = opts$out1, paper = "a4r")

p <- b %>% filter(distance>0, Loc_X!="New", Loc_X==Loc_Y) %>%
  ggplot(aes(x=Loc_X, y=distance)) +
  geom_boxplot() +
  xlab("Body Part") +
  ggtitle("Typical Bray-Curtis distance between body parts") + ylab("Distance")
print(p)

p <- b %>% filter(Loc_X=="mastics", distance>0, Loc_Y!="mastics") %>%
  ggplot(aes(x=Loc_Y, y=distance, color=x)) +
  ggtitle("Bray-Curtis distance between new samples and body parts") +
  geom_boxplot() + xlab("Body Part") + ylab("Distance") +
  theme_bw() +
  scale_color_discrete(name = "Samples")
print(p)

dev.off()

# Print figure 2
ggsave(filename = opts$out2, width = 4*3,height = 3*3, plot = p)