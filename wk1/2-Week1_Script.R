

#####################
#### Week 1 code ####
#####################

####################################################
####  Week 1 Notes Part 3 Arithmetics and Types ####
####################################################
######################
#### Code Chunk 1 ####
######################
1:10

######################
#### Code Chunk 2 ####
######################
x <- 1
for ( i in 1:3 ) x+i

######################
#### Code Chunk 3 ####
######################
x <- 1
for ( i in 1:3 ) print(x+i)

######################
#### Code Chunk 4 ####
######################
c(1,5,7,2,19,179) # this is a sequence of individual numbers
c(1:5, 19, 3:8) # it is possible to concatenate sequences together

######################
#### Code Chunk 5 ####
######################
plot(1:100/pi,sin(1:100/pi),type="b",col=c("red","green",
                                             "blue"),pch=1:5, xlab="x [rad]",ylab="sin(x)")
######################
#### Code Chunk 6 ####
######################
1:10/pi

######################
#### Code Chunk 7 ####
######################
mode(1)
mode("abc")
mode(TRUE)
mode(7+5i)
x<-5.5
mode(x)
x<-"text"
mode(x)

######################
#### Code Chunk 8 ####
######################
3^1000
-3^1000
1/0

######################
#### Code Chunk 9 ####
######################
Inf - Inf # note that we can type Inf as a “value” in a command
3^1000 - 3^1000 # same thing. Subtracting Inf from Inf
0/0

#######################
#### Code Chunk 10 ####
#######################
NA==1 # logical expression: is NA (missing value) equal to 1?
1+NA
max(c(NA, 4, 7)) # max() takes a sequence and returns maximum element
max(c(NA, 4, 7), na.rm=T) # use additional optional argument to max
NA | TRUE
NA & TRUE
sort(c(5,3,NA,7)) # sort() takes a sequence and sorts it
sort(c(5,3,NA,7),na.last=T) # ask sort() to keep NA, not discard them

#######################
#### Code Chunk 11 ####
#######################
NA == NA # no, comparing NA to NA directly does not help
is.na(NA) # this is how we check if an object is NA!!
is.null(NULL) # check if the object/value is NULL
is.nan(NaN) # check if the object/value is NaN
is.infinite(Inf) 

#############################################
####  Week 1 Notes Part 4 DataStructures ####
#############################################
######################
#### Code Chunk 1 ####
######################
y <- 2:6; y # shortcut for seq(2,6,by=1) – see below
z <- seq(1,1.4,by = 0.1); z # general way to create a sequence

######################
#### Code Chunk 2 ####
######################
x <- c(5.2, 1.7, 6.3); x
# we continue after the example commands shown previously – y was 
# defined there!
x.y <- c(x,y); x.y

######################
#### Code Chunk 3 ####
######################
w <- rnorm(5); w

######################
#### Code Chunk 4 ####
######################
length(y); length(1); length(NA); length(NULL)

######################
#### Code Chunk 5 ####
######################
c(NULL, NULL,1,2,NA)

######################
#### Code Chunk 6 ####
######################
clrs <- c("red","blue","gray","pink","cyan"); clrs

######################
#### Code Chunk 7 ####
######################
clrs[1]
j<-1
clrs[j]

######################
#### Code Chunk 8 ####
######################
clrs[2:4]              # can select a subset!!
k<-c(1,3,5); clrs[k]   # subset does not have to be continuous
i <- c(1,1,5); clrs[i] # same element can be extracted multiple 
# times if the indexing vector happens to 
# have repetitions!
clrs[c(-2,-3)]         # negative index specifies element to EXCLUDE

######################
#### Code Chunk 9 ####
######################
z <- integer(0); length(z) # one way to create an empty vector
clrs[z]                    # empty index selects empty subset!
clrs[6]                    # out of bounds
clrs[c(2,6,3)]             # select subset with one index out of bounds
clrs[c(2,NA,3)]

#######################
#### Code Chunk 10 ####
#######################
y <- 2:6; y                 # create a vector (and print it); this part we know:
names(y) <- clrs; y         # we can assign names to elements! Print and see
y[c("blue","pink","green")] # now we can also access by name 

#######################
#### Code Chunk 11 ####
#######################
clrs <- c("red","blue","gray","pink","cyan"); clrs 
clrs[c(T,F,F,T,F)]   # selects elements at ‘TRUE’ positions
clrs[c(T,F,F,T,F,T)] # last T out of bounds: returns NA
clrs[c(T,F,F,T,F,F)] 
clrs[c(T,F,F,T,NA)]  # NA is logical!! 

#######################
#### Code Chunk 12 ####
#######################
clrs[c(T,F)] # if indexing vector is short, it is recycled!
clrs[T]      # oooops, what happened here?

#######################
#### Code Chunk 13 ####
#######################
x <- c(12,-3,7,-5,6)
x[x>0] # selects only positive elements from x!

#######################
#### Code Chunk 14 ####
#######################
clrs[[2]] # for vectors, it’s the same as clrs[2]
clrs[[c(2,3)]] # cannot use multiple indexes at once with [[ ]] ! 

#######################
#### Code Chunk 15 ####
#######################
clrs <- c("red","blue","gray","pink","cyan"); clrs
clrs[c(1,3)] <- c("scarlet", "black"); clrs
x<-c(3:8,NA); x
x > 5           # let’s just check first what x>5 returns
x[x>5] <- -1; x # NOTE: recycling of right hand side occurred here

#######################
#### Code Chunk 16 ####
#######################
x<-c(3:8,NA); x
x+1:7
x+1:4
exp(x)

#######################
#### Code Chunk 17 ####
#######################
xx <- c(-2:2,NA); xx    # generate a vector to play with
xx > 0                  # element by element comparison; gives T if element is > 0
any(xx > 0)             # is at least one element of xx greater than 0? 
all(xx > 0)             # are all elements of xx greater than 0?
any(xx > 2)             # is at least one element of xx greater than 2?
sum(xx > 0)             # sum of all elements of xx
sum(xx > 0, na.rm=TRUE) # number of positive elems in xx, ignoring NA
is.element(0,xx)        # is 0 present among elements of xx?
is.element(c(2,10),xx)  # are 2 and 10 present among elements of xx?
match(c(0,-2,10),xx)    # at what positions do 0, -2, 10 occur in xx?

#######################
#### Code Chunk 18 ####
#######################
yy <- c(3,-3,5,-5,4,4)     # create a vector
sort(yy)                   # sort vector
order(yy)                  # find sorting order for the argument
yy[order(yy)]              # sorting=reshuffling a vector into its sorting order
rev(yy[order(yy)])         # revert the order of the argument
yy[order(yy,decreasing=T)] # reshuffle using decreasing sorting order
sort(yy,decreasing=T)      # same thing, but shorter: just decreasing sort
(xx > -1) & (xx < 2)       # Important! &, not &&! xx from previous snippet
xx[(xx > -1) & (xx < 2) ]

#######################
#### Code Chunk 19 ####
#######################
m <- matrix(1:12, nrow=4, byrow = T); m 
y <- -1:2
m.new <- m + y; m.new
mode(m)
class(m)

#######################
#### Code Chunk 20 ####
#######################
m.new                             # this matrix was created in the previous snippet 
m.new[,2]                         # all rows, column 2; 
m.new[c(1,3),]                    # rows 1,3; all columns
m.new[-c(1,3),]                   # discard rows 1,3; select all columns
m.new[-c(2,4),-c(2,4)]            # discard rows 2,4 and columns 2,4
t(m)                              # transpose, i.e. rows become columns and columns become rows
dim(m)                            # very useful: returns dimensions of a matrix (nrows, ncols)
length(m)                         # What is length of a matrix?? Can you explain this??
rownames(m)                       # rows of matrix m have no names so far… 
rownames(m) <- c('a','b','c','d') # assign names to rows of a matrix
colnames(m) <- c('x','y','w')     # assign names to columns

#######################
#### Code Chunk 21 ####
#######################
a <- list()
a[[1]] <- "first el"
a[[2]] <- 2
a[[5]] <- 1:3
a

#######################
#### Code Chunk 22 ####
#######################
b <- list(name="some name",
          num.id=1234,
          some.array=c(5,6,7),
          a.mat=matrix(1:2,nrow=2,ncol=3),
          another.list=list(a="a",b=1))
b[2]                 # “vector”-like access: slice
class(b[2])          # slice is still a list
b[[2]]               # direct element access
class(b[[2]])        # this time we retrieved value
b$num.id             # explicit access by name
b$numid              # there is no ‘numid’ slot in the list. No error, alas.
b[["num.id"]]        # access by character value, same as b$num.id
z <-"num.id"; b[[z]] # but double-bracket can also use variable!

###############################################
####  Week 1 Notes Part 5 Programming in R ####
###############################################
######################
#### Code Chunk 1 ####
######################
x <-c(3,5)
if ( any(x > 4) ) "apples" else "oranges" # curly braces optional
if ( any(x > 4) ) {                       # multi-line form – must use braces x <x+3 print(x)
} else {
  x <- x*2
  print(x)
}

######################
#### Code Chunk 2 ####
######################
if(c(T,F)) { } # empty command to execute, so the result is NULL

######################
#### Code Chunk 3 ####
######################
x<-c(3,5,1,7)
ifelse(x>4,"apples","oranges")

######################
#### Code Chunk 4 ####
######################
for ( i in 1:3 ) print(paste("iteration",i))
i # oooops, i is now defined!
i <- 1; while(i < 4) { print(i); i <- i+1 }

######################
#### Code Chunk 5 ####
######################
my.max <-function ( x, na.rm = F ) { 
  x.max <- Inf 
  for ( xx in x ) {
    if ( is.na(xx) ) { 
      if ( na.rm ) { 
        next 
      } else { 
        return(NA) 
      }
    }
    if(xx > x.max) {
      x.max <- xx
    }
  }
  x.max # return value = value of the last command
}

###############################################
####  Week 1 Notes Part 5 Programming in R ####
###############################################
######################
#### Code Chunk 1 ####
######################
# if (!require("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# BiocManager::install("limma")
library(limma)

######################
#### Code Chunk 2 ####
######################
data(ALL)

######################
#### Code Chunk 3 ####
######################
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
# Alternatively, one can use the source command:
source("http://www.bioconductor.org/biocLite.R")

######################
#### Code Chunk 4 ####
######################
ls()

######################
#### Code Chunk 5 ####
######################
x <- numeric(5) # create variable x
ls()            # list objects in the session: x is there…
rm(x)           # delete object x…
ls()            # …and recheck objects in the current session: x is gone

######################
#### Code Chunk 6 ####
######################
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("ALL")

######################
#### Code Chunk 7 ####
######################
library(ALL) 
data(ALL)

######################
#### Code Chunk 8 ####
######################
dim(pData(ALL))      # 128 samples (patients), 21 characteristics for each
colnames(pData(ALL)) # what data are available for each patient?
dim(exprs(ALL))      # expression of 12625 genes (rows) measured in 128 patients (columns)
pData(ALL)[1:3,1:5]  # let’s take a peek at small part of pData table
exprs(ALL)[1:5,1:3]  # expression data; rows=genes, columns=patients

######################
#### Code Chunk 9 ####
######################
class(ALL) # all is an object of class ExpressionSet
class(pData(ALL)) # pData returns data frame with clinical info
class(pData(ALL)[,1]) # 1st column of clinical info is a char vector
class(pData(ALL)[,"age"]) # column named “age” is a numeric vector
class(pData(ALL)$sex) # data frames (and lists) allow access with ‘$’
unlist(lapply(pData(ALL)[,1:12],class)) # apply class to each element
table(pData(ALL)[,"sex"])
varMetadata(ALL) # show list of all variables

#######################
#### Code Chunk 10 ####
#######################
getwd()                     # prints current working directory
setwd("J:/RBIF 111 Master/Week 1") # change working dir; see also dir.create
write.table(pData(ALL)[1:5,1:5], "ALLtmp.txt", quote=F, sep="\t", col.names=T, row.names=F)
all.tmp <- read.table("ALLtmp.txt",sep="\t", header=T)
all.tmp

#######################
#### Code Chunk 11 ####
#######################
colnames(pData(ALL))[1:5]              # column names in the original data
colnames(all.tmp)                      # column names in the table we read back: ok
unlist(lapply(pData(ALL)[1:5], class)) # column data types, original
sapply(all.tmp,class)                  # column data types, read back

#######################
#### Code Chunk 12 ####
#######################
all.tmp$diagnosis <as.character(all.tmp$diagnosis)

#####################################################################
####  Week 1 Notes Part 7 Descriptive and Inferential Statistics ####
#####################################################################
######################
#### Code Chunk 1 ####
######################
library(ALL) 
data(ALL)
table(pData(ALL)$sex)         # count levels (M and F) in column ‘sex’
pie(table(pData(ALL)$sex))
table(pData(ALL)$CR)          # tally original remission data for patients
pie(table(pData(ALL)$CR))

######################
#### Code Chunk 2 ####
######################
old.par <- par(ps=20)
stripchart(ALL$age,method="jitter")
stripchart(ALL$age,method="stack",cex.axis=1.5)
stem(ALL$age)
dotchart(ALL$age)
par(old.par)

######################
#### Code Chunk 3 ####
######################
hist(ALL$age)

######################
#### Code Chunk 4 ####
######################
plot(ALL$age,type="p",main="ALL$Age",ylab="Years")
plot(sort(ALL$age),type="p",main="ALL$Age",ylab="Years")
plot(ALL$age,type="h",main="ALL$Age",ylab="Years")

######################
#### Code Chunk 5 ####
######################
mean(1:5); mean(c(1:5,100))
median(1:5); median(c(1:5,100))

######################
#### Code Chunk 6 ####
######################
sd(ALL$age,na.rm=T) # standard deviation of patients’ ages in ALL
mad(ALL$age,na.rm=T)

######################
#### Code Chunk 7 ####
######################
range(ALL$age,na.rm=T) # range of all observed values, min to max
IQR(ALL$age,na.rm=T) # interquartile distance

######################
#### Code Chunk 8 ####
######################
quantile(ALL$age,na.rm=T)
boxplot(ALL$age)
boxplot(age~sex,ALL)












