# Lauri Sillanmäki
# 19.11.2020
# Introduction to Open Data Science 2020, RStudio Exercise 4 DM. 

#2. Importing data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Data documentation
#   http://hdr.undp.org/en/content/human-development-index-hdi
#   http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

#3. Exploring
# Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables.

glimpse(hd)
summary(hd)
#n=195, 8 variables.

glimpse(gii)
summary(gii)
#n=195, 10 variables"

#4. Look at the meta files and rename the variables with (shorter) descriptive names.
library(dplyr) #For rename and mutate

colnames(hd)
hd2 <- hd %>% rename(HDI            = Human.Development.Index..HDI.,
                     exp.life       = Life.Expectancy.at.Birth,
                     exp.educ       = Expected.Years.of.Education,
                     mean.educ      = Mean.Years.of.Education,
                     GNIpc          = Gross.National.Income..GNI..per.Capita,
                     GNIpc.HDI.diff = GNI.per.Capita.Rank.Minus.HDI.Rank)
colnames(hd2)

colnames(gii)
gii2 <- gii %>% rename(GII     = Gender.Inequality.Index..GII.,
                       Mat.Mor = Maternal.Mortality.Ratio,
                       Adol.BR = Adolescent.Birth.Rate,
                       Rep.pct = Percent.Representation.in.Parliament,
                       eduF    = Population.with.Secondary.Education..Female.,
                       eduM    = Population.with.Secondary.Education..Male.,
                       labF    = Labour.Force.Participation.Rate..Female.,
                       labM    = Labour.Force.Participation.Rate..Male.)
colnames(gii2)

#5. Mutate the “Gender inequality” data and create two new variables. The first one should be 
# the ratio of Female and Male populations with secondary education in each country. 
# (i.e. edu2F / edu2M). The second new variable should be the ratio of labour force participation 
# of females and males in each country (i.e. labF / labM).

gii2 <- mutate(gii2, edu.ratio=eduF/eduM)
gii2 <- mutate(gii2, lab.ratio=labF/labM)

#6. Join together the two datasets using the variable Country as the identifier. Keep only the 
# countries in both data sets (Hint: inner join). The joined data should have 195 observations 
# and 19 variables. Call the new joined data "human" and save it in your data folder. (1 point)

human <- inner_join(hd2, gii2, by="Country")

#N and no of varibles.
dim(human)
#195 and 19, seems to be ok

#Saving R data object into permanent data file
write.table(human, file="./data/human.rData")
