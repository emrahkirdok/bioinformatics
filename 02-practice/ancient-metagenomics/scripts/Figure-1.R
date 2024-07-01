# Load libraries
library(ggplot2)
library(ggrepel)
library(vegan)
library(magrittr)
library(optparse)
library(ggpubr)

option_list <- list(
  make_option(c("--profile"),help="Microbial profile"),
  make_option(c("--metadata"), help = "Metadata information"),
  make_option(c("--output"), help = "Figure 1 output name")
)

opt.parser <- OptionParser(option_list = option_list,
                           description="Usage: Figure-1.R [options]")

opts <- parse_args(opt.parser)

profile <- read.table(file = opts$profile, sep = "\t")
metadata <- read.table(opts$metadata, header = T,sep="\t")

# Apply NMDS method on the dataset
nmds<-metaMDS(t(profile), k = 7)

data.scores <- as.data.frame(scores(nmds, display = "sites"))

data.scores$Origin <- metadata$body_site
scores.ble<-data.scores[grep(pattern = "ble|Syltholm", x = data.scores$Origin),]
scores.data<-data.scores[grep(pattern = "ble|Syltholm", x = data.scores$Origin, invert = T),]

plot_12 <- ggplot()  + geom_point(data=scores.data,
                                  aes(x=NMDS1,y=NMDS2,
                                      colour=Origin, shape=Origin),
                                  size=2, alpha=0.5) + 
  scale_shape_manual(values=c(15,16,17,18,19,20,21,22)) + 
  geom_text_repel(data=scores.ble, aes(x=NMDS1,y=NMDS2,label=rownames(scores.ble))) + theme_bw()


plot_13 <- ggplot()  + geom_point(data=scores.data,
                                  aes(x=NMDS1,y=NMDS3,
                                      colour=Origin, shape=Origin),
                                  size=2, alpha=0.5) + 
  scale_shape_manual(values=c(15,16,17,18,19,20,21,22)) + 
  geom_text_repel(data=scores.ble, aes(x=NMDS1,y=NMDS3,label=rownames(scores.ble))) + theme_bw()

p <- ggarrange(plot_12, plot_13, labels = "auto", common.legend = TRUE, legend = "bottom")

ggsave(filename = opts$out, width = 4*3,height = 2*3, plot = p)
