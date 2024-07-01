#!/usr/bin/env Rscript

library(ggplot2, quietly = TRUE, warn.conflicts=FALSE)
library(dplyr, quietly = TRUE, warn.conflicts=FALSE)
library(optparse)
library(RColorBrewer)
library(reshape2)

source("workflow/scripts/multi_merge.R")

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

# Read the sample source file
profile <- profile[grep(pattern = "Eukaryota_unclassified", x = rownames(profile), invert = T),]

profile$phyla <- t(matrix(data = unlist(rownames(profile) |> strsplit("[|]")), ncol = nrow(profile), nrow = 7))[,2] |> gsub(replacement = "", pattern="p__")

profile_sub <- as.data.frame(profile |> group_by(phyla) |> summarise_all(list(sum)) )
rownames(profile_sub) <- profile_sub$phyla

subset <- c()

areas <- c("nasalcavity","oralcavity","skin","stool","vagina","ancient dental calculus")
profile_sub$phyla<-NULL
# Calculate mean phylum abundance for each body site
for (i in areas){
  a<-apply(profile_sub[,grep(metadata$body_site, pattern = i)],1, function(x) {mean(x,na.rm=TRUE)})
  subset <- cbind(subset,a)
}

colnames(subset) <- c("Nasal Cavity","Oral Cavity","Skin","Stool","Vagina","Ancient Dental Calculus")

gums <- profile_sub[,which(colnames(profile_sub) %in% c("ble004", "ble007", "ble008", "Syltholm_1"))]
rownames(gums)<-profile_sub$phyla

subset<-cbind(subset, gums)
other<-data.frame(100-colSums(subset))
colnames(other)<-"Other"
subset<-rbind(subset,t(other))
subset$phyla <- rownames(subset)
c<-melt(subset)

colnames(c)<-c("Phylum", "Origin", "Abundance")

c$Phylum<-as.character(c$Phylum)

c$Phylum[which(c$Abundance<=1)]<-"Other"
c<-c %>% group_by(Phylum,Origin) %>% summarise(Abundance=sum(Abundance))
c$Phylum <- factor(c$Phylum, levels = c("Actinobacteria",
                                        "Bacteroidetes",
                                        "Basidiomycota",
                                        "Chlamydiae",
                                        "Chloroflexi",
                                        "Euryarchaeota",
                                        "Firmicutes",
                                        "Fusobacteria",
                                        "Planctomycetes",
                                        "Proteobacteria",
                                        "Spirochaetes",
                                        "Synergistetes",
                                        "Other"))


c$Origin <- factor(c$Origin,levels=c("Vagina",
                                     "Stool",
                                     "Skin",
                                     "Nasal Cavity",
                                     "Oral Cavity",
                                     "ble007",
                                     "ble008",
                                     "ble004",
                                     "Syltholm_1",
                                     "Ancient Dental Calculus"))

# Color profiles
n <- 90
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
# Other should be black
col_vector[10] <- "black"
# Function to merge big data frames


p<- ggplot(data = c, aes(x=Origin,y=Abundance)) + 
  geom_bar(aes(fill=Phylum), stat="identity") + 
  scale_fill_manual(values=col_vector) + 
  theme_bw(base_size = 11) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(filename = opts$output, width = 4*3,height = 3*3, plot = p)


