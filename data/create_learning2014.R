# Lauri Sillanmäki
# 04.11.2020
# Introduction to Open Data Science 2020, RStudio Exercise 2 DM. 

#Reading excercise 2 data into R
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#Structure of data (data has 183 obs. and 60 variables, which are listed)
str(learning2014)

#Dimensions (# of cases and variables - this information was already shown in previous output)
dim(learning2014)

#Summary for each variable (basic stastistics or frequencies)
summary(learning2014)

# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06", "D15","D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset 'ex2' as for excercise 2
ex2 <- select(learning2014, one_of(keep_columns))

# see the structure of the new dataset (183 obs, 7 variables)
str(ex2)

# Exclude observations where the exam points variable is zero. 
ex2 <- filter(ex2, Points > 0)

# see the structure of the new dataset (166 obs, 7 variables)
str(ex2)

# Set the working directory of you R session the iods project folder 
# This could be done with RStudio GUI as well (Session  - Set Working Directory...)
setwd("/home/ls/R/projekteja/IODS-project/")

#Saving R data object into permanent data file
write.table(ex2, file="./data/ex2.rData")

#Reading saved datafile as "temp"
temp <- read.table("./data/ex2.rData")

#Structure of data set (166 obs, 7 vars, seems OK)
str(temp)

#First 10 observations (seems to be OK), 
head(temp,n=10)
