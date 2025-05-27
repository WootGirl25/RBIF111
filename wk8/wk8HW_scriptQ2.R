#Week 8 HW Q2

#Chose Primary Biliary Cirrhosis data from link in notes.

#col V2 = number of days between registration and the earlier of death, transplantation, or study analysis time
#col V3= status: coded as 0=censored, 1=censored due to liver tx, 2=death
#col V6= sex: 0=male, 1=female
survivaldata <- read.table("~/Documents/RBIF111/wk8/survivaldata_ Cirrhosis.txt", row.names=1, quote="\"", comment.char="")
colnames(survivaldata)[c(1,2,5)] <- c("days","status","sex");survivaldata[1:3,1:5]

library(survival)
days <- survivaldata$days
sex <- survivaldata$sex
d2d.ind <- as.numeric(!is.na(days) & survivaldata$status==2) #days to death where days not na, and status is death
d2d.surv <- Surv(days, d2d.ind)
plot(survfit(d2d.surv~sex, data = survivaldata),
     col = c(2,4), xlab="Survival (Days)",
     ylab="1-p(death)")
legend(100,0.8, legend=c('M','F'), lwd=1, col=c('blue','red'))
coxph(Surv(days, d2d.ind)~sex, data=survivaldata)
# P >0.05 (barely) the likelihood of death does not depend on sex in this data set.