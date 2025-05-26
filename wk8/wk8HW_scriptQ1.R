#wk8 HW Script

library(GEOquery)
geodata <- getGEO("GSE10072", GSEMatrix = TRUE)
eset <- geodata[[1]]
eData <- exprs(eset)
pheno <- pData(eset)

save(eData, file = "GSE10072eData.Rda")
save(pheno, file = "GSE10072pData.Rda")

#boxplot
boxplot(eData)
#medians and IQRs all similar - normalization confirmed

#filter pheno to current smoker and never smoker
smk_and_nonsk <- pheno$`Cigarette Smoking Status:ch1`=="Never Smoked" | pheno$`Cigarette Smoking Status:ch1`=="Current Smoker"
pheno_sns <- pheno[smk_and_nonsk,]
eData_sns <- eData[,smk_and_nonsk]

#categorical variable is sex = Male/Female
#continuous variable is gene expression use eData (table of expression data genes are rows, samples are columns)

#logistic regression - change gender to factor with two levels.
gender <- as.factor(pheno_sns$`Gender:ch1`)

#initialize variables to store p-values and gene names
pvals <- numeric()
gene_names <- rownames(eData_sns)

#loop through every gene, run glm(gender~gene), save pvalue
for (i in 1:nrow(eData_sns)){
  gene.i <- eData_sns[i,] #select i-th row all samples
  log.model <- glm(gender~gene.i, family = binomial)
  #save pvalue (2nd row is gene variable)
  pvals[i] <- summary(log.model)$coefficients[2,"Pr(>|z|)"]
}

#create df to sort & plot
gender.pvals <- data.frame(gene= gene_names, pval= pvals)
gender.pvals.sorted <- gender.pvals[order(gender.pvals$pval),]
#print 5 most significant
gender.pvals.sorted[1:5,]

#histogram of pvals
hist(gender.pvals$pval)

######################################
######### leave-n-out ##################
#----as loop -----
##leave-n-out (n=1)
set.seed(123) # for reproducibility
n.reps <- 100
n.genes <- nrow(eData_sns) #test sample for now
n.samples <- ncol(eData_sns)

# Store mean and variance of p-values for each gene
pval_means <- numeric()
pval_vars <- numeric()

for (i in 1:n.genes) {
  gene.i <- eData_sns[i,]
  pvals_cv <- replicate(n.reps, {
    leave_out <- sample(1:n.samples, 1)
    gene_train <- gene.i[-leave_out]
    gender_train <- gender[-leave_out]
    log.model <- glm(gender_train ~ gene_train, family = binomial)
    summary(log.model)$coefficients[2, "Pr(>|z|)"]
  })
  pval_means[i] <- mean(pvals_cv, na.rm=TRUE)
  pval_vars[i] <- var(pvals_cv, na.rm=TRUE)
}

# Create data frame for results
cv_results <- data.frame(
  gene = gene_names,
  mean_pval = pval_means,
  var_pval = pval_vars
)

#-------As Function -----------
leave_n_out_cv <- function(exprs_data, gender, gene_names, n.reps = 100, seed = 123) {
  set.seed(seed) # for reproducibility
  
  n.genes <- nrow(exprs_data) 
  n.samples <- ncol(exprs_data)
  
  # Store mean and variance of p-values for each gene
  pval_means <- numeric(n.genes)
  pval_vars <- numeric(n.genes)
  
  for (i in 1:n.genes) {
    gene.i <- exprs_data[i,]
    pvals_cv <- replicate(n.reps, {
      leave_out <- sample(1:n.samples, 1)
      gene_train <- gene.i[-leave_out]
      gender_train <- gender[-leave_out]
      log.model <- glm(gender_train ~ gene_train, family = binomial)
      summary(log.model)$coefficients[2, "Pr(>|z|)"]
    })
    pval_means[i] <- mean(pvals_cv, na.rm=TRUE)
    pval_vars[i] <- var(pvals_cv, na.rm=TRUE)
  }
  
  # Create data frame for results
  results_df <- data.frame(
    gene = gene_names,
    mean_pval = pval_means,
    var_pval = pval_vars
  )
  
  return(results_df)
}

# Example Usage:
# gene.pvals.norm <- leave_n_out_cv(eData_sns, gender, gene_names)

##############De-normalize 2 methods###############
### 1: represent batch effects ####
#de-normalize by adding 5 to first half of expression values
# Artificially de-normalize: add 5 to first half of samples
eData_sns_denorm <- eData_sns
eData_sns_denorm[, 1:floor(n.samples/2)] <- eData_sns_denorm[, 1:floor(n.samples/2)] + 5
# Check boxplot to see the effect
boxplot(eData_sns_denorm, main="Artificially De-normalized Data")

# Repeat cross-validation for denormalized data
#gene.pvals.denorm <- leave_n_out_cv(eData_sns_denorm, gender, gene_names)

pval_means_denorm <- numeric()
pval_vars_denorm <- numeric()

for (i in 1:n.genes) {
  gene.i <- eData_sns[i,]
  pvals_cv <- replicate(n.reps, {
    leave_out <- sample(1:n.samples, 1)
    gene_train <- gene.i[-leave_out]
    gender_train <- gender[-leave_out]
    log.model <- glm(gender_train ~ gene_train, family = binomial)
    summary(log.model)$coefficients[2, "Pr(>|z|)"]
  })
  pval_means_denorm[i] <- mean(pvals_cv, na.rm=TRUE)
  pval_vars_denorm[i] <- var(pvals_cv, na.rm=TRUE)
}

gene.pvals.denorm1 <- data.frame(
  gene = gene_names,
  mean_pval = pval_means_denorm,
  var_pval = pval_vars_denorm
)

### Denorm method 2: Shift scale by adding a constant - 5 ####
eData_sns_denorm2 <- eData_sns + 5
#plot to see differences with original data
oldpar <- par(mfrow = c(1, 3))
boxplot(eData_sns, main="normalized")
boxplot(eData_sns_denorm, main="denorm constatnt to half")
boxplot(eData_sns_denorm2, main="denorm with constant")
par(oldpar)

# Repeat leave-n-out for eData_sns_denorm2
gene.pvals.denorm2 <- leave_n_out_cv(eData_sns_denorm2, gender, gene_names)

#------Changed variable names in function - adjust variables--------
# gene.pvals.norm <- cv_results
# gene.pvals.denorm1 <- cv_results_denorm

#######Comparisons of norm/denorm pvalues#######
# Show top 5 genes by mean p-value of each resampling df
print("Top 5 genes sorted by lowest mean p-value of:\n")
print("Normalized leave-n-out resampling:\n")
gene.pvals.norm[order(gene.pvals.norm$mean_pval), ][1:5,]
print("Synthetic de-normalized (+5 to half of samples) leave-n-out resampling:\n")
gene.pvals.denorm1[order(gene.pvals.denorm1$mean_pval), ][1:5,]
print("Synthetic de-normalized (+5 to all samples) leave-n-out resampling:\n")
gene.pvals.denorm1[order(gene.pvals.denorm2$mean_pval), ][1:5,]

#plot mean x var for norm and denorm data - doesnt show much
# oldpar <- par(mfrow = c(3, 1))
# plot(gene.pvals.norm$mean_pval, gene.pvals.norm$var_pval, pch = 20, col = "blue",
#      xlab = "Mean p-val", ylab = "Variance p-val", main = "Mean vs. Variance Normalized")
# plot(gene.pvals.denorm1$mean_pval, gene.pvals.denorm1$var_pval, pch = 20, col = "red",
#      xlab = "Mean p-val", ylab = "Variance p-val", main = "Mean vs. Variance de-normalized (half)")
# plot(gene.pvals.denorm2$mean_pval, gene.pvals.denorm2$var_pval, pch = 20, col = "green",
#      xlab = "Mean p-val", ylab = "Variance p-val", main = "Mean vs. Variance de-normalized (whole)")
# par(oldpar)

#histogram
oldpar <- par(mfrow = c(3, 2))
hist(gene.pvals.norm$mean_pval, breaks = 50, col = "blue", 
     main = "Normalized Mean p-val", xlab = "mean pval/gene")
hist(gene.pvals.norm$var_pval, breaks = 50, col = "blue", 
     main = "Normalized p-val Variance", xlab = "p-val var/gene")
hist(gene.pvals.denorm1$mean_pval, breaks = 50, col = "red", 
     main = "De-normalized (half) Mean p-val", xlab = "Mean pval/gene")
hist(gene.pvals.denorm1$var_pval, breaks = 50, col = "red", 
     main = "De-normalized (half) p-val Variance", xlab = "p-val var/gene")
hist(gene.pvals.denorm2$mean_pval, breaks = 50, col = "green", 
     main = "De-normalized (whole)Mean p-val", xlab = "Mean pval/gene")
hist(gene.pvals.denorm2$var_pval, breaks = 50, col = "green", 
     main = "De-normalized (whole) p-val Variance", xlab = "p-val var/gene")
par(oldpar)

#boxplots
oldpar <- par(mfrow = c(1, 2))
boxplot(gene.pvals.norm$mean_pval, gene.pvals.denorm1$mean_pval, gene.pvals.denorm2$mean_pval, 
        main = "mean p-vals", col=c("blue", "red", "green"))
boxplot(gene.pvals.norm$var_pval, gene.pvals.denorm1$var_pval, gene.pvals.denorm2$var_pval,
        main = "var p-vals", col=c("blue", "red", "green"))
par(oldpar)

#plot means and variances between norm/denorm data
oldpar <- par(mfrow = c(2, 2))
plot(
  gene.pvals.norm$mean_pval, gene.pvals.denorm1$mean_pval,
  xlab = "Mean p-values(normalized)",
  ylab = "Mean p-values(half de-normalized)",
  pch = 16, col = "blue"
)
abline(0, 1, col = "red", lwd = 2) # diagonal line for reference

plot(
  gene.pvals.norm$var_pval, gene.pvals.denorm1$var_pval,
  xlab = "Variance of p-values(Normalized)",
  ylab = "Variance of p-value (half de-normalized)",
  pch = 16, col = "blue"
)
abline(0, 1, col = "red", lwd = 2)
plot(
  gene.pvals.norm$mean_pval, gene.pvals.denorm2$mean_pval,
  xlab = "Mean p-values(normalized)",
  ylab = "Mean p-values(whole de-normalized)",
  pch = 16, col = "blue"
)
abline(0, 1, col = "red", lwd = 2) # diagonal line for reference

plot(
  gene.pvals.norm$var_pval, gene.pvals.denorm2$var_pval,
  xlab = "Variance of p-values(Normalized)",
  ylab = "Variance of p-value (whole de-normalized)",
  pch = 16, col = "blue"
)
abline(0, 1, col = "red", lwd = 2)
par(oldpar)