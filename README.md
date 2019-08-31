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

