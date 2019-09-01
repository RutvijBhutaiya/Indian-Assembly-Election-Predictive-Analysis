

## %% OBJECTIVE

## %% APROACH




## SET WORKING DIRECTORY ##

setwd("C:/Users/server/Desktop/Machine R")

polls = read.csv('RAJASTHAN_2013.csv')

## LIBRARIES 

library(dplyr)
library(ggplot2)
library(rpivotTable)
library(moments)
library(forecast)

attach(polls)

colSums(is.na(polls))


## CREATE VOTE_SHARE IN PERCRENT 

polls$VOTE_SHARE =  (TOTAL_VALID_VOTES / sum(TOTAL_VALID_VOTES))*100



## REMOVE NON-SIGNIFICANT VARIABLES
##       AC_NO, AC_NAME, CAND_NAME, POSITION (BASED ON OBJECTIVE WE DON'T REQUIRE)


polls = polls[, -c(1,2,4,16)]

dim(polls)

head(polls)

## WE DECIDE TO OMIT ALL NAs : OMITTING ROWS REPRESENTS ONLY 1.24 % VOTE SHARE

polls = na.omit(polls)

## STRUCTURE OF DATASET

str(polls)

## CHANGE LEVELS NAMES IN AC_TYPE and CAND_CATEGORY

levels(polls$AC_TYPE)

## [1] "GEN" "SC"  "ST"

levels(polls$AC_TYPE) = c('AC_GEN', 'AC_SC', 'AC_ST' )

levels(polls$CAND_CATEGORY)

## [1] "GEN" "SC"  "ST"

levels(polls$CAND_CATEGORY) = c('CAND_GEN', 'CAND_SC', 'CAND_ST')


## DESCRIPTIVE STATISTICS

summary(polls)

## TARGET VARIABLE SUMMARY

summary(VOTE_SHARE)


## @@@@@@@@@@   visulization   @@@@@@@@@@@  ##### 

## RELATIONSHIP BETWN ACCOUNT TYPE AND CANDIDATE TYPE

barplot(table(AC_TYPE, CAND_CATEGORY), beside = TRUE, 
        col = c('cornflowerblue', 'darksalmon', 'darkseagreen'),  
        main = 'RELATIONSHIP BETWN ACCOUNT TYPE AND CANDIDATE TYPE', 
        ylab = 'ACCOUNT TYPE', xlab = 'CANDIDATE TYPE')

## *) SUM AS FRACTION OF TOTAL [total_val_votes] ->  CAND_CATOG + AC_TYPE




## PAN and ITR FILED vs.  TOTAL ASSETS 

plot(TOTAL_VALID_VOTES, col = ITR_FILED, main = 'TOTAL VALID VOTES TO ITR FILES', 
     ylab = 'Valid Votes', xlab = 'Number of Candidates')

## *) PLOT TELLS CAND WITH NO PAN IS SPREADED ACROSS ALL constituency - black no ITR

## *) SUM AS FRACTION OF TOTAL [TOTAL_VAL_VOTES] -> DRAGE AND DROP ITR_FILED



plot(TOTAL_VALID_VOTES, col = PAN, main = 'TOTAL VALID VOTES TO PAN', 
     ylab = 'Valid Votes', xlab = 'Number of Candidates')

## *) PLOT TELLS CAND WITH NO PAN IS SPREADED ACROSS ALL constituency - black no PAN

## *) SUM AS FRACTION OF TOTAL [TOTAL_VAL_VOTES] -> DRAGE AND DROP PAN




rpivotTable(polls)

## [ISSUE  THERE ARE CANDIDATES HAVING HIGH ASSETS STILL NO PAN AND NO ITR FILLED]

  

## %%%%%%%% PIVOTABLE %%%%%%%%%%%

## 1) SUM AS FRACTION OF TOTAL [TOTAL_VAL_VOTES] -> DRAGE AND DROP CRIME_CASE 

## [ANALYZE MORE THAN 10% VOTES GOES TO CANDI HOLDING CRIME CASES]

## 2) SUM AS FRACTION OF TOTAL [TOTAL_VAL_VOTES] -> DRAGE AND DROP CAND_EDU 

## [ANALYZE EDUCATION PLAYES MAJOR ROLE IN VOTING]

## 3) COUNT -> DRAGE CAN_SEX -> DRAGE CAND_PARTY 
## 4) SUM AS FRACTION OF TOTAL [TOTAL_VAL_VOTES] -> DRAGE CAN_SEX -> DRAGE CAND_PARTY

## [ANALYZE THE IND AND BSP HOW THEY CHAGES.. BEING HIGHEST SEATS.. STILL LOST]



## %%%%%%%%%%%%%%%%%%%%%%  #########

## REMOVE TOTAL_LIB VARIABLE 

hist(TOTAL_LIB, col = 'darkseagreen', main = 'Total Libalities')


## DUE TO 1,123 CANDIDATED HAVING ZERO LIB + significant correlation TO TOTAL_ASSEET 

cor(TOTAL_ASSET, TOTAL_LIB)

# [1] 0.5877984

polls = polls[, -9]

## NOT TO USE BOXCOX.LAMBDA TEST ,  BCOS ASSETS ARE IN  RUPEES 

hist(TOTAL_ASSET, col = 'darkseagreen')

## NORMALIZE CAND_AGE var AS IT IS RIGHT SKEWED

hist(CAND_AGE, col = 'salmon')

BoxCox.lambda(CAND_AGE)

CAND_AGE = (1/sqrt(CAND_AGE))
CAND_AGE = 1/CAND_AGE
CAND_AGE = log(CAND_AGE)
CAND_AGE = CAND_AGE^2


### ## %%%%%%%%%%%    SPLIT  DATASET INTO 90:10   %%%%%%%%%  ## ###

set.seed(123)

split = sample(2, nrow(polls), replace = TRUE, prob = c(0.9,0.1))

train = polls[split == 1, ]
test = polls[split == 2, ]


## REMOVE TOTAL_VALID VOTES var AS IT REFLECTS var VOTE_SHARE

train = train[, -11]
test = test[ ,-11]


###  %%%%%%%%   BUILT MODEL  %%%%%%%%%  ###


library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)

## Setting rpart.control function

r.ctrl = rpart.control(minsplit = 100, minbucket = 10, cp = 0, xval = 10)

## Built Regression Tree using rpart function

#VS = VOTE_SHARE ~ CAND_AGE + CAND_SEX + CAND_PARTY

#model = rpart(formula = VS, data = train, method = 'anova', control = r.ctrl)

model = rpart(formula = VOTE_SHARE~., data = train, method = 'anova', control = r.ctrl)

fancyRpartPlot(model)

printcp(model)

## Prune the Regression Tree at CP = 0.0016

model.prun = prune(model, cp = 0.0016 , 'CP')

fancyRpartPlot(model.prun, uniform = TRUE, main = 'Pruned Regression Tree')


## Define R-square for the model

par(mfrow = c(1,2))
rsquart = rsq.rpart(model.prun)


## Predict Model on unseen dataset

actual = test[, 11]

newtest = test[, -11]

## Apply predict() function  

predicted = predict(model.prun, newtest, method = 'anova', interval = 'confidence')


backtrack = data.frame(actual, predicted)

## Plot Actual and Predicted VOTE_SHARE 

par(mfrow = c(1,1))

plot(actual, col = 'salmon')
plot(predicted, col = 'darkseagreen')

lines(actual, col = 'salmon')
lines(predicted, col = 'darkseagreen')














