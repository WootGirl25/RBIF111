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


# #find index of lowest pvalue
# sig.pval.i <- which.min(pvals)
# sig.gene <- gene_names[sig.pval.i] #positions same in pvals/gene_names
# sig.pval <- pvals[sig.pval.i] #save most significant pval
# 
# cat("Most significant gene", sig.gene)
# cat("\n p-value:", sig.pval)

