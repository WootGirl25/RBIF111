#read csv to object
my_data <- read.csv("file.csv")

#in biobase:
pData(object) # Retrieves information on the phenotypic data and meta-data associated with an experiment
exprs(object) #access the expression and error measurements of assay data stored in an objectderived from the eSet-class

#get class of each column in table/data frame
unlist(lapply(df[,1:ncol(df)],class))

#remove all variables from environment
rm(list = ls())

#remove all variables from environment except x and y
rm(list=setdiff(ls(), c("x", "y")))

#remember to install ALL package before you can access it
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("ALL")
library(ALL) 
data(ALL)

#if you have a list of column names and want to extract YOU DONT HAVE TO USE __ %in% ___:
#where smpls is a list of sample names of interest, results in df that selects ERBB2 gene 
#exprsn levels for samples in the vector.
protData[protData$X == "ERBB2", smpls]

# Rename columns by column index (e.g., columns 2 and 4)
colnames(df)[c(2, 4)] <- c("new_name1", "new_name2")
