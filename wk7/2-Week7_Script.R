

#####################
#### Week 7 code ####
#####################

###############################################
####  Week 7 Notes Part 1 Model Prediction ####
###############################################
######################
#### Code Chunk 1 ####
######################
plot(d2r.34852[,c("G", "D2R")],
     xlab="34852_g_at",
     ylab="Days-to-remission") # plot the original data, D2R vs G
lm.34852.g.at <- lm(D2R~G,d2r.34852,na.action=na.exclude) # fit model
# draw predicted (fitted) values of D2R for each value in G:
points(d2r.34852$G,
       predict(lm.34852.g.at),
       col="blue",pch=3) # plots blue crosses at fitted values
# generate some 10 points within the range spanned by vector G:
x.tmp <- pretty(d2r.34852$G,10)
new.df.ci <- data.frame(G=x.tmp) # new data to make predictions for
pred.ci <- predict(lm.34852.g.at, # predict values and confint bounds
                   new.df.ci,interval="confidence")
points(new.df.ci$G,pred.ci[,"fit"],
       col="red",type="l",lty=2) # plot the predicted values (red)
points(new.df.ci$G,pred.ci[,"lwr"],
       col="green",type="l",lty=3,lwd=2)
points(new.df.ci$G,pred.ci[,"upr"],
       col="green",type="l",lty=3,lwd=2) # plot confint bounds (green)

######################
#### Code Chunk 2 ####
######################
n.xval <- 5 # number of groups to split data into
# generate and permute group labels (i.e. assign 
# datapoints to groups 1..5 randomly):
xval.grps <- sample(1:dim(d2r.34852)[1]%%n.xval+1)
s2.xval <- numeric()
for ( i.xval in 1:n.xval ) { # for each group:
  # set group i aside as ‘test set’
  test.df <- d2r.34852[xval.grps==i.xval,]
  train.df <- d2r.34852[xval.grps!=i.xval,] # the rest is “training”
  lm.xval <- lm(D2R~G,train.df) # fit the model on the training set
  test.pred <- predict(lm.xval,test.df) # predict on test set
  s2.xval <- c(s2.xval,(test.pred-test.df$D2R)^2)
}
mse.xval <- mean(s2.xval,na.rm=T)
mse.xval
summary(lm.34852.g.at)$sigma^2

######################
#### Code Chunk 3 ####
######################
n.boot <- 100                                    # 100 bootstrap resamplings
s2.boot <- numeric()
n.obs <- dim(d2r.34852)[1]                       # number of observation (data points)
for ( i.boot in 1:n.boot ) {
  train.idx <- sample(n.obs,replace=T)           # indexes for training set
  # test set=indices not used in training set:
  test.idx <- (1:n.obs)[!(1:n.obs)%in%train.idx]
  train.df <- d2r.34852[train.idx,]              # select training data
  test.df <- d2r.34852[test.idx,]                # select test data
  lm.boot <- lm(D2R~G,train.df)                  # fit model on training set
  test.pred <- predict(lm.boot,test.df)          # predict on test set
  s2.boot <- c(s2.boot,(test.pred-test.df$D2R)^2)
}
mse.boot <- mean(s2.boot,na.rm=T)
mse.boot

############################################
####  Week 7 Notes Part 2 Design Matrix ####
############################################
######################
#### Code Chunk 1 ####
######################
library(ALL); data(ALL)
fp.df <- data.frame(fp=pData(ALL)[,"fusion protein"], 
                    g1=exprs(ALL)["1970_s_at",], 
                    g2=exprs(ALL)["1002_f_at",])
fp.df <- fp.df[!is.na(fp.df$fp),] 
table(fp.df$fp)
# try this! This is design matrix used by lm():
model.matrix(fp.df$g1~fp.df$fp) 
# the following design has all 1 in the 1st column (p190), 
# and an additional 1 
# in corresponding cols for p190/p210, p210 (that’s default for lm()),
# just the same way we defined design matrix for a 3-level variable in
# our example of Eq.(5) above:
design.lm <- cbind(p190=1, 
                   p190.p210=as.numeric(fp.df$fp == "p190/p210"),
                   p210=as.numeric(fp.df$fp == "p210"))
expr.arrays <- matrix(c(fp.df$g1,fp.df$g2),nrow=2,ncol=33,byrow=T)
# fit result is the mean of p190, and offsets from that mean for
# means of other classes:
lmFit(expr.arrays,design.lm)$coefficients
# the following design has 1 in corresponding columns ONLY,
# for each of p190,p190/p210,p210 levels:
design.1 <- cbind(p190=as.numeric(fp.df$fp == "p190"),
                  p190.p210=as.numeric(fp.df$fp == "p190/p210"),
                  p210=as.numeric(fp.df$fp == "p210")) 
# fit results=corresponding means in each class:
lmFit(expr.arrays,design.1)$coefficients

##################################################
####  Week 7 Notes Part 3 Multiple Regression ####
##################################################
######################
#### Code Chunk 1 ####
######################
library(limma);library(ALL); data(ALL)
ALL.pdat <- pData(ALL)
date.cr.chr <- as.character(ALL.pdat$date.cr)
diag.chr <- as.character(ALL.pdat$diagnosis)
date.cr.t <- strptime(date.cr.chr,"%m/%d/%Y")
diag.t <- strptime(diag.chr,"%m/%d/%Y")
days2remiss <- as.numeric(date.cr.t - diag.t)
x.d2r <- as.numeric(days2remiss)
exprs.34852 <- exprs(ALL)["34852_g_at",]
d2r.34852 <- data.frame(G=exprs.34852,D2R=x.d2r)
################################################
days2remiss <- as.numeric(date.cr.t - diag.t) # as in Note 1
ALL.exprs <- exprs(ALL)[,!is.na(days2remiss)]
days2remiss <- days2remiss[!is.na(days2remiss)]
design.matrix <- cbind(rep(1,length(days2remiss)),days2remiss)
n.xval <- 5
s2.xval <- numeric()
xval.grps <- sample((1:dim(ALL.exprs)[2])%%n.xval+1)
for ( i.xval in 1:n.xval ) {
  ALL.exprs.train <- ALL.exprs[,xval.grps!=i.xval]
  design.matrix.train <- design.matrix[xval.grps!=i.xval,]
  d2r.fit.train <- lmFit(ALL.exprs.train,design.matrix.train)
  best.gene <- rownames( topTable( eBayes(d2r.fit.train),
                                   "days2remiss") )[1]
  cat(best.gene," ",fill=i.xval==n.xval)
  tmp.df <- data.frame(G=ALL.exprs[best.gene,],D2R=days2remiss)
  lm.xval <- lm(D2R~G,tmp.df[xval.grps!=i.xval,])
  test.pred <- predict(lm.xval,tmp.df[xval.grps==i.xval,])
  s2.xval <- c(s2.xval,(test.pred- 
                          tmp.df[xval.grps==i.xval,"D2R"])^2)
}
mean(s2.xval)

######################
#### Code Chunk 2 ####
######################
exprs.35296 <- exprs(ALL)["35296_at",]; 
exprs.34852 <- exprs(ALL)["34852_g_at",]
exprs.1213 <- exprs(ALL)["1213_at",]
g3.df <- data.frame(D2R=x.d2r,G1=exprs.34852,
                    G2=exprs.35296,G3=exprs.1213)
g3.df <- g3.df[!is.na(g3.df$D2R),]
lm.g1 <- lm(D2R~G1,g3.df)
lm.g12 <- lm(D2R~G1+G2,g3.df)
summary(lm.g12)
anova(lm.g12)
anova(lm.g1,lm.g12)

######################
#### Code Chunk 3 ####
######################
lm.g13 <- lm(D2R~G1+G3,g3.df)
summary(lm.g13)$coef
anova(lm.g13)

######################
#### Code Chunk 4 ####
######################
# install.packages("scatterplot3d")
# install.packages("rgl")
library(rgl)
library(scatterplot3d)
# for ( a in 1:1800 ) {
#  x3d <- scatterplot3d(g3.df$G1, g3.df$G3, g3.df$D2R, angle=a%%360)
#  x3d$plane3d(coef(lm.g13))
#  Sys.sleep(0.01)
# }
plot3d(g3.df$G1,g3.df$G3,g3.df$D2R); rglwidget(width = 520, height = 520)

######################
#### Code Chunk 5 ####
######################
summary(lm.g1)$coef
summary(lm.g13)$coef
model.matrix(lm.g1)[1:3,]
model.matrix(lm.g13)[1:3,]

######################
#### Code Chunk 6 ####
######################
AIC(lm(D2R~G1,g3.df),
    lm(D2R~G3,g3.df),
    lm(D2R~G1+G3,g3.df),
    lm(D2R~G1*G3,g3.df))

######################
#### Code Chunk 7 ####
######################
AIC(lm(D2R~G1, g3.df),
    lm(D2R~G3, g3.df),
    lm(D2R~G1+G3, g3.df),
    lm(D2R~G1*G3, g3.df),
    k=log(dim(g3.df)[1]))











