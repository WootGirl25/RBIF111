

#####################
#### Week 4 code ####
#####################

#################################################
####  Week 4 Notes Part 1 Error of the Mean ####
#################################################
######################
#### Code Chunk 1 ####
######################
smpl.sizes <- c(1,2,4,8,16,32,64,128) # sample sizes
r.mu <- numeric()
r.sem <- numeric()
n.sim <- 1000
for ( i.smpl in smpl.sizes ) {
  r.mat <- matrix(rnorm(i.smpl*n.sim),
                  nrow=n.sim,ncol=i.smpl)
  mu.tmp <- apply(r.mat,1,mean)
  r.mu <- c(r.mu,mean(mu.tmp))
  r.sem <- c(r.sem,sd(mu.tmp))
}
plot(c(min(smpl.sizes),max(smpl.sizes)),
     c(min(c(r.mu,r.sem)),
       max(c(r.mu,r.sem))),
     type="n",ylab="Mean and SEM",
     xlab="n",sub=paste(n.sim,"sims"))
points(smpl.sizes,r.mu,type="l",lty=2)
points(smpl.sizes,r.sem,col="blue")
points(smpl.sizes,1/sqrt(smpl.sizes),
       type="l",col="blue")

##################################
####  Week 4 Notes Part 2 CLT ####
##################################
######################
#### Code Chunk 1 ####
######################
smpl.sizes <- 2^(0:8)              # different sample sizes n we want to try
n.sim <- 1000                      # we want to draw n.sim samples for each sample size n
old.par <- par(mfrow=c(3,3),ps=20) # draw 9 plots in 3x3 lattice
for ( i.smpl in smpl.sizes ) {     # for each sample size
  # if we drew n.sim examples of Bernoulli samples of size i.smpl
  # and every time summed up i.smpl values in each sample, the
  # resulting n.sim sums (that represent numbers of heads observed
  # after i.smpl coin tosses) would be distributed as binomial, 
  # so instead of resampling we just use that directly: 
  x.tmp <- rbinom(n.sim,i.smpl,0.5) # distribution of n.sim sums
  # plot the distribution (histogram) of n.sim sums S
  plot(hist(x.tmp,plot=F),
       main=paste("n =",i.smpl),
       xlab="Sum(Xn)",ylab="N(sum)")
}
par(old.par)

###################################################
####  Week 4 Notes Part 3 Confidence Intervals ####
###################################################
######################
#### Code Chunk 1 ####
######################
(x <- rnorm(5))               # generate a sample of size 5 from the normal
# fit linear model and get conf. int. of the intercept (sample mean)
confint(lm(x~1))
summary(lm(x~1))$coefficients # what are the coefficients of the fit?
mean(x)                       # just to confirm that intercept of X~1 is indeed the mean:
sd(x)







