[In progress.. ]

# Indian Assembly Election Predictive Analysis

<br>

<p align="center"><img width=16% src=https://user-images.githubusercontent.com/44467789/64017385-1c559c80-cb47-11e9-8f6b-3c78179c8c6b.png>

<p align="center"><img width=58% src=https://user-images.githubusercontent.com/44467789/64017384-1c559c80-cb47-11e9-9558-82a3d609bc2f.jpg>

<br>

### Table of Content
- [Objective](#objective)
- [Approach](#approach)
- [Data Collection](#data-collection)
- [Data Preparation](#data-preparation)
- [Setting Up R Studio and Data Variables](#setting-up-r-studio-and-data-variables)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Building Regression Tree](#building-regression-tree)
- [Building Multinomial Logistic Regression](#building-multinomial-logistic-regression)
- 

<br>

### Objective

Objective of the project is to build predictive models with supervised techniques to predict Rajasthan State Legislative Assembly Elections outcome.

<br>

### Approach

- Collect raw data from trusted sources - election websites on internet.
- Raw data preparation in Microsoft excels to run predictive models.
- Setting up data and variable preparation of variables in R Studio platform.
- Analyze significant variables and visualize data for assembly elections.
- Building CART – Regression Tree for target variable VOTE_SHARE [continuous variable]
- Analyze regression tree model performance on unseen dataset.
- Building Multinomial Logistic Regression model for target variable POSITION [categorical variable]
- Analyze model performance on unseen dataset for Rajasthan Assembly Elections 2013.
- Analyze model performance on unseen dataset for Rajasthan Assembly Elections 2008.
- Compare model performance and make conclusion.

<br>

### Data Collection

Data Collection for Rajasthan Assembly Elections – 2013

For particular project data has been collected from various trusted sources from internet.

Election Commission of India: https://www.eci.gov.in/

My Neta: http://www.myneta.info/

<p align="center"><img width=60% src=https://user-images.githubusercontent.com/44467789/64017879-4d829c80-cb48-11e9-817b-ca94543abe23.png>
  
In India, especially states like Rajasthan castes and party representative plays major role. Hence, highlighted variable are most important.

The data was acquired from Election Commission of India website for Rajasthan 2013 State Legislative Assembly Elections. However, same data was acquired from My Neta website fro same election year, state Rajasthan.

To check the Multinomial Logistic Regression model on unseen dataset we have also acquired data for Rajasthan 2008 State Legislative Assembly Elections from Election Commission of India website.

<br>

### Data Preparation

Collection of raw data was an easy task, but, to prepared the data for the predictive models building was time consuming task. However 80% of raw data preparation was done using Microsoft Excel tool.

For example, merging both the data set from different websites for exact Candidate Name was the most time consuming task. First, we downloaded the data from particular websites, and stored it in excel files. Then we removed unnecessary rows and columns (Filter and Sort options are very helpful).

After this we went through each and every two hundred constituencies and cross checked the candidates name with representative party and other variable like TOTAL_ASSETS. TOTAL_ASSETS variable was tricky to clean, here first we removed ‘Rs.’ from each column with the help of ‘Text to Columns’ function in excel. And then we converted entire column from Text to Number.

To acquire more information we also went through each and every candidate names to show whether the candidate has a PAN or not! Or did candidate have filled ITR Returns or not! After completion of this task, we came with proper data in .csv format to load the file on R Studio.

<br>

### Setting Up R Studio and Data Variables

This task has been carried out with loading important libraries.
```
polls = read.csv('RAJASTHAN_2013.csv')

## LIBRARIES 

library(dplyr)
library(ggplot2)
library(rpivotTable)
library(moments)
library(forecast)

attach(polls)

## Check Missing data

colSums(is.na(polls))
```
As we load the data in R Studio, we have also observed that few data are missing – especially acquired from My Neta website. However, these data represents only 1.24% to TOTAL_VALID_VOTES.
And hence, we decide to omit the missing values.

```
## CREATE VOTE_SHARE IN PERCRENT 

polls$VOTE_SHARE =  (TOTAL_VALID_VOTES / sum(TOTAL_VALID_VOTES))*100
```
For our objective we created new variable VOTE_SHARE based on TOTAL_VALID_VOTES. And our model will predict target variable VOTE_SHARE. VOTE_SHARE is continuous variables and represents candidate wise vote share based on totals votes casted.

In the polls dataset, to predict VOTE_SHARE we are using CART – Regression tree, and we decided to remove unwanted variables, like AC_NO, AC_NAME, CAND_NAME, and POSITION.

<br>

### Exploratory Data Analysis

It is very important to analyze significant variable take in dataset. Based on the data structure we can see that AC_TYPE and CAND_CATEGORY represent same level of categorical variables.

```
## CHANGE LEVELS NAMES IN AC_TYPE and CAND_CATEGORY

levels(polls$AC_TYPE)

## [1] "GEN" "SC"  "ST"

levels(polls$AC_TYPE) = c('AC_GEN', 'AC_SC', 'AC_ST' )

levels(polls$CAND_CATEGORY)

## [1] "GEN" "SC"  "ST"

levels(polls$CAND_CATEGORY) = c('CAND_GEN', 'CAND_SC', 'CAND_ST')
```
Based on summary of polls dataset we can see Male candidate are higher than female representatives. Bur, intresting case comes up when we analyze ITR_FILED candidated list. ITR_FILED variable ratio for Yes and No is almost similar. And hence, it says that it is not very important to file ITR and to get a ticket to represent respective parties for assembly elections in Rajasthan.

And, as we can analyze predictive variable VOTE_SHARE, max vote share out of total valid votes is 0.38% and minimum is 0.00016%. However, this is obvious because in some constituency seat due to less voters party representative got less number of votes.

As we mentioned earlier, in India, especially stares like Rajasthan castes and party nominative candidate plays important role in winning or losing the party seat.

<p align="left"><img width=30% src= https://user-images.githubusercontent.com/44467789/64073547-3e712b00-ccbd-11e9-8c40-0fd9dd35d30e.png>
  
With the help of rpivotTable(polls) function, we can analyze that, candidate from SC and ST got ticket to represent their party where constituency type was General. However this directly means in there are high chance for a party to lose that particular seat. Interestingly national parties like BJP and INC know the caste strategy and hence these figures are very low, for CAND_SC and CAND_ST represent 1.5% and 2.1% for General constituencies.

Now, as see the PAN and ITR_FILED variables, we got interesting analysis.

<p align="center"><img width=73% src=https://user-images.githubusercontent.com/44467789/64073572-a9226680-ccbd-11e9-88c7-087686f61c1f.png>

There are 44.8% of candidates who have not filed their income tax returns, and still they are contesting and representing their party. Further, we also analyzed from the chart that candidates who has not filed ITR are spread across all constituencies [presented by black point in chart].

<p align="center"><img width=73% src=https://user-images.githubusercontent.com/44467789/64073588-d838d800-ccbd-11e9-875f-1da1ba090d4e.png>

Similarly we also observed in case of PAN variable. There are around 25% candidates who have NO Pan card and still representing their party in assembly elections.
Same case we can analyze that these candidates are spread across constituencies [presented by black point in chart].

```
rpivotTable(polls)
```

We have also analyzed interesting relationship between variables. We used rpivotTable(polls) in R Studio or represents facts and figures.

##### Relationship between TOTAL_ VALID_VOTES and CRIMINAL_CASE

First, we analyzed relationship between Total Valid Votes and Candidates having 1 or more criminal case. And we found that there are around 15% candidates who are representing constituency seat in their region, having 1 or more criminal cases.

##### Relationship between Candidate Education and Total Valid Votes

Most of the candidates representing their regional seat are above graduate level. However, around 26% candidates do not have proper education background

##### Relationship between Candidates Sex and Candidate Party

Here, we can see that party representing almost all seats out of total 200 constituencies seats, Female candidates BJP and INC represents 25 and 24 seat. Seats ratio for Male and Female is less, but for state election like Rajasthan it is good.

##### Relationship between Candidate Sex, Candidate Party and Total Valid Votes

This numbers represents, that Female candidate gave big cheers to BJP and INC, where acquiring votes for party around 5.5% and 4.0% for BJP and INC respectively.

##### Relationship between Total Liabilities - Candidates wise count

Data explains that most of the candidates are NIL on the liability count. Number tells that around 1,123 candidates having No liabilities, which is more that 50% candidates in dataset do not have any liabilities.

Further, we analyses that there is 60% positive correlation between Total Asset and Total Liabilities for candidates count.
Here, we left with two options; either normalizes TOTAL_LIB variable for data fit or considering good correlation with Total Asset and remove TOTAL_LIB variable. We decided to remove the variable from the dataset.

```
## DUE TO 1,123 CANDIDATED HAVING ZERO LIB + significant correlation TO TOTAL_ASSEET 

cor(TOTAL_ASSET, TOTAL_LIB)
```
However, TOTAL_ASSET is represented in rupees and hence, we decided not to normalize for data fit.

As we can see the below histogram for Candidates Age factor, the histogram is right skewed.
And hence, we used BoxCox.Lambda test using library forecast to normalize the variable for data fit.

<p align="center"><img width=73% src=https://user-images.githubusercontent.com/44467789/64073680-dfacb100-ccbe-11e9-87f2-ffbd96a1b2d0.png>
 
To build the predictive model we split the data into 90 : 10 dataset for Train : Test.
We have also removed the variable TOTAL_VALID_VOTES variable as VOTE_SHARE is representation of Total Valid Votes.

```
### ## %%%%%%%%%%%    SPLIT  DATASET INTO 90:10   %%%%%%%%%  ## ###

set.seed(123)

split = sample(2, nrow(polls), replace = TRUE, prob = c(0.9,0.1))

train = polls[split == 1, ]
test = polls[split == 2, ]


## REMOVE TOTAL_VALID VOTES var AS IT REFLECTS var VOTE_SHARE

train = train[, -11]
test = test[ ,-11]
```

### Building Regression Tree

Based on train and test dataset, we’ll build regression tree on target variable VOTE_SHARE, with the help of rpart, rpart.plot, rattel and RcolourBrewer libraries.
Here, we set rpart.control function with minsplit of 100 and minbucket of 10.

```
## Setting rpart.control function

r.ctrl = rpart.control(minsplit = 100, minbucket = 10, cp = 0, xval = 10)

model = rpart(formula = VOTE_SHARE~., data = train, method = 'anova', control = r.ctrl)
```
To build regression tree we used rpart() function, and we set method as ‘anova’.
For classification tree, we uses ‘class’ method but here due to continuous variable VOTE_SHARE, we build regression tree with ‘anova’ method.

Now, based on CP (Complex Parameter) table we’ll prune tree from min error rate. As we see at nsplit 6, we can check the least xerror rate of 0.1991

Based on relative error we consider CP value as 0.0016, less the relative error higher the quality of model predictability.
In regression tree we measure performance based on R-Squared, which is reflection of (1 – Relative Error rate).

In pruned tree, at Node 1, Candidate Party is highly significant. Hence, we can say that in VOTE_SHARE variable, CAND_PARTY plays important role on vote bank.

We acquired interesting facts from CAN_PARTY count and numbers of constituencies of Rajasthan Assembly Elections 2013.
Here, total constituencies are 200, where BJP candidates represents 199 [from original dataset, study dataset consists 197 nominees] and INC candidates represents 200 [from original dataset, study dataset consists 197 nominees].

However, national level parties like CPM and NCP represents 37 and 16 nominees respectively.

This tells if BJP and INC party distribute tickets to their nominated candidates there are higher chances to acquire maximum votes and to win maximum seats, out of total constituencies. Where, CPM and NCP for example has only 18.5% [37/200] and 8% [16/200] probability chances to come up with maximum vote share. Because, out of 200 seats on 163 CPM has not nominated any candidate and hence probability of acquire votes winning that particular constituency seat becomes ‘Zero’.

To check the performance of the model we considered R-squared with the help of rsq.rpart() function.

```
## Define R-square for the model

par(mfrow = c(1,2))
rsquart = rsq.rpart(model.prun)
```

As we can see in the below charts, decrease in relative error, increases R-square. And hence at 6th split we have r-squared value of tree 0.80. R-squared value of 0.80 represents, that 80% of change in VOTE_SHARE has been represented by pruned tree regression tree, where CAND_PARTY plays significant role.

<p align="center"><img width=73% src=https://user-images.githubusercontent.com/44467789/64091227-d67a1d80-cd6c-11e9-9f67-0cc9f7c7a9ef.png>
  
Now, based on unseen dataset we’ll predict the VOTE_SHARE based on pruned regression tree. We have used predict() function and ‘anova’ method to predict unseen dataset test.
And, based on prediction we’ll also check the accuracy of model on unseen dataset in chart format.

After creating data frame for actual and predicted VOTE_SHARE, we can see from the plot, that model works best on unseen dataset.

<p align="center"><img width=73% src=https://user-images.githubusercontent.com/44467789/64091271-0a554300-cd6d-11e9-82ec-bb6458930375.png> 
  
### Building Multinomial Logistic Regression


