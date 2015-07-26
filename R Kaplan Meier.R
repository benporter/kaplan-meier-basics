## Load Libraries
library(survival)
library(sas7bdat)

# read in data
accounts <- read.sas7bdat("/home/ben/SAS/SAS-University-Edition/mysharedfolder/randomdata.sas7bdat")

head(accounts)


# 1=event/death, 0=censor
# flip the censoring indicator: subtract 1, then mult by -1
head(accounts$censor)
accounts$censor <- (accounts$censor - 1) * -1
head(accounts$censor)

s <- survfit(formula = Surv(time = accounts$t, accounts$censor, type = "right")~1, conf.type = c("plain"))

attributes(s)

for (i in 1:(length(s$time)-1)) {
  # next time t minus current time t
  s$impliedRepetition[i] <- s$time[i+1] - s$time[i]
  
  # auc are the weighted average time periods
  s$auc[i] <- s$impliedRepetition[i] * s$surv[i]
}

sum(s$auc)
