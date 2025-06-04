#wk9 

#download raw series counts - use rnaseq data
counts_data <- read.table("GSE119290_Readhead_2018_RNAseq_gene_counts.txt", header = TRUE, sep = "\t", row.names = 1)
#download phenotypic data
geo <- getGEO("GSE119290", GSEMatrix = TRUE)
pheno <- pData(geo[[1]])
save(pheno, file = "GSE119290_pheno.Rda")

boxplot(counts_data)
boxplot(counts_data, ylim=c(0,4000)) #var vastly different

####################################
############ QUESTION 2 ############
####################################

## FILTER GENES BY VARIANCE - NEED TO SELECT TOP 100, 1000 MOST VARIABLE GENES
# Calculate variance for each gene
gene_vars <- apply(counts_data, 1, var)

# Get top 100 and top 1000 most variable genes
top100_genes <- names(sort(gene_vars, decreasing = TRUE))[1:100]
top1000_genes <- names(sort(gene_vars, decreasing = TRUE))[1:1000]

counts_top100 <- counts_data[top100_genes, ]
counts_top1000 <- counts_data[top1000_genes, ]

##CALCULATE PCA ON RAW COUNTS
# Transpose: samples as rows, genes as columns
pca_raw_100 <- prcomp(t(counts_top100), scale. = TRUE)
pca_raw_1000 <- prcomp(t(counts_top1000), scale. = TRUE)

#plot PC's by variance explained
oldpar <- par(mfrow = c(2,2))
#top 100
pca_raw_100.var <- pca_raw_100$sdev^2
pca.var.per <- round(pca_raw_100.var/sum(pca_raw_100.var)*100,1)
barplot(pca.var.per, xlab="PCA", ylab="% var", main="all: %var/PCA_top1000") #all samples
#samples contributing >5% 1-5
barplot(pca.var.per[1:6], xlab="PCA", ylab="% var", main="~>5%: %var/PCA_top100")
#top 1000
pca_raw_1000.var <- pca_raw_1000$sdev^2
pca.var.per <- round(pca_raw_1000.var/sum(pca_raw_1000.var)*100,1)
barplot(pca.var.per, xlab="PCA", ylab="% var", main="all: %var/PCA_top1000") #all samples
#samples contributing >5% 1-5
barplot(pca.var.per[1:6], xlab="PCA", ylab="% var", main="~>5% %var/PCA_top1000")
par(oldpar)


## CALCULATE EXPLAINED VARIANCE 
# Function to get number of PCs explaining at least a threshold of variance
explained_pcs <- function(pca, threshold) {
  # calc the variance explained by each principal component (PC)
  var_explained <- (pca$sdev^2) / sum(pca$sdev^2)
  total <- 0
  num_pcs <- 0
  #add up explained var for each pc one by one
  for (v in var_explained) {
    total <- total + v
    num_pcs <- num_pcs + 1
    #once we reach 50/75% explained, break and return the number of pc's that contribute
    #since the PCs are listed in order, numbers returned will align with top pcs
    if (total >= threshold) { 
      break
    }
  }
  return(num_pcs)
}

#call explained_pcs on top_100 and top_100, with 50 and 75% explained variance
pc100.50perc <- explained_pcs(pca_raw_100, 0.5)
pc100.75perc <- explained_pcs(pca_raw_100, 0.75)
pc1000.50perc <- explained_pcs(pca_raw_1000, 0.5)
pc1000.75perc <- explained_pcs(pca_raw_1000, 0.75)

cat("Top 100 genes: number of PCs for 50% variance:", pc100.50perc, "; 75% variance:", pc100.75perc, "\n")
cat("Top 1000 genes: number of PCs for 50% variance:", pc1000.50perc, "; 75% variance:", pc1000.75perc, "\n")

####  3D Scatterplot
# color by treatment (DMSO, LOX, MPB)
library(scatterplot3d)
#sample names in counts_data and pheno are different formats = "Sample_LI.01" vs "Sample_LI-01"
# Fix sample name formatting for matching - samples not in the same order in data/pheno
fixed_names <- gsub("\\.", "-", colnames(counts_data))
#vector of treatment type that matches order of counts_data
annotate <- pheno[match(fixed_names, pheno$title), "treatment:ch1"]

# convert annotation to a factor and assign color
annotate_factor <- as.factor(annotate)
colors <- as.numeric(annotate_factor)

#plot
oldpar <- par(mfrow = c(2,1))
scatterplot3d(
  pca_raw_100$x[,1], pca_raw_100$x[,2], pca_raw_100$x[,3],
  color = colors,
  pch = 19,
  main = "pca_raw_100 (by treatment group)",
  xlab = "PC1", ylab = "PC2", zlab = "PC3"
)
legend(
  "topright",
  legend = levels(annotate_factor),
  col = 1:length(levels(annotate_factor)),
  pch = 19
)
scatterplot3d(
  pca_raw_1000$x[,1], pca_raw_1000$x[,2], pca_raw_1000$x[,3],
  color = colors,
  pch = 19,
  main = "pca_raw_1000 (by treatment group)",
  xlab = "PC1", ylab = "PC2", zlab = "PC3"
)
legend(
  "topright",
  legend = levels(annotate_factor),
  col = 1:length(levels(annotate_factor)),
  pch = 19
)
par(oldpar)
##by disease status
# annotate_disease <- pheno[match(fixed_names, pheno$title), "diagnosis:ch1"]
# annotate_factor.d <- as.factor(annotate_disease)
# colors.d <- as.numeric(annotate_factor.d)
# scatterplot3d(
#   pca_raw_100$x[,1], pca_raw_100$x[,2], pca_raw_100$x[,3],
#   color = colors.d,
#   pch = 19,
#   main = "pca_raw_100 (disease/control)",
#   xlab = "PC1", ylab = "PC2", zlab = "PC3"
# )
# legend(
#   "topright",
#   legend = levels(annotate_factor.d),
#   col = 1:length(levels(annotate_factor.d)),
#   pch = 19)

## NORMALIZE DATA AND REPEAT
# Simple normalization: log-transform (add pseudocount to avoid log(0))
norm_counts <- log2(counts_data + 1)
# Repeat steps 2-5 for normalized data
gene_vars_norm <- apply(norm_counts, 1, var)
top100_genes_norm <- names(sort(gene_vars_norm, decreasing = TRUE))[1:100]
top1000_genes_norm <- names(sort(gene_vars_norm, decreasing = TRUE))[1:1000]
norm_top100 <- norm_counts[top100_genes_norm, ]
norm_top1000 <- norm_counts[top1000_genes_norm, ]

pca_norm_100 <- prcomp(t(norm_top100), scale. = TRUE)
pca_norm_1000 <- prcomp(t(norm_top1000), scale. = TRUE)

norm.pc100.50perc <- explained_pcs(pca_norm_100, 0.5)
norm.pc100.75perc <- explained_pcs(pca_norm_100, 0.75)
normpc1000.50perc <- explained_pcs(pca_norm_1000, 0.5)
norm.pc1000.75perc <- explained_pcs(pca_norm_1000, 0.75)

cat("normalized top 100 genes: number of PCs for 50% variance:", norm.pc100.50perc, "; 75% variance:", norm.pc100.75perc, "\n")
cat("normalized top 1000 genes: number of PCs for 50% variance:", normpc1000.50perc, "; 75% variance:", norm.pc1000.75perc, "\n")

#plot
oldpar <- par(mfrow = c(2,2))
scatterplot3d(
  pca_norm_100$x[,1], pca_norm_100$x[,2], pca_norm_100$x[,3],
  color = colors,
  pch = 19,
  main = "pca_norm_100 (by treatment group)",
  xlab = "PC1", ylab = "PC2", zlab = "PC3"
)
legend(
  "topright",
  legend = levels(annotate_factor),
  col = 1:length(levels(annotate_factor)),
  pch = 19
)
scatterplot3d(
  pca_raw_100$x[,1], pca_raw_100$x[,2], pca_raw_100$x[,3],
  color = colors,
  pch = 19,
  main = "pca_raw_100 (by treatment group)",
  xlab = "PC1", ylab = "PC2", zlab = "PC3"
)
legend(
  "topright",
  legend = levels(annotate_factor),
  col = 1:length(levels(annotate_factor)),
  pch = 19
)
scatterplot3d(
  pca_norm_1000$x[,1], pca_norm_1000$x[,2], pca_norm_1000$x[,3],
  color = colors,
  pch = 19,
  main = "pca_norm_1000 (by treatment group)",
  xlab = "PC1", ylab = "PC2", zlab = "PC3"
)
legend(
  "topright",
  legend = levels(annotate_factor),
  col = 1:length(levels(annotate_factor)),
  pch = 19
)
scatterplot3d(
  pca_raw_1000$x[,1], pca_raw_1000$x[,2], pca_raw_1000$x[,3],
  color = colors,
  pch = 19,
  main = "pca_raw_1000 (by treatment group)",
  xlab = "PC1", ylab = "PC2", zlab = "PC3"
)
legend(
  "topright",
  legend = levels(annotate_factor),
  col = 1:length(levels(annotate_factor)),
  pch = 19
)
par(oldpar)

####################################
############ QUESTION 3 ############
####################################
# First part of qn:
# Perform hierarchical clustering with top 100 and 1000 genes with highest variance as well as all genes in the selected data set. 
# Visually compare and describe changes in the membership in the several top level clusters for each number of the genes chosen. 

#### HC for top 100, 1000, and all genes ####
#make list of gene sets so can loop and do all at once
gene_sets <- list(
  top100 = counts_top100,
  top1000 = counts_top1000,
  all = counts_data
)

clust_results <- list() #for clustering results

oldpar <- par(mfrow = c(1, 3)) 
for (set in names(gene_sets)) {
  matrix <- gene_sets[[set]]
  d <- dist(t(matrix)) #dist calculates distances b/w rows, for patiens must transpose
  hc <- hclust(d, method = "complete")
  clust_results[[set]] <- hc
  plot(hc, main = paste("Dendrogram:", set), xlab = "", sub = "", cex = 0.7)
}
par(oldpar)

### Discuss -Visually compare top level clusters

#pt 2:
# Repeat this analysis using several clustering metrics including spearman correlation, 
# ward, ward.D, ward.D2, single, complete, average, mcquitty, median or centroid. 
# Compare these results, describe how each clustering method works, and compare the results to PCA results obtained above.

##CHOICES: ward.D2 + Euclidean, average(UPGMA) + Euclidean, Spearman + Complete linkage
oldpar <- par(mfrow = c(3, 3)) 
for (set in names(gene_sets)) {
  matrix <- gene_sets[[set]]
  clust_results[[set]] <- list()
  
  #distance= Eucilidan for complete, ward.D2 and average
  d.euc <- dist(t(matrix))
  
  #linkage=complete
  # clust.ec <- hclust(d.euc, method = "complete")
  # clust_results[[set]][["complete"]] <- clust.ec
  # plot(clust.ec, main = paste(set, "Euclidean + complete"), xlab = "", sub = "", cex = 0.7)
  
  #linkage= ward.D2 
  clust.wardd2 <- hclust(d.euc, method = "ward.D2")
  clust_results[[set]][["ward.D2"]] <- clust.wardd2
  plot(clust.wardd2, main = paste(set, "Euclidean + ward.D2"), xlab = "", sub = "", cex = 0.7)
  
  #linkage= average 
  clust.avg <- hclust(d.euc, method = "average")
  clust_results[[set]][["average"]] <- clust.avg
  plot(clust.avg, main = paste(set, "Euclidean + average"), xlab = "", sub = "", cex = 0.7)
  
  #distance= Spearman + linkage= complete 
  d.spear <- as.dist(1 - cor(matrix, method = "spearman"))
  clust.spear <- hclust(d.spear, method = "complete")
  clust_results[[set]][["spearman"]] <- clust.spear
  plot(clust.spear, main = paste(set, "Spearman + complete"), xlab = "", sub = "", cex = 0.7)
}
par(oldpar)

#Describe -Compare these results, describe how each clustering method works, and compare the results to PCA results obtained above.


####################################
############ QUESTION 4 ############
####################################

*Create data slices*
  ```{r}
#order genes by variance - previously calculted variance in Qn2
ordered_counts <- counts_data[order(gene_vars, decreasing = TRUE),]

#find exponential slices, 256^2 is larger than number of genes, will have to cut short the range of the last splice to match the number of genes
slice_sizes <- c(4)
while (tail(slice_sizes,1) < nrow(ordered_counts)){
  nextsize <- tail(slice_sizes,1)^2 #square the last size in the vector
  slice_sizes <- c(slice_sizes, nextsize) #add to vector
}
#make length of last slice == nrow, it will make it the index of last row - then can select into groups
slice_sizes[length(slice_sizes)] <- nrow(ordered_counts); slice_sizes #check

#create slices (use lapply since slices are in a vector)
data_slices <- lapply(slice_sizes, function(size){ordered_counts[1:size,]}) #creates a list of each data slice (genes)

#output:
# [1]     4    16   256 26364
```

*Perform clustering and plot histograms to determine cut size*
  ```{r}
# 4a. Perform clustering and plot histograms (do NOT cut yet)
dendrograms <- lapply(data_slices, function(slice) {
  hcwd2 <- hclust(dist(t(slice)), method = "ward.D2")
  hist(hcwd2$height, breaks = 50, main = paste("Hist of merge heights -", nrow(slice), "genes"), xlab = "height")
  return(hcwd2)
})


```
Looks like they all drop off at about 400,000 - will use this height as the cut size, it will be uniform for each data slice.

*Cut dendrograms, combine into a matrix for counting, count the number of times individual tree leafs are identified in the same branch across all slices.*
  ```{r}
cut_height <- 400000
cluster_list <- lapply(dendrograms, function(hcwd2) {
  cutree(hcwd2, h = cut_height)
})

# combine each vector in cluster lists into a matrix (samples x slices) for easier counting
sample_names <- colnames(counts_data)
cluster_matrix <- sapply(cluster_list, function(clusters) clusters[sample_names]) #reorder each vector in cluster_lists to match order of sample_names
# cluster_matrix now has samples as rows and slices as columns, and each cell [i, j] shows the branch for sample i in slice j (branch numbers are arbitary labels assigned by cutree() for each slice)

# for each sample (patient), count how many times it is assigned to its most common cluster across all slices
leaf_stability <- apply(cluster_matrix, 1, function(x) {
  max(table(x)) #for each row(patient) what is the maximum number of times it had the same label? Creates a contingency table and selects the maximum value.
})

# Print the stability count for each sample -leaf stability gives the most times that sample had the same cluster label across all 4 slices. if =4, means in the same branch each time.
cat("Counts for each sample, showing the number of times that sample (tree leaf) appeared in the same branch across all 4 slices: \n", leaf_stability)
```
#output:
#Counts for each sample, showing the number of times that sample (tree leaf) appeared in the same branch across all 4 slices: 
#4 2 2 2 2 2 2 2 2 3 2 3 2 2 2 3 2 1 2 2 2 1 2 1 1 1 1 1 1 2 2 2 2 2 1 1 4 4 2 2 1 1 2 2

*Find the tree with the greatest number of leaves that are similar to the rest of the trees (most common branch across slices)*
  ```{r}
# for each sample, find its most common cluster  across all slices
#Repeats the previous code, but this time for each sample (row) finds the name of the cluster with the maximum value, instead of returning the highest value.
most_common_cluster <- apply(cluster_matrix, 1, function(x) {
  as.integer(names(which.max(table(x))))
})

#for each slice, count how many samples match their most common cluster
#for each column (slice set) in the matrix, compare each samples cluster label in that slice to its most common cluster label across all slices, then sum the number of samples that match to find the column(slice) with the greatest number of matches.
slice_stability <- apply(cluster_matrix, 2, function(col) {
  sum(col == most_common_cluster)
})

#Find which slice has the greatest number of stable leaves (is equal to the most common cluster the most number of times) 
best_slice_index <- which.max(slice_stability)
best_slice_size <- slice_sizes[best_slice_index]

# print how many samples matched in each slice
cat("Matches in each slice are", slice_stability)
cat("\nMost stable dendrogram is for", best_slice_size, "genes (slice", best_slice_index, ")\n")
#return dendrogram for splice 1
best_dendro <- dendrograms[[best_slice_index]]
print("Dendrogram for most stable slice:")
plot(best_dendro, main = paste("Most stable dendrogram:", best_slice_size, "genes"))

```
#output:
#Matches in each slice are 38 31 8 8
# Most stable dendrogram is for 4 genes (slice 1 )
# [1] "Dendrogram for most stable slice:"


