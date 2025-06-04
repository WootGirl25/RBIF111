

#####################
#### Week 9 code ####
#####################

#######################################
####  Week Week 9 Notes Part 1 PCA ####
#######################################
######################
#### Code Chunk 1 ####
######################
x<- (-100:100)                         # start simulating the data: define x
y<- 0.8*x                              # y correlates with x (so far perfectly)
x<-(x+10*rnorm(201))/100               # add noise and scale down the range of x
y<-(y+10*rnorm(201))/100               # add noise and scale down the range of y
plot(x,y)                              # take a look at simulated data
cov(x,y); cor(x,y)                     # covariance and correlation:
xx<-(x-mean(x))/sd(x)                  # center and scale variables manually
yy<-(y-mean(y))/sd(y)
dfx<-data.frame(x=x,y=y)               # original simulated data
dfxx<-data.frame(x=xx,y=yy)            # centered and scaled simulated data
px<-prcomp(dfx,retx=TRUE,scale=TRUE)   # run PCA with auto-scaling
pxx<-prcomp(dfxx,retx=TRUE,scale=FALSE)
# above: without auto-scaling but on manually scaled data
px$x[1:3,]                             # note scaled units (cf. below)
pxx$x[1:3,]
lx <- px$rotation
lxx <- pxx$rotation
px                                     # note scaled units (cf. below)
pxx

######################
#### Code Chunk 2 ####
######################
plot(xx,yy)
arrows(0,0,lxx[1,],lxx[2,], length=0.1,angle=20, col="red")
pxx$rotation
pxx$x[1:5,] # new coordinates for each point
xx[1]*0.7071068+yy[1]*0.707106
xx[1]*(-0.7071068)+yy[1]*0.707106
(cbind(xx,yy)%*%pxx$rotation)[1:5,]
plot(pxx$x,xlim=c(-2.5,2.5),ylim=c(-2.5,2.5))
arrows(0,0,lxx[,1],lxx[,2], length=0.1,angle=20, col="red")
text(lxx[,1]*1.2,lxx[,2]*1.2, rownames(lxx), col="red")

######################
#### Code Chunk 3 ####
######################
biplot(pxx,pc.biplot=TRUE)
p1<-pxx$x[,1]
p2<-pxx$x[,2]
plot(p1/sd(p1),p2/sd(p2),xlim=c(-2.5,3),type='n')
text(p1/sd(p1),p2/sd(p2),1:length(p1))
arrows(0,0,2*sd(p1)*lxx[,1],2*sd(p2)*lxx[,2],
       length=0.1,angle=20, col="red")
text(2.1*sd(p1)*lxx[,1],2.1*sd(p2)*lxx[,2],c('x','y'),col='red')

######################
#### Code Chunk 4 ####
######################
x<-c(rnorm(100,-2),rnorm(100,2))
y<-x
x<-x+rnorm(200,sd=0.5)
y<-y+rnorm(200,sd=0.5)
par(mfrow=c(1,3))
plot(x,y)
px <- prcomp(cbind(x,y),retx=T,scale=T)
plot(px$x[,1],px$x[,2],xlab="PC1",ylab="PC2")
biplot(px)

######################
#### Code Chunk 5 ####
######################
# generate 10 variables (columns) that contain exactly the same
# (perfectly correlated) randomly generated data forming 2 clusters:
x<-matrix(c(rnorm(100,-2),rnorm(100,2)),ncol=10,nrow=200,byrow=F)
x<-x+rnorm(2000,sd=0.2) # add some noise: dilute correlation
# replace 10th variable (gene) values with completely unstructured ones
x[,10]<-rnorm(200,sd=2)
px <- prcomp(x,retx=T,scale=T) # run PCA…
plot(px$x[,1],px$x[,2],xlab="PC1",ylab="PC2") # … and observe
biplot(px)

######################
#### Code Chunk 6 ####
######################
library(ALL); data(ALL)
# use first 600 genes; note the transposition of the matrix:
# variables are now genes, measurements (data points) are patients:
all.prcomp <- prcomp(scale(t(exprs(ALL)[1:600,])))
plot(all.prcomp)
dim(all.prcomp$x)
all.prcomp$x[1:3,1:3]
old.par <- par(mfrow=c(1,2),ps=20)
plot(all.prcomp$x[,1], all.prcomp$x[,2])
biplot(all.prcomp)
par(old.par)

#------------my addition to the code
#To visualize the percent that each pca contributes to variance try this (slighly easier to view)
pca <- all.prcomp
pca.var <- pca$sdev^2
pca.var.per <- round(pca.var/sum(pca.var)*100,1)
barplot(pca.var.per, xlab="PCA", ylab="% var") #all 128 samples (patients)

#narrow that to the first 6
barplot(pca.var.per[1:6], xlab="PCA", ylab="% var")
#we see that pc1 accounts for aover 20% of the variance, then pc2=~11%, pc3=~6, then with pc4+ accounting for <5% var

######################
#### Code Chunk 7 ####
######################
#install.packages("Rtsne")
library(Rtsne)
tsne <- Rtsne(scale(t(exprs(ALL)[1:600,])))
old.par <- par(mfrow=c(1,1),ps=20)
plot(tsne$Y[,1], tsne$Y[,2])

######################
#### Code Chunk 8 ####
######################
#install.packages("umap")
library(umap)
umap_result <- umap:::umap(scale(t(exprs(ALL)[1:600,])))
umap_df <- data.frame(umap_result$layout)
old.par <- par(mfrow=c(1,1),ps=20)
plot(umap_df[,1], umap_df[,2])

#########################################
####  Week 9 Notes Part 2 Clustering ####
#########################################
######################
#### Code Chunk 1 ####
######################
x1 <- c(rnorm(50,-1,sd=0.5),rnorm(50,1,sd=0.5))
y1 <- c(rnorm(50,-1,sd=0.5),rnorm(50,1,sd=0.5))
p<-cbind(x1,y1) 
rownames(p)<-paste('p',1:100,sep="")
h<-hclust(dist(p)) # all the clustering done in this single command!
plot(h)

######################
#### Code Chunk 2 ####
######################
plot.new()
cutree(h,4)
par(mfrow=c(1,2))
plot(x1,y1,col=cutree(h,k=4),pch=19,xlab='X',ylab='Y')
plot(x1,y1,col=cutree(h,k=2),pch=19,xlab='X',ylab='Y')

######################
#### Code Chunk 3 ####
######################
as.matrix(dist(p))[1:5,1:5]
p[1:5,]
sqrt(sum((p[1,]-p[5,])^2))

######################
#### Code Chunk 4 ####
######################
cor.dist <- 1 - cor(t(p))
d<-as.dist(cor.dist)

######################
#### Code Chunk 5 ####
######################
library(ALL); data(ALL)
h1 <- hclust(dist(t(exprs(ALL)[apply(exprs(ALL),1,sd)>1.0,])))
plot(h1,cex=0.7)
rect.hclust(h1,4)

######################
#### Code Chunk 6 ####
######################
hw <- hclust(dist(t(exprs(ALL))),method="ward")
hcor <- hclust(as.dist(1-cor(exprs(ALL))))
par(mfrow=c(2,1))
plot(hw,cex=0.7)
plot(hcor,cex=0.7)
table(HW=cutree(hw,2),HCOR=cutree(hcor,2))

######################
#### Code Chunk 7 ####
######################
exprs.sd.gt.1 <- exprs(ALL)[apply(exprs(ALL),1,sd)>1.0,]
hclust.sd.gt.1 <- hclust(dist(t(exprs.sd.gt.1)))
ori.heights <- hclust.sd.gt.1$height
exprs.rnd <- t(apply(exprs.sd.gt.1,1,sample))
plot(hclust(dist(t(exprs.rnd))),cex=0.7)
rnd.heights <- numeric()
for ( i.sim in 1:100 ) {
  exprs.rnd <- t(apply(exprs.sd.gt.1,1,sample))
  hclust.rnd <- hclust(dist(t(exprs.rnd)))
  rnd.heights <- c(rnd.heights,hclust.rnd$height)
}
plot(ori.heights,rank(ori.heights)/length(ori.heights),
     col= "red", xlab="height", ylab="F(height)")
points(rnd.heights,rank(rnd.heights)/length(rnd.heights),col="blue")
points(15,0.9,col="red")
text(15,0.9,"original",col="red",pos=4)
points(15,0.8,col="blue")
text(15,0.8,"scrambled",col="blue",pos=4)
abline(v=c(30,42),lty=2,col="blue")
plot(hclust.sd.gt.1,cex=0.7)
abline(h=c(30,42),lty=2,col="blue")



















