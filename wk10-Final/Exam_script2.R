#import data
##### FOR POSIT CLOUD #####
pData <- read.csv("/cloud/project/wk5/TCGA_BRCA_clinical_data.csv", row.names=1)
eData <- read.csv("/cloud/project/wk5/TCGA_BRCA_mRNA_expression.csv", row.names=1)

#### LOCAL #####
pData <- read.csv("~/Documents/RBIF111/wk10-Final/TCGA_BRCA_clinical_data.csv", row.names=1)
eData <- read.csv("~/Documents/RBIF111/wk10-Final/TCGA_BRCA_mRNA_expression.csv", row.names=1)

#boxplot(eData)
boxplot(eData, ylim=c(0,3000))
#Data is raw not normalized - boxplot with limited y axis shows different medians and IQRs of gene expression over samples.
---


########################
###### QUESTION 1 ######
########################

#filter df to be rows where ER_statue is Pos/Neg only, select columns ER/Overall survival months
ers.osm.df <- pData[pData$ER_Status_By_IHC %in% c("Positive", "Negative") & 
                      !is.na(pData$Overall_Survival_Months) & 
                      !is.na(pData$TMB_nonsynonymous), 
                    c("ER_Status_By_IHC", "Overall_Survival_Months", "TMB_nonsynonymous")]
colnames(ers.osm.df) <- c("ER", "OSM", "TMB")
#categrorical variable to factor for linear modeling
ers.osm.df$ER <- as.factor(ers.osm.df$ER)

#-----VIEW DISTRIBUTION OF OSM ACROSS ER GROUPS-------
# Boxplot: Overall Survival Months by ER status
boxplot(OSM ~ ER, data=ers.osm.df,
        main="Overall Survival by ER Status",
        ylab="Overall Survival Months",
        xlab="ER Status",
        col=c("lightblue", "pink"))

#---------LINEAR MODEL +/- TMB------------
#linear regression: Independent: ER status by ICH (categorical/binary) + TMB (continuous), Dependent: Overall survival rate (continuous)
#Quantifies the effect of only ER on OSM
x1.lm <- lm(OSM~ER, ers.osm.df)
# Quantifies the effect of both ER and TMB on OSM.
x2.lm <- lm(OSM~ER + TMB, ers.osm.df)

#summary of lms
summary(x1.lm)
summary(x2.lm)

#compare lm with/without TMB using anova
anova(x1.lm, x2.lm)

# Scatterplot: TMB vs Overall Survival Months, colored by ER status
plot(ers.osm.df$TMB, ers.osm.df$OSM,
     col=as.numeric(ers.osm.df$ER),
     pch=19,
     xlab="TMB (nonsynonymous)",
     ylab="Overall Survival Months",
     main="TMB vs Overall Survival Months")
legend("topright", legend=levels(ers.osm.df$ER),
       col=1:2, pch=19, title="ER Status")
# Add regression lines for each ER group
for (lev in levels(ers.osm.df$ER)) {
  idx <- ers.osm.df$ER == lev
  abline(lm(OSM ~ TMB, data=ers.osm.df[idx,]), col=which(levels(ers.osm.df$ER)==lev), lwd=2)
}

#-----------calc 95 CIs----------
x1.ci <- confint(x1.lm); x1.ci
x2.ci <- confint(x2.lm); x2.ci


# Extract coefficients and CIs for both models
coefs1 <- coef(x1.lm)
ci1 <- confint(x1.lm)
df1 <- data.frame(
  term = names(coefs1),
  estimate = coefs1,
  lower = ci1[, 1],
  upper = ci1[, 2],
  model = "ER only"
)

coefs2 <- coef(x2.lm)
ci2 <- confint(x2.lm)
df2 <- data.frame(
  term = names(coefs2),
  estimate = coefs2,
  lower = ci2[, 1],
  upper = ci2[, 2],
  model = "ER + TMB"
)

# Combine
ci_df <- rbind(df1, df2)
ci_df$term_model <- paste(ci_df$term, ci_df$model, sep=": ")

# Plot
plot(1:nrow(ci_df), ci_df$estimate, ylim = range(ci_df$lower, ci_df$upper),
     pch = 19, xaxt = "n", xlab = "", ylab = "Coefficient Estimate",
     main = "Coefficient Estimates with 95% CI (Both Models)")
arrows(1:nrow(ci_df), ci_df$lower, 1:nrow(ci_df), ci_df$upper,
       angle = 90, code = 3, length = 0.1)
axis(1, at = 1:nrow(ci_df), labels = ci_df$term_model, las=2, cex.axis=0.4)
abline(h = 0, col = "red", lty = 2)



########################
###### QUESTION 2 ######
########################

library(survival)

#filter data
cox.df <- pData[pData$ER_Status_By_IHC %in% c("Positive", "Negative") &
                  !is.na(pData$Overall_Survival_Months) &
                  !is.na(pData$Overall_Survival_Status) &
                  !is.na(pData$TMB_nonsynonymous), 
                c("ER_Status_By_IHC", "Overall_Survival_Months", "Overall_Survival_Status", "TMB_nonsynonymous")]
colnames(cox.df) <- c("ER", "OSM", "Status", "TMB")

#categrorical variable to factor for cox regression
cox.df$ER <- as.factor(cox.df$ER)

#survival status to binary ("1:DECEASED" = 1, "0:LIVING" = 0)
cox.df$Status <- ifelse(cox.df$Status == "1:DECEASED", 1, 0)

#fit cox model ER only
x1.cox <- coxph(Surv(OSM, Status) ~ ER, data = cox.df)
#fit cox ER + TMB
x2.cox <- coxph(Surv(OSM, Status) ~ ER + TMB, data = cox.df)

summary(x1.cox)
summary(x2.cox)

#compare both cox models with anova
anova(x1.cox, x2.cox)

#get 95% CIs for hazard ratios
x1.cox.ci <- exp(confint(x1.cox)); x1.cox.ci
x2.cox.ci <- exp(confint(x2.cox)); x2.cox.ci

#-----plot Kaplan-Meier survival curves by ER status----
surv_obj <- Surv(cox.df$OSM, cox.df$Status)
fit_km <- survfit(surv_obj ~ ER, data = cox.df)
plot(fit_km, col = c("blue", "red"), lwd = 2,
     xlab = "Months", ylab = "Survival Probability",
     main = "Kaplan-Meier Survival by ER Status")
legend("bottomleft", legend = levels(cox.df$ER), col = c("blue", "red"), lwd = 2)

########################
###### QUESTION 3 ######
########################

#discussion - see notes

########################
###### QUESTION 4 ######
########################

#See from boxplot of downloaded data set that data is raw - did not need to normalize for qns 1 and 2 as we were using observed clinical data, not gene expression values with technical variance.
# need to normalize data, BUT to avoid data leakage need to perform on post split training set:
#1. extract eData for tumor samples only
#2. split data in training (60%) and testing (40%) sets.
#3. For each gene: calc median expression in traning set, assign high or low expression label based on training median, run cox in training set, save p-vals
#4. multiple testing correction
#5. select top 5 genes from training set
#6. for these genes run cox and plot curves from testing set data.

#1. select tumor samples only & make sure samples are in the same order in both expression data and clinical data
common.smpls <- intersect(colnames(eData), pData$Sample_ID_Tumor) #restrict samples in eData to only the tumor_samples as listed in pData
texprs <- eData[, common.smpls]
tpdata <- pData[pData$Sample_ID_Tumor==common.smpls,]
rownames(tpdata) <- tpdata$Sample_ID_Tumor #make tumorID the rownames for simplicity

#remove nas, create new columns (status = binary, OSM = survival months) - keep together at end for ease
tpdata <- tpdata[!is.na(tpdata$Overall_Survival_Months) & !is.na(tpdata$Overall_Survival_Status),] #select tumor samples without NA values for the cox survival object
tpdata$STATUS <- ifelse(tpdata$Overall_Survival_Status == "1:DECEASED", 1, 0) #convert whether event of death has occurred from string to binary
tpdata$OSM <- tpdata$Overall_Survival_Months
#subset texprs to match tpdata
texprs <- texprs[,rownames(tpdata)] #if any samples have NA in survival data from clinical dataframe, remove those samples from the expression data.

#2. split into train/test
set.seed(1)
train.index <- sample(1:nrow(tpdata), size = 0.6*nrow(tpdata)) #sample without replacement 60% of number of samples - rounds down to whole number
tpdata.train <- tpdata[train.index,] #select rows corresponding to sampled indices
tpdata.test <- tpdata[-train.index,] #select rows not corresponding to sampled indices
texprs.train <- texprs[, rownames(tpdata.train)] #filter expression data to training
texprs.test <- texprs[, rownames(tpdata.test)]
#check to make sure all samples are included
as.numeric(dim(texprs.train)[2]) + as.numeric(dim(texprs.test)[2]) == as.numeric(dim(tpdata)[1])

#3. For each gene (loop) in training set find median expression (dont want model to know median value of whole data set),
# partition training samples into high or low groups if the sample value exceeds the median value
# fit cox model: outcome training survival months & status, sample labeled as high/low (testing whether high/low expression patient group for each gene is correlated with the hazard of the event occurring)
# save p value for each gene

pvals <- c()

#training samples only
for (gene in rownames(texprs.train)){
  i.gene.exprs <- as.numeric(texprs.train[gene,]) #expression values for i-th gene in all training samples - as numeric or median will error
  i.gene.median <- median(i.gene.exprs, na.rm = TRUE) #median of values for that gene in training samples
  smpl.labels <- ifelse(i.gene.exprs > i.gene.median, "high", "low") #each sample value for that gene compared to median, labeled as high or low
  #smpl.labels is just a vector of "high" or "low" not linked to values anymore
  if (length(unique(smpl.labels))<2){
    next #any gene that has all samples in either high or low, will not be assessed.
  }
  i.cox <- coxph(Surv(tpdata.train$OSM, tpdata.train$STATUS) ~ smpl.labels)
  pvals[gene] <- summary(i.cox)$coefficients[1,5]
}
pvals.fdr <-  p.adjust(pvals, method = "fdr")
save(pvals, file = "pvals.Rda")
sort(pvals)[1:10]
sort(pvals.fdr)[1:10]
#explain nothing significant - looked up to use uncorrected values to continue


#### not sure which version to use yet
# 
# # Transpose texprs.train so samples are rows, genes are columns
# exprs_t <- t(texprs.train)
# highlow_df <- as.data.frame(exprs_t)
# 
# # For each gene, create high/low labels based on training median
# for (gene in colnames(highlow_df)) {
#   med <- median(highlow_df[[gene]], na.rm = TRUE)
#   highlow_df[[gene]] <- ifelse(highlow_df[[gene]] > med, "high", "low")
# }
# 
# # Add survival info
# highlow_df$OSM <- tpdata.train$OSM
# highlow_df$STATUS <- tpdata.train$STATUS
# 
# library(survival)
# pvals <- c()
# for (gene in setdiff(colnames(highlow_df), c("OSM", "STATUS"))) {
#   df <- data.frame(
#     label = factor(highlow_df[[gene]], levels = c("low", "high")),
#     OSM = highlow_df$OSM,
#     STATUS = highlow_df$STATUS
#   )
#   if (length(unique(df$label)) < 2) {
#     pvals[gene] <- NA
#     next
#   }
#   fit <- coxph(Surv(OSM, STATUS) ~ label, data = df)
#   pvals[gene] <- summary(fit)$coefficients[1, 5]
# }
# 
# pvals.fdr <- p.adjust(pvals, method = 'fdr')
# sort(pvals)[1:10]
# sort(pvals.fdr)[1:10]


############HAVING PROBLEMS, CONTINUE ANYWAY AND COME BACK##############

#4. select top 5 uncorrected - proceed with test set
top5 <- names(sort(pvals)[1:5])

#5 use these top genes in testing set data + plot KM curves
texprs.test <- texprs.test[, rownames(tpdata.test)]
pvals.test <- c()
for (gene in top5){
  median <- median(as.numeric(texprs.train[gene,]), na.rm = TRUE) #still use training median - dont let model see new data
  label.test <- ifelse(texprs.test[gene,] > median, "high", "low")
  label.test <- factor(label.test, levels = c("low", "high"))
  cox.test <- coxph(Surv(tpdata.test$OSM, tpdata.test$STATUS)~label.test)
  pvals.test[gene] <- summary(cox.test)$coefficients[1,5]

  #plot
  plot(survfit(Surv(tpdata.test$OSM, tpdata.test$STATUS)~label.test),
       col = c("blue", "red"), lwd = 2,
       main = paste("KM Curve for", gene, "(Test Set)"),
       xlab = "Months", ylab = "Survival Probability")
  legend("bottomleft", legend = c("Low", "High"), col = c("blue", "red"), lwd = 2)
}

pvals.test
pval.df <- data.frame(train= pvals[top5], train.fdr=pvals.fdr[names(pvals[top5])], test= pvals.test[names(pvals[top5])])
pval.df

########################
###### QUESTION 5 ######
########################
#load data
clinical.data <- read.delim("~/Documents/RBIF111/wk10-Final/brca_tcga_pan_can_atlas_2018_clinical_data.tsv")
rownames(clinical.data) <- clinical.data$Sample.ID
download.edata <- read.delim("~/Documents/RBIF111/wk10-Final/data_mrna_seq_v2_rsem.txt")

#any missing values? No
unique(is.na(clinical.data$Overall.Survival..Months.))
unique(is.na(clinical.data$Overall.Survival.Status))


#filter data
cbio.5 <- download.edata
cbio.5 <- cbio.edata[cbio.edata$Hugo_Symbol %in% top5,]
rownames(cbio.5) <- cbio.5$Hugo_Symbol
cbio.5 <- cbio.5[, -c(1:2)]

clinical.data$STATUS <-  ifelse(clinical.data$Overall.Survival.Status == "1:DECEASED",1,0)
cbio.pdata <- data.frame(sample= clinical.data$Sample.ID, OSM= clinical.data$Overall.Survival..Months., STATUS= clinical.data$STATUS)
rownames(cbio.pdata) <- cbio.pdata$sample
rownames(cbio.pdata) <- gsub("-", ".", rownames(cbio.pdata))

common.cbio <- intersect(colnames(cbio.edata), rownames(cbio.pdata)) 
cbio.5 <- cbio.5[, common.cbio]
cbio.pdata <- cbio.pdata[common.cbio,]

#steps:
#Assign High/Low Expression Groups in cbio.5 - use median from training set
#Run cox, plot KM curves
#save top5
top5 <- rownames(cbio.5)

pvals.cbio <- c()
for (gene in top5) {
  # Use the training set median for this gene
  train.median <- median(as.numeric(texprs.train[gene, ]), na.rm = TRUE)
  exprs.cbio <- as.numeric(cbio.5[gene, ])
  labels.cbio <- ifelse(exprs.cbio > train.median, "high", "low") #for all 1082 samples
  #labels.cbio <- factor(labels.cbio, levels = c("low", "high"))
  
  # Only run if both groups are present
  if (length(unique(labels.cbio)) < 2) {
    pvals.cbio[gene] <- NA
    next
  }
  
  cox.cbio <- coxph(Surv(cbio.pdata$OSM, cbio.pdata$STATUS) ~ labels.cbio)
  pvals.cbio[gene] <- summary(cox.cbio)$coefficients[1, 5]
  
  # Plot KM curve
  plot(survfit(Surv(cbio.pdata$OSM, cbio.pdata$STATUS) ~ labels.cbio),
       col = c("blue", "red"), lwd = 2,
       main = paste("KM Curve for", gene, "(cbioportal)"),
       xlab = "Months", ylab = "Survival Probability")
  legend("bottomleft", legend = c("Low", "High"), col = c("blue", "red"), lwd = 2)
}

pvals.cbio
