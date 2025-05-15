##first 50 genes - limited data set for RAM & testing###

load("~/Documents/RBIF111/wk4/cord_conc.rda") #edata50 (matrix [1:50, 1:183])
load("~/Documents/RBIF111/wk4/first50rows.rda") #cord_conc (num [1:183])

# Assuming "cord_conc" is a vector of cotinine concentrations (independent variable)
# And "edata50" is a matrix where rows = genes, columns = samples (expression levels)
# Define cotinine exposure groups
quartiles <- quantile(cord_conc, probs = c(0.25, 0.50, 0.75)) # Compute quartiles
exposure_group <- cut(cord_conc, 
                      breaks = c(-Inf, quartiles[1], quartiles[3], Inf), 
                      labels = c("Low", "Moderate", "High"))
# Compute average gene expression per sample
avg_expression <- colMeans(edata50)
# Create a dataframe
df <- data.frame(Sample = colnames(edata50), 
                 AvgExpression = avg_expression, 
                 CotinineGroup = exposure_group)
# Box plot stratified by cotinine levels
boxplot(AvgExpression ~ CotinineGroup, data = df, 
        main = "Average Gene Expression Stratified by Cotinine Levels",
        xlab = "Cotinine Exposure Group", 
        ylab = "Average Gene Expression",
        col = c("lightblue", "lightgreen", "salmon"))

#QUESTION 1
# Create an empty data frame with gene names
pvals <- data.frame(Gene = rownames(edata50))

# Compute raw p-values using apply()
pvals$raw_pval <- apply(edata50, 1, function(gene_exprs){
  # Create a data frame where gene expression aligns with cotinine levels
  df.tmp <- data.frame(G= gene_exprs, CONC = cord_conc)
  # Fit linear model
  lm.tmp <- lm(CONC ~ G, df.tmp)
  # Extract p-value from ANOVA
  anova(lm.tmp)$"Pr(>F)"[1]
})

# Apply multiple testing corrections AFTER collecting p-values
pvals$bonferroni_pval <- p.adjust(pvals$raw_pval, method = "bonferroni") #if time - raw_pval / number samples
pvals$FDR_pval <- p.adjust(pvals$raw_pval, method = "fdr") #if time, try to replace with q-value script to find FDR

# Merge back into original edata50
edata50 <- cbind(edata50, pvals[, -1])  # Drop Gene column, keep p-values

# Order genes separately for each correction type
pvals_raw <- pvals[order(pvals$raw_pval), ]
pvals_bonferroni <- pvals[order(pvals$bonferroni_pval), ]
pvals_fdr <- pvals[order(pvals$FDR_pval), ]

# Scatter plots for each p-value type
oldpar <- par(mfrow= c(1,3))
plot(-log10(pvals_raw$raw_pval), pch = 16, col = "blue", main = "Raw P-Values")
plot(-log10(pvals_bonferroni$bonferroni_pval), pch = 16, col = "red", main = "Bonferroni P-Values")
plot(-log10(pvals_fdr$FDR_pval), pch = 16, col = "green", main = "FDR P-Values")
par(oldpar)