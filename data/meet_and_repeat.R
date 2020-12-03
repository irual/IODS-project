# Lauri Sillanmäki, IODS2020
# Analysis of longitudinal data, RStudio Exercise 6 DM. 01.12.2020. 

#1. Load the data sets (BPRS and RATS) into R using as the source the GitHub repository of MABS, where they are given in the wide form:
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

library(dplyr)
library(tidyr)

BPRS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep=" ")
RATS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep="\t")

#Also, take a look at the data sets: check their variable names, view the data contents and 
#structures, and create some brief summaries of the variables, so that you understand the point 
#of the wide form data. (1 point)

dim(BPRS)
names(BPRS)
glimpse(BPRS)
summary(BPRS)
#40 cases, 11 variables 
#This is a wide form data: single row contains all data for a single subject
#repetitive measures are saved into multiple variables (week0,..,week8)

dim(RATS)
names(RATS)
glimpse(RATS)
summary(RATS)
#16 cases, 13 variables 
#This is a wide form data: single row contains all data for a single subject
#repetitive measures are saved into multiple variables (WD1,..,WD64)

#2. Convert the categorical variables of both data sets to factors. (1 point)

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject   <- factor(BPRS$subject)

RATS$ID        <- factor(RATS$ID)
RATS$Group     <- factor(RATS$Group)

str(BPRS)
str(RATS)

#Works, both dataset has now two factors

#3. Convert the data sets to long form. Add a week variable to BPRS and a Time 
#variable to RATS. (1 point)

# Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number into "week"
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(BPRSL$weeks,5,6)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# Convert data to long form
RATSL <- RATS %>% 
  gather(key = WD, value = Weight, -ID, -Group) %>% 
  mutate(Time = as.integer(substr(WD,3,5))) 

#4. Now, take a serious look at the new data sets and compare them with their wide form versions:
# Check the variable names, view the data contents and structures, and create some brief summaries 
# of the variables. Make sure that you understand the point of the long form data and the crucial 
# difference between the wide and the long forms before proceeding the to Analysis exercise. 
# (2 points)

dim(BPRSL)
names(BPRSL)
glimpse(BPRSL)
summary(BPRSL)
BPRSL$week %>% unique() %>% length()
#Number of weeks = 9
#360 rows, 5 variables 
#This is a long form data: single row contains data only from a single measurement. 
#Repetitive measurement are saved into single variable "bprs" and multiple rows.
#Variable "subject" identifies subject, "week" identifies time. 
#40 cases x 9 weeks = 360 rows. 

dim(RATSL)
names(RATSL)
glimpse(RATSL)
summary(RATSL)
RATSL$Time %>% unique() %>% length()
#Number of levels in Time = 11
#176 rows, 5 variables
#This is a long form data: single row contains data only from a single measurement. 
#Repetitive measurement are saved into single variable "Weight" and multiple rows.
#Variable "ID" identifies subject, "Time" identifies time. 
#16 cases x 11 weeks = 176 rows. 

# Long form will be used for later data analysis. Sometimes wide form is needed. 
# Anyway, when analyzing repeated measures data we need to take care that within-subject variation is taken into account.

#As before, write the wrangled data sets to files in your IODS-project data-folder.
#Saving R data objects into permanent data files
write.table(BPRSL, file="./data/BPRSL.rData")
write.table(RATSL, file="./data/RATSL.rData")
