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