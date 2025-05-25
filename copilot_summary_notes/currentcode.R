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
#pheno_sns$`Gender:ch1`=="Male"
#pheno_sns$`Gender:ch1`=="Female"

#continuous variable is gene expression use eData_sns (table of expression data genes are rows, samples are columns)
