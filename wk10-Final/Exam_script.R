#import data
pData <- read.csv("/cloud/project/wk5/TCGA_BRCA_clinical_data.csv", row.names=1)
eData <- read.csv("/cloud/project/wk5/TCGA_BRCA_mRNA_expression.csv", row.names=1)

#boxplot(eData)
tumor_data <- eData[, names(eData) %in% pData$Sample_ID_Tumor]

# Q1
# Please construct a linear regression model with ER IHC (ER_Status_By_IHC) as the input and “overall survival months” as the output. 
# Calculate the 95% confidence interval for the regression coefficients. Explain the coefficients, their 95% CI, and the associated p-value for TMB. 
# (Only consider IHC positive and negative records, and remove NA, and indeterminate records).

#filter df to be rows where ER_statue is Pos/Neg only, select columns ER/Overall survival months
#ers.osm.df <- pData[pData$ER_Status_By_IHC %in% c("Positive", "Negative"), c("ER_Status_By_IHC", "Overall_Survival_Months")]
ers.osm.df <- pData[pData$ER_Status_By_IHC %in% c("Positive", "Negative") & 
                      !is.na(pData$Overall_Survival_Months) & 
                      !is.na(pData$TMB_nonsynonymous), 
                    c("ER_Status_By_IHC", "Overall_Survival_Months", "TMB_nonsynonymous")]
colnames(ers.osm.df) <- c("ER", "OSM", "TMB")
#categrorical variable to factor for linear modeling
ers.osm.df$ER <- as.factor(ers.osm.df$ER)
#linear regression: Independent: ER status by ICH (categorical/binary), Dependent: Overall survival rate (continuous)
ers.osm.lm <- lm(OSM~ER + TMB, ers.osm.df)

#summary of lm
summary(ers.osm.lm)

#calc 95 CIs
ci <- confint(ers.osm.lm)

#Extract coefficients/CIs and plot
coefs <- coef(ers.osm.lm)
ci_df <- data.frame(
  term = names(coefs),
  estimate = coefs,
  lower = ci[, 1],
  upper = ci[, 2]
)

# Basic CI plot
plot(1:nrow(ci_df), ci_df$estimate, ylim = range(ci_df$lower, ci_df$upper),
     pch = 19, xaxt = "n", xlab = "", ylab = "Coefficient Estimate",
     main = "Coefficient Estimates with 95% CI")
arrows(1:nrow(ci_df), ci_df$lower, 1:nrow(ci_df), ci_df$upper,
       angle = 90, code = 3, length = 0.1)
axis(1, at = 1:nrow(ci_df), labels = ci_df$term)
abline(h = 0, col = "red", lty = 2)


