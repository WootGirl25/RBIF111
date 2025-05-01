

#####################
#### Week 5 code ####
#####################

####################################
####  Week 5 Notes Part 1 ANOVA ####
####################################
######################
#### Code Chunk 1 ####
######################
library(ALL); data(ALL)
y<-20+10*1:20+5*(1:20)*(1:20)+rnorm(20,0,200)
x<-1:20 # x,y as in homework 3
anova(lm(y~x+I(x^2)))
anova(lm(y~I(x^2)+x))
anova(lm(y~I(x^2)))

######################
#### Code Chunk 2 ####
######################
fp.df <- data.frame(fp=pData(ALL)[,"fusion protein"],
                    g=exprs(ALL)["1970_s_at",])
table(fp.df$fp)
stripchart(fp.df$g~fp.df$fp,vertical=T,
           ylab="1970_s_at expression",method='jitter',cex.lab=1.7,cex.axis=1.7)

######################
#### Code Chunk 3 ####
######################
coef(lm(g~fp,fp.df))
mean(fp.df$g[!is.na(fp.df$fp)])
mean(fp.df$g[!is.na(fp.df$fp)&fp.df$fp=="p190"])
mean(fp.df$g[!is.na(fp.df$fp)&fp.df$fp=="p190/p210"])
mean(fp.df$g[!is.na(fp.df$fp)&fp.df$fp=="p210"])
17*(3.866913-3.7052303)^2+ # SSbetween
  8*(3.866913-3.7052303-0.3614408)^2+ 8*(3.866913-3.7052303-0.3054996)^2
anova(lm(g~fp,fp.df))

######################
#### Code Chunk 4 ####
######################
fp.df <- data.frame(fp=pData(ALL)[,"fusion protein"],
                    g=exprs(ALL)["41682_s_at",])
table(fp.df$fp)
mean(fp.df$g[!is.na(fp.df$fp)])
coef(lm(g~fp,fp.df))
17*(4.161295-4.14767131)^2+ # SSbetween
  8*(4.161295-4.14767131-0.04215518)^2+ 8*(4.161295-4.14767131-0.01404192)^2
anova(lm(g~fp,fp.df))

################################################
####  Week 5 Notes Part 2 Contingency Table ####
################################################
######################
#### Code Chunk 1 ####
######################
library(ALL); data(ALL)
ALL.pdat <- pData(ALL)
date.cr.chr <- as.character(ALL.pdat$date.cr)
diag.chr <- as.character(ALL.pdat$diagnosis)
date.cr.t <- strptime(date.cr.chr,"%m/%d/%Y")
diag.t <- strptime(diag.chr,"%m/%d/%Y")
days2remiss <- as.numeric(date.cr.t - diag.t)
##############################################
d2r.df.34852 <- data.frame(
  G=exprs(ALL)["34852_g_at",],
  D2R=as.numeric(days2remiss))
lm.34852 <- lm(D2R~G,d2r.df.34852)
anova(lm.34852)
y <- d2r.df.34852$D2R; y <- y[!is.na(y)] # y=days-to-remission
y.hat <- predict(lm.34852)               # fitted (predicted) values
# predicted values with intercept-only model:
y.hat.wo.G <- predict(lm(D2R~1,d2r.df.34852))
range(y.hat.wo.G-mean(y))
eps <- resid(lm.34852)
range(y.hat+eps-y)                       # just a sanity check. Y IS y_predicted + residual
sum((y.hat-y.hat.wo.G)^2)                # SSbetween
sum(resid(lm.34852)^2)                   # residuals=(remaining noise), SSwithin
sum((y.hat-y.hat.wo.G)^2)/(sum(resid(lm.34852)^2)/94) # F

######################
#### Code Chunk 2 ####
######################
x.df<-data.frame(
  Col=c("B","B","B","B","W","W","W","W","W"),
  Weight=c("H","H","L","L","L","L","L","L","H"))
table(x.df)
x.chi <- chisq.test(table(x.df),correct=F)
print(x.chi)
x.chi$expected
(2+2)*(2+4)/(2+2+4+1)
sum((table(x.df)-x.chi$expected)^2/x.chi$expected)

######################
#### Code Chunk 3 ####
######################
fisher.test(table(x.df),alternative="greater")$p.value
choose(4,2)*choose(5,4)/choose(9,6)
dhyper(2,4,5,3)                 #P{Black=2}
dhyper(3,4,5,3)                 #P{Black=3}
dhyper(4,4,5,3)                 #P{Black=4}
dhyper(2,4,5,3)+dhyper(3,4,5,3) #P{Black>=2}
phyper(1,4,5,3,lower.tail=F)    #P{Black>1}

######################
#### Code Chunk 4 ####
######################
Nw <- 10
Nb <- 10
Nd <- 10
p.chi <- numeric()
p.hyp <- numeric()
p.fish <- numeric()
p.fish.2 <- numeric()
for ( Nwd in 0:10 ) {
  x.df <- data.frame(C=c(rep("W",Nw),
                         rep("B",Nb)),
                     D=c(rep("Y",Nwd),
                         rep("N",Nw-Nwd),
                         rep("Y",Nd-Nwd),
                         rep("N",Nb-Nd+Nwd)))
  x.tbl <- table(x.df)
  p.chi[Nwd+1] <- chisq.test(x.tbl,correct=F)$p.value
  p.hyp[Nwd+1] <- phyper(Nwd-1,Nw,Nb,Nd,lower.tail=F)
  p.fish[Nwd+1] <- fisher.test(x.tbl,alternative='greater')$p.value
  p.fish.2[Nwd+1] <-
    fisher.test(x.tbl,alternative='two.sided')$p.value
}
old.par <- par(lwd=2,ps=20)
plot(c(0,10),c(0,1),type="n",xlab="Nwd",ylab="p-val")
points(0:10,p.chi,type="l",col="black")
points(0:10,p.hyp,type="l",col="blue")
points(0:10,p.fish,type="p",col="green")
points(0:10,p.fish.2,type="p",col="magenta")
text(6,0.9,"chisq",pos=4)
text(6,0.8,"phyper",col="blue",pos=4)
text(6,0.7,"Fisher greater",col="green",pos=4)
text(6,0.6,"Fisher 2-sided",col="magenta",pos=4)
par(old.par)

######################
#### Code Chunk 5 ####
######################
table(pData(ALL)$sex,pData(ALL)$remission)
chisq.test(table(pData(ALL)$sex,pData(ALL)$remission))
chisq.test(table(pData(ALL)$sex,pData(ALL)$remission),correct=F)
fisher.test(table(pData(ALL)$sex,pData(ALL)$remission))







