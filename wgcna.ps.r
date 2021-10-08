#!/usr/bin/env Rscript

#SBATCH --partition long
#SBATCH --cpus-per-task 10
#SBATCH --mem 30G


system('source /home/illorens/miniconda3/bin/activate r_env_wgcna')


library(tidyverse)
library(WGCNA);


# Parse in arguments to script
#"sbatch ./scripts/wgcna.irl.r --gene_table outdirAll_vst_norm.txt --out_dir outdir"

opt_list <- list(
  make_option("--gene_table", type = "character",
  help = "Input file of RNA-Seq data"),
  make_option("--out_dir", type = "character",
  help = "Directory for plots to be written to"),

  )

opt <- parse_args(OptionParser(option_list = opt_list))
inp <- opt$gene_table
outdir <- opt$outdir


# Load input file

exp_data <- read_delim(inp, delim = ",")
data2<-as.data.frame(exp_data)
colnames(data2)<-c("ID","r1_0","r2_0","r3_0",
                   "r1_0.5","r2_0.5","r3_0.5",
                   "r1_2","r2_2","r3_2",
                   "r1_4","r2_4","r3_4",
                   "r1_24","r2_24","r3_24")

row.names(data2)<-data2$ID

rld2 <-gather(data2, "treatment", "ncounts", -ID)
rld4<-spread(rld2,treatment,ncounts)

# Parse data as WGCNA tutorial recommends
datexpr0 = as.data.frame(t(rld4[, -1]));
names(datexpr0) = rld4$ID;
rownames(datexpr0) = names(rld4)[-1];

# Check for excessive missing values and ID outliers

gsg <- goodSamplesGenes(datexpr0, verbose = 3)
gsg$allOK

# Remove any genes and samples that do not pass the cut

if (!gsg$allOK){
    # Print items removed to file
    if (sum(!gsg$goodGenes) > 0){
        genes_to_remove <- (paste("Removing genes:", paste(names(datexpr0)[
        !gsg$goodGenes], collapse = "\n")))
        gfile <- paste(outdir, "removed_genes.txt", sep = "/")
        write(genes_to_remove, file = gfile)
    }
    if (sum(!gsg$goodSamples) > 0){
        samples_to_remove <- (paste("Removing samples:",
        paste(rownames(datexpr0)[!gsg$goodSamples], collapse = "\n")))
        sfile <- paste(outdir, "removed_samples.txt", sep = "/")
        write(samples_to_remove, file = sfile)
    }
    # Remove items that fail QC
    datexpr0 <- datexpr0[gsg$goodSamples, gsg$goodGenes]
}

# Cluster samples to check for outliers

sampletree <- hclust(dist(datexpr0), method = "average")
file <- paste(outdir, "sample_clustering.pdf", sep = "/")
pdf(file, width = 12, height = 9)
par(cex = 0.6)
par(mar = c(0, 4, 2, 0))
plot(sampletree, main = "Sample clustering to detect outliers", sub = "",
xlab = "", cex.lab = 1.5, cex.axis = 1.5, cex.main = 2)

# Save a table with the expression data of all the samples
Rfile <- paste(outdir, "Cleaned_data.RData", sep = "/")
save(datexpr0, file = Rfile)

options(stringsAsFactors = FALSE)

allowWGCNAThreads(nThreads = 10)

# Load previous scripts output
lfile <- paste(outdir, "Cleaned_data.RData", sep = "/")
lnames <- load(file = lfile)

powers = c(seq(4,11, by=1), seq(from = 12,30, by=2))
# Call the network topology analysis function
sft = pickSoftThreshold(datexpr0, powerVector = powers,
                        verbose = 5,networkType="signed")

# Draw a plot to allow manual picking of sft value

cex1 <- 0.9
file <- paste(outdir, "sft_testing.pdf", sep = "/")
pdf(file, height = 9, width = 12)
plot(sft$fitIndices[, 1], -sign(sft$fitIndices[, 3]) * sft$fitIndices[, 2],
xlab = "Soft Threshold (power)",
ylab = "Scale Free Topology Model Fit, signed R^2", type = "n",
main = paste("Scale independence"))
text(sft$fitIndices[, 1], -sign(sft$fitIndices[, 3]) * sft$fitIndices[, 2],
labels = powers, cex = cex1, col = "red")
abline(h=0.75,col="red")
abline(h=0.8,col="blue")
abline(h=0.9,col="green")
plot(sft$fitIndices[, 1], sft$fitIndices[, 5], xlab = "Soft Threshold (power)",
ylab = "Mean Connectivity", type = "n", main = paste("Mean connectivity"))
text(sft$fitIndices[, 1], sft$fitIndices[, 5], labels = powers, cex = cex1,
col = "red")
dev.off()

##### up to here

# Calculate adjacency
softpower=14
adjacency <- adjacency(datexpr0, power = softpower)


# Topological Overlap Matrix (TOM)

tom <- TOMsimilarity(adjacency)


disstom <- 1 - tom

# Clustering using TOM

genetree <- hclust(as.dist(disstom), method = "average")

file <- paste(outdir, "clustering_tree.pdf", sep = "/")
pdf(file, height = 9, width = 12)
sizeGrWindow(12, 9)
plot(genetree, xlab = "", sub = "", main = "Gene clustering on TOM-based
dissimilarity", labels = FALSE, hang = 0.04)
dev.off()

# Cut clustering tree into several modules
min_mod_size=30
dynamicmods <- cutreeDynamic(dendro = genetree, 
distM = disstom, deepSplit = 2,
pamRespectsDendro = FALSE, minClusterSize = min_mod_size)
table(dynamicmods)

# Plot modules on clustering tree, allows sanity check of min_mod_size value

file <- paste(outdir, "clustering_tree_with_modules.pdf", sep = "/")
pdf(file, height = 9, width = 12)
dynamiccolours <- labels2colors(dynamicmods)
table(dynamiccolours)
plotDendroAndColors(genetree, dynamiccolours, "Dynamic Tree Cut",
dendroLabels = FALSE, hang = 0.03, addGuide = TRUE, guideHang = 0.05,
main = "Gene dendrogram and module colours")
dev.off()

# Merging modules with similar expression patterns

melist <- moduleEigengenes(datexpr0, colors = dynamiccolours)
mes <- melist$eigengenes
mediss <- 1 - cor(mes)
metree <- hclust(as.dist(mediss), method = "average")
medissthres=0.30 # they choose 0.25 casuse it implies a 75% correlation but could change to 0.30

file <- paste(outdir, "clustering_tree_with_merged_modules.pdf", sep = "/")
pdf(file, height = 9, width = 12)
plot(metree, main = "Clustering of module eigengenes",
 xlab = "", sub = "")
abline(h = medissthres, col = "red")
dev.off()
merge <- mergeCloseModules(datexpr0,
 dynamiccolours, cutHeight = medissthres,
verbose = 3)
mergedcolours <- merge$colors
mergedmes <- merge$newMEs

# Plot a comparison of merged and unmerged modules

file <- paste(outdir, "clustering_tree_compare_modules.pdf", sep = "/")
pdf(file, height = 9, width = 12)
plotDendroAndColors(genetree, cbind(dynamiccolours, mergedcolours),
c("Dynamic Tree Cut", "Merged dynamic"), dendroLabels = FALSE, hang = 0.03,
addGuide = TRUE, guideHang = 0.05)
dev.off()

# Save output for further analyses

modulecolours <- mergedcolours
colourorder <- c("grey", standardColors(50))
modulelabels <- match(modulecolours, colourorder) - 1
mes <- mergedmes
Rfile <- paste(outdir, "modules.RData", sep = "/")
save(mes, modulelabels, modulecolours, dynamiccolours, genetree, tom, file = Rfile)

#write cluster components in independent csv files
ME_genes_all<-names(datexpr0)

ME_all<-list()
for (i in unique(modulecolours)){
  ME_all[[i]]<-names(datexpr0)[modulecolours==i]
  write.csv(ME_all[[i]], file=paste0(outdir,"/genes_",i,".csv"),
            row.names = F)
}

#