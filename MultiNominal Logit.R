

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

polls = na.omit(polls)

## STRUCTURE OF DATASET

str(polls)

## CHANGE LEVELS NAMES IN AC_TYPE and CAND_CATEGORY

levels(polls$AC_TYPE)
# [1] "GEN" "SC"  "ST" 

levels(polls$AC_TYPE) = c('AC_GEN', 'AC_SC', 'AC_ST' )

levels(polls$CAND_CATEGORY)
# [1] "GEN" "SC"  "ST" 

levels(polls$CAND_CATEGORY) = c('CAND_GEN', 'CAND_SC', 'CAND_ST')


## MODIFICATION ON VARIABLES ## 

polls$POSITION[polls$POSITION %in% 
  c(12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33)] = 'Others'

polls = polls[, -c(1,2,4,15)]

attach(polls)

## REMOVE TOATL_LIB Variable

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



## CONVERT FACTORS INTO DUMMY VARIABLES ## 

polls$CAND_M = ifelse(polls$CAND_SEX == 'M', 1,0)
polls$CAND_F = ifelse(polls$CAND_SEX == 'F', 1,0)

polls$AC_GEN  = ifelse(polls$AC_TYPE == 'AC_GEN', 1,0) 
polls$AC_SC = ifelse(polls$AC_TYPE == 'AC_SC', 1,0)
polls$AC_ST = ifelse(polls$AC_TYPE == 'AC_ST', 1,0)

polls$CAND_GEN  = ifelse(polls$CAND_CATEGORY == 'CAND_GEN', 1,0) 
polls$CAND_SC = ifelse(polls$CAND_CATEGORY == 'CAND_SC', 1,0)
polls$CAND_ST = ifelse(polls$CAND_CATEGORY == 'CAND_ST', 1,0)

polls$fifth = ifelse(polls$CAND_EDU == '5th Pass',1,0)
polls$eight = ifelse(polls$CAND_EDU == '8th Pass',1,0)
polls$ten = ifelse(polls$CAND_EDU == '10th Pass', 1,0)
polls$twelve = ifelse(polls$CAND_EDU == '12th Pass', 1,0)
polls$doctorate = ifelse(polls$CAND_EDU == 'Doctorate', 1,0)
polls$graduate = ifelse(polls$CAND_EDU == 'Graduate', 1,0 )
polls$graduateprofessional = ifelse(polls$CAND_EDU == 'Graduate Professional', 1,0)
polls$Illiterate = ifelse(polls$CAND_EDU == 'Illiterate', 1,0)
polls$Literate = ifelse(polls$CAND_EDU == 'Literate', 1,0)
polls$NOTGIVEN = ifelse(polls$CAND_EDU == 'Not Given', 1,0)
polls$others = ifelse(polls$CAND_EDU == 'Others',1,0)
polls$PostGrad = ifelse(polls$CAND_EDU == 'Post Graduate',1,0)

polls$PANYES = ifelse(polls$PAN == 'Y',1,0)
pollsPANNO = ifelse(polls$PAN == 'N',1,0)

polls$ITRYES = ifelse(polls$ITR_FILED == 'Y', 1,0)
polls$ITRNO = ifelse(polls$ITR_FILED == 'N',1,0)

## TOOK ONLY IMPORTANT PARTIES BASED ON HIGHER TO LOWER COUNT

polls$IND = ifelse(polls$CAND_PARTY == 'IND',1,0)
polls$BJP = ifelse(polls$CAND_PARTY == 'BJP', 1,0)
polls$INC = ifelse(polls$CAND_PARTY == 'INC', 1,0)
polls$BSP = ifelse(polls$CAND_PARTY == 'BSP', 1,0)
polls$NPEP = ifelse(polls$CAND_PARTY == 'NPEP', 1,0)
polls$BYS = ifelse(polls$CAND_PARTY == 'JGS',1,0)
polls$JGS = ifelse(polls$CAND_PARTY == 'JGS',1,0)
polls$SP = ifelse(polls$CAND_PARTY == 'SP', 1,0)
polls$CPM = ifelse(polls$CAND_PARTY == 'CPM', 1,0)
polls$BA_S_D = ifelse(polls$CAND_PARTY == 'BA S D',1,0)

polls$RJVP = ifelse(polls$CAND_PARTY == 'RJVP',1,0)
polls$IPGP = ifelse(polls$CAND_PARTY == 'IPGP', 1,0)
polls$CPI = ifelse(polls$CAND_PARTY == 'CPI', 1,0)
polls$nuzp = ifelse(polls$CAND_PARTY == 'nuzp', 1,0)
polls$LJP = ifelse(polls$CAND_PARTY == 'LJP', 1,0)
polls$NCP = ifelse(polls$CAND_PARTY == 'NCP', 1,0)
polls$JDU = ifelse(polls$CAND_PARTY == 'JD(U)', 1,0)
polls$BHBP = ifelse(polls$CAND_PARTY == 'BHBP',1,0)
polls$SHS = ifelse(polls$CAND_PARTY == 'SHS',1,0)
polls$MSDP = ifelse(polls$CAND_PARTY == 'MEDP',1,0)
polls$AKBAP = ifelse(polls$CAND_PARTY == 'AKBAP', 1,0)
polls$RLD = ifelse(polls$CAND_PARTY == 'RLD', 1,0)


## REMOVE FACTOR VARIABLES

polls = polls[, -c(1,2,3,5,6,9,10)]

attach(polls)

dim(polls)

#[1] 2022   50

## SPLIT DATA INTO TRAIN : TEST with 90 : 10 RATIO

set.seed(123)

split = sample(2, nrow(polls), replace = TRUE, prob = c(0.9,0.1))

#split = sample(2, nrow(polls), replace = TRUE, prob = c(0.1,0.9))

train = polls[split == 1, ]
test = polls[split == 2, ]


## BUILD MULTINOMINAL LOGISTIC MODEL 

library(nnet)

library(ggplot2)
library(SDMTools)
library(pROC)
library(Hmisc)
library(VIF)
library(caret)
library(AUC) 
library(SDMTools) 

attach(train)

## Apply multinom function to dataset 

L1 = as.factor(POSITION) ~ 
  CAND_AGE + CAND_F + CAND_M +
  IND + BJP + INC + BSP + NPEP + BA_S_D +
  RJVP + IPGP + CPI + LJP + NCP + JDU + SHS + BHBP + MSDP + AKBAP + RLD
  

m1 = multinom(L1 , train , trace = FALSE)

prediction = predict(m1 ,newdata = test)

test$POSITION = as.factor(test$POSITION)

confusionMatrix(prediction, test$POSITION)



## %%%%%%   2008 RAJASTHAN ELECTIONS %%%%%% ##


polls2008 = read.csv('RAJ_2008.csv')

levels(polls2008$AC_TYPE)

levels(polls2008$AC_TYPE) = c('AC_GEN','AC_GEN',
                              'AC_SC','AC_SC', 'AC_ST','AC_ST' )

levels(polls2008$CAND_CATEGORY)

levels(polls2008$CAND_CATEGORY) = c('CAND_GEN','CAND_GEN',
                                    'CAND_SC', 'CAND_SC', 
                                    'CAND_ST','CAND_ST')

attach(polls2008)

polls2008$POSITION[polls2008$POSITION %in% 
  c(12,13,14,15,16,17,18,19,20,
    21,22,23,24,25,26,27,28,29,30,31,32,33)] = 'Others'




## CONVERT CATEGORICAL VARIABLES INTO DUMMY VARs 

polls2008$CAND_M = ifelse(polls2008$CAND_SEX == 'M', 1,0)
polls2008$CAND_F = ifelse(polls2008$CAND_SEX == 'F', 1,0)

polls2008$AC_GEN  = ifelse(polls2008$AC_TYPE == 'AC_GEN', 1,0) 
polls2008$AC_SC = ifelse(polls2008$AC_TYPE == 'AC_SC', 1,0)
polls2008$AC_ST = ifelse(polls2008$AC_TYPE == 'AC_ST', 1,0)


polls2008$CAND_GEN  = ifelse(polls2008$CAND_CATEGORY == 'CAND_GEN', 1,0) 
polls2008$CAND_SC = ifelse(polls2008$CAND_CATEGORY == 'CAND_SC', 1,0)
polls2008$CAND_ST = ifelse(polls2008$CAND_CATEGORY == 'CAND_ST', 1,0)


## TOOK ONLY IMPORTANT PARTIES BASED ON HIGHER TO LOWER COUNT

polls2008$IND = ifelse(polls2008$CAND_PARTY == 'IND',1,0)
polls2008$BJP = ifelse(polls2008$CAND_PARTY == 'BJP', 1,0)
polls2008$INC = ifelse(polls2008$CAND_PARTY == 'INC', 1,0)
polls2008$BSP = ifelse(polls2008$CAND_PARTY == 'BSP', 1,0)
polls2008$NPEP = ifelse(polls2008$CAND_PARTY == 'NPEP', 1,0)
polls2008$BA_S_D = ifelse(polls2008$CAND_PARTY == 'BA S D',1,0)

polls2008$RJVP = ifelse(polls2008$CAND_PARTY == 'RJVP',1,0)
polls2008$IPGP = ifelse(polls2008$CAND_PARTY == 'IPGP', 1,0)
polls2008$CPI = ifelse(polls2008$CAND_PARTY == 'CPI', 1,0)

polls2008$LJP = ifelse(polls2008$CAND_PARTY == 'LJP', 1,0)
polls2008$NCP = ifelse(polls2008$CAND_PARTY == 'NCP', 1,0)
polls2008$JDU = ifelse(polls2008$CAND_PARTY == 'JD(U)', 1,0)
polls2008$BHBP = ifelse(polls2008$CAND_PARTY == 'BHBP',1,0)
polls2008$SHS = ifelse(polls2008$CAND_PARTY == 'SHS',1,0)
polls2008$MSDP = ifelse(polls2008$CAND_PARTY == 'MEDP',1,0)
polls2008$AKBAP = ifelse(polls2008$CAND_PARTY == 'AKBAP', 1,0)
polls2008$RLD = ifelse(polls2008$CAND_PARTY == 'RLD', 1,0)

polls2008 = polls2008 [, -c(1,2,3,5)]
polls2008 = polls2008 [, -c(2)]



## SELECT RANDOM DATASET 

set.seed(123)

split = sample(2, nrow(polls2008)
               , replace = TRUE, prob = c(0.1,0.9))

#split = sample(2, nrow(polls), replace = TRUE, prob = c(0.1,0.9))

train2008 = polls[split == 1, ]
test2008 = polls[split == 2, ]


## PREDICT 2008 DATASET 

dim(test2008)

# [1] 10834    50

prediction = predict(m1 ,newdata = test2008)

test2008$POSITION = as.factor(test2008$POSITION)

confusionMatrix(prediction, test2008$POSITION)




























