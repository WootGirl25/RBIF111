

#####################
#### Week 6 code ####
#####################

#########################################
####  Week 6 Notes Part 1 Resampling ####
#########################################
######################
#### Code Chunk 1 ####
######################
library(ALL); data(ALL)
x.age <- pData(ALL)$age                         # extract observations for age and sex
x.sex <- pData(ALL)$sex
x.keep <- !is.na(x.age)&!is.na(x.sex)
x.age <- x.age[x.keep]                          # remove NA’s from the data
x.sex <- x.sex[x.keep]
diff.ori <- mean(x.age[x.sex=="M"]) -
  mean(x.age[x.sex=="F"])                       # difference in original sample
diff.sim <- numeric()
for ( i in 1:10000 ) {
  x.tmp <- sample(x.age)                        # in this call, sample() simply reshuffles
  diff.sim[i] <- mean(x.tmp[x.sex=="M"]) - 
    mean(x.tmp[x.sex=="F"])                     # difference in reshuffled
}
sum(abs(diff.sim) >= abs(diff.ori)) / 10000     # brute-force p-value
t.test(x.age[x.sex=="M"],
       x.age[x.sex=="F"],var.equal=T)$p.value

######################
#### Code Chunk 2 ####
######################
# random sample from normal; this is our “measured data”:
x <- rnorm(100)
v <- numeric(10000)         # reserve the vector of length 10K
for ( n in 1:10000 ) {      # resamplings: bootstrap 10K times
  # new sample x1: resampling with replacement; the size of the sample,
  # and thus its statistical power, is going to be the same, but due
  # to replacement a few randomly chosen points from the original data
  # will be dropped and replaced by additional copies of other points
  x1 <- sample(x,replace=T)
  v[n] <- mean(x1)          # calculate the mean of bootstrapped sample
}
sd(v)                       # standard deviation of our resampled mean estimates (SEM)
sd(x)/10

######################
#### Code Chunk 3 ####
######################
library(boot)
MF.age.diff <- function(x,i) {
  age.m <- x[i,"age"][x[i,"sex"]=="M"]
  age.f <- x[i,"age"][x[i,"sex"]=="F"]
  mean(age.m)-mean(age.f)
}
x.df.tmp <- data.frame(age=x.age,sex=x.sex)
boot.res <- boot(x.df.tmp,
                 statistic=MF.age.diff,10000,strata=x.sex)
boot.ci(boot.res,type="norm")$normal
t.test(x.age[x.sex=="M"],
       x.age[x.sex=="F"],var.equal=T)$conf.int

###############################################
####  Week 6 Notes Part 2 Multiple Testing ####
###############################################
######################
#### Code Chunk 1 ####
######################
pvals.200.same <- numeric()
pvals.200.diff <- numeric()
for (i in 1:200) {
  x <- rnorm(10)
  y <- rnorm(10) # x/y: control/disease measurements for no-change genes
  w <- rnorm(10) # w/z: control/disease measurements for changing genes
  z <- rnorm(10,mean=1)
  pvals.200.same[i] <- t.test(x,y)$p.value
  pvals.200.diff[i] <- t.test(w,z)$p.value
}
oldpar <- par(mfrow=c(3,1))
hist(pvals.200.same,breaks=20,xlim=c(0,1))
hist(pvals.200.diff,breaks=20,xlim=c(0,1))
hist(c(pvals.200.same,pvals.200.diff),breaks=20,xlim=c(0,1))
par(oldpar)

######################
#### Code Chunk 2 ####
######################
oldpar <- par(mfrow=c(3,1))
pval.cutoff <- seq(0,1,by=0.05)
n.same <- sapply(pval.cutoff,function(x) sum(pvals.200.same<x))
n.diff <- sapply(pval.cutoff,function(x) sum(pvals.200.diff<x))
qval <- n.same/(n.same+n.diff)
plot(pval.cutoff,n.same,pch=19,type='b',xlab="P-value cutoff",
     ylab="# false positives",main="")
plot(pval.cutoff,n.diff,pch=19,type='b',xlab="P-value cutoff",
     ylab="# true positives",main="")
plot(pval.cutoff,qval,pch=19,type='b',xlab="P-value cutoff",
     ylab="Q-value",main="")
par(oldpar)

######################
#### Code Chunk 3 ####
######################
pval.cutoff <- c(pvals.200.same,pvals.200.diff)
n.same <- sapply(pval.cutoff,function(x) sum(pvals.200.same<x))
n.diff <- sapply(pval.cutoff,function(x) sum(pvals.200.diff<x))
qval <- n.same/(n.same+n.diff)
plot(pval.cutoff,qval,xlab="t-test pvalue",
     ylab="q-value",cex.axis=1.7,cex.lab=1.7,cex=0.8)

######################
#### Code Chunk 4 ####
######################
library(qvalue)
oldpar <- par(mfrow=c(3,2))
plot(hist(pvals.200.same,plot=F,breaks=20),xlab="t-test p-value",
     main="Both samples from N(0,1)")
plot(hist(pvals.200.diff,plot=F,breaks=20),
     xlab="t-test p-value",main="One from N(0,1), another - N(1,1)")
plot(sort(qvalue(pvals.200.same)$qvalues),ylab="FDR")
# qvalue(pvals.200.diff)
# [1] "ERROR: The estimated pi0 <= 0. Check that you have valid p-values
# or use another lambda method."
# [1] 0
plot(sort(qvalue(pvals.200.diff,lambda=0.5)$qvalues),ylab="FDR")

######################
#### Code Chunk 5 ####
######################
# just reproducing old code:
pval.cutoff <- c(pvals.200.same,pvals.200.diff)
n.same <- sapply(pval.cutoff,function(x) sum(pvals.200.same<x))
n.diff <- sapply(pval.cutoff,function(x) sum(pvals.200.diff<x))
qval <- n.same/(n.same+n.diff) # exact q-values, we know the truth!
# here new part starts: estimation; suppose we do not know the
# truth and just ran qvalue on the whole dataset:
qval1 <- qvalue(pval.cutoff)$qvalues
oldpar=par(mfrow=c(1,2))
plot(pval.cutoff,qval1,xlab="p-value",ylab="q-value",cex=0.8)
plot(qval,qval1,xlab="Exact q-value",ylab="Estimated q-value")
abline(a=0,b=1,col='red')








