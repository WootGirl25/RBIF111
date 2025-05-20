#Find gene with greatest association outcome for age (using whole filtered data set)
#all patient characteristics in one column, separate Disease Free Survival Time, and Censored into new columns, select only non-censored rows b/c for censored cases the true event time is unknown and and will affect the analysis.

#extract & create new column for DFS_Time and DFS_Cens
pheno$DFS_Time <- as.numeric(sub(".*DFS_Time: ([^;]+);.*", "\\1", pheno$characteristics_ch1))
pheno$DFS_Cens <- as.numeric(sub(".*DFS_Cens: ([^;]+);.*", "\\1", pheno$characteristics_ch1))

#find where NA's have been added in, check original pheno$characteristics_ch1 to see what they look like.
cens.na.idx <- is.na(pheno$DFS_Cens)
time.na.idx <- is.na(pheno$DFS_Time)
#are they on the same rows?
identical(cens.na.idx, time.na.idx)

#yes, lets see what they look like in the original pData
pheno$characteristics_ch1[cens.na.idx][1:15]#originals aren't labeled differently - just NA. Will exclude from analysis.

#Get create data frame of expression values where time is not censored or NA
dfst.exprs.df <-  exprs_data[, pheno$DFS_Cens==0 & !is.na(pheno$DFS_Time)]
#vector of disease free survival times whre time is not consored or NA
dfs_time <- pheno[pheno$DFS_Cens==0 & !is.na(pheno$DFS_Time),]$DFS_Time

#For association we can reverse Y~X to X~Y
library(limma)
dfs.design <- model.matrix(~dfs_time) #2 columns, 50 rows - rows are each sample
dfs.exprs.model <- lmFit(dfst.exprs.df, dfs.design)
fit2 <- eBayes(dfs.exprs.model)
best.wholemodel <- topTable(eBayes(fit2, coef = "dfs_time"))

#output
#> best.wholemodel <- topTable(eBayes(fit2, coef = "dfs_time"))
Error in eBayes(fit2, coef = "dfs_time") : 
  unused argument (coef = "dfs_time")
Error during wrapup: not that many frames on the stack
Error: no more error handlers available (recursive errors?); invoking 'abort' restartbest.wholemodel <- topTable(eBayes(fit2, coef = "dfs_time"))

# Assume: 
# dfst.exprs.df = genes (rows) x samples (columns)
# dfs_time = numeric vector, length = number of samples

# Transpose so genes are columns for apply over columns
exprs_t <- t(dfst.exprs.df)

# For each gene, fit DFS_Time ~ gene_expression and extract R-squared
gene_r2 <- apply(exprs_t, 2, function(gene_expr) {
  summary(lm(dfs_time ~ gene_expr))$r.squared
})

# Find the gene with the highest R-squared
best_gene_idx <- which.max(gene_r2)
best_gene_name <- rownames(dfst.exprs.df)[best_gene_idx]
best_r2 <- gene_r2[best_gene_idx]

cat("Best predictor gene:", best_gene_name, "\nR-squared:", best_r2, "\n")

#qn3:

**For n=50**
```{r}
#create df to store gene names and r2 values
gene.r2 <- data.frame(gene= character(), r2= numeric())
#bootstrapping: 50 sims - where each sim splits the data into new groups:

#split data set into 5 groups
n.xval <- 5
r2.xval <- c()
set.seed(123)
xval.grps <- sample((1:dim(eData_filtered)[2])%%n.xval+1)
#create design matrix
dmatrix <- cbind(rep(1, length(dfs_time)), dfs_time)
#loop through number of groups
for (i.xval in 1:n.xval){
  #For training groups - fit linear model:
  exprs.train <- eData_filtered[,xval.grps!=i.xval] #eData of training set
  dmatrix.train <- dmatrix[xval.grps!=i.xval,] 
  dfs.fit.train <- lmFit(exprs.train, dmatrix.train)
  best.gene <- rownames(topTable(eBayes(dfs.fit.train), coef = "dfs_time"))[1] #best fit gene
  #best.gene <- rownames( topTable( eBayes(dfs.fit.train), dfs_time))[1] 
  cat(best.gene, " ", fill = i.xval==n.xval)
  
  #use best gene to fit lm on training data still
  tmp.df <- data.frame(G=eData_filtered[best.gene,], DFST=dfs_time) #temp data frame for convenience (all data train and test)
  lm.xval <- lm(DFST~G, tmp.df[xval.grps!=i.xval,]) #use only training data
  
  #predict values with test set
  test.pred <- predict(lm.xval, tmp.df[xval.grps==i.xval,]) #select rows of tmp.df that are the test group set (current i.xval)
  r2.xval <- c(r2.xval, (test.pred-tmp.df[xval.grps==i.xval, "DFST"])^2)
}
##next step is to bootstap this code (nsims=50) need to work out how to extract each gene with its r2 values, save to another tmp df within loop (cols = gene, r2(vector?)), then at end of loop add the tmp df to end of global gene.r2 df. Then can count gene names, select top 5.
##________

#bootstrapping
bootstrap_cross_validation <- function(eData_filtered, dfs_time, n.sims = 50, n.xval=5){
  total.best.genes <- c() #to store across bootstrap cycles
  total.r2 <- list()
  #create design matrix
  dmatrix <- cbind(rep(1, length(dfs_time)), dfs_time)
  
  #each loop of bootstrap
  for (sim in 1:n.sims){
    #assign samples to groups
    xval.grps <- sample((1:dim(eData_filtered)[2])%%n.xval+1)
    sim.best.genes <- c() #best genes of this round of bootstrap
    sim.r2 <- c() #r2 values for this round of bootstrap
    
    #loop through each of the 5 cross val groups within each bootstrap cycle
    for (i.xval in 1:n.xval){
      #For training groups - fit linear model:
      exprs.train <- eData_filtered[,xval.grps!=i.xval] #eData of training set
      dmatrix.train <- dmatrix[xval.grps!=i.xval,] 
      dfs.fit.train <- lmFit(exprs.train, dmatrix.train)
      #best gene for i.xval-th loop
      best.gene <- rownames(topTable(eBayes(dfs.fit.train), coef = "dfs_time"))[1] #best fit gene
      #add to best genes for this simulation
      sim.best.genes <- c(sim.best.genes, best.gene)
      
      
      #use best gene to fit lm on training data 
      tmp.df <- data.frame(G=eData_filtered[best.gene,], DFST=dfs_time) #temp data frame for convenience (uses train and test data)
      lm.xval <- lm(DFST~G, tmp.df[xval.grps!=i.xval,]) #use only training data
      
      #predict values with test group
      test.pred <- predict(lm.xval, tmp.df[xval.grps==i.xval,]) #select rows of tmp.df that are the test group set (current i.xval)
      sim.r2 <- c(sim.r2, (test.pred-tmp.df[xval.grps==i.xval, "DFST"])^2)
    }
    
    #add this simulations best genes/r2 to final vector/list for entirety of bootstrapping
    total.best.genes <- c(total.best.genes, sim.best.genes)
    total.r2[[sim]] <- sim.r2 #assign the sim.r2 as a list that correlates with the round of bootstrap
  }
  
  #return total.best.genes and total.r2 as a list so can access each 
  list(total.best.genes= total.best.genes, total.r2= total.r2)
}

## call function for n.sims=50
results.50 <- bootstrap_cross_validation(eData_filtered, dfs_time, n.sims=50)

#Find top 5 genes across all simulations - use table to find counts
n50.genes <- table(results.50$total.best.genes)
n50.top.genes <- sort(n50.genes, decreasing = TRUE)[1:5]
#calculate MSE
#total.r2 is a list containing vectors of sim r2s, calculate the MSE for each sim so we have a range of data to plot
n50.MSE <- sapply(results.50$total.r2, mean) #sapply for lists

#call function with n.sims=300
results.300 <- bootstrap_cross_validation(eData_filtered, dfs_time, n.sims=300)
n300.genes <- table(results.300$total.best.genes)
n300.top.genes <- sort(n300.genes, decreasing = TRUE)[1:5]
n300.MSE <- sapply(results.300$total.r2, mean)

#compare the two
cat("Top 5 genes after 50 simulations:\n")
print(names(n50.top.genes))
cat("\nCounts:\n")
print(n50.top.genes)

cat("\nTop 5 genes after 300 simulations:\n")
print(names(n300.top.genes))
cat("\nCounts:\n")
print(n300.top.genes)

boxplot(list(`n=50` = n50.MSE, `n=300` = n300.MSE),
        ylab = "Mean Squared Error",
        main = "Comparison of MSE for 50 vs 300 Simulations",
        col = c("blue", "green"))
