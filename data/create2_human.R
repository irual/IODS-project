# Lauri Sillanmäki, IODS2020
# Dimensionality reduction techniques, RStudio Exercise 5 DM. 24.11.2020. 
# Original data documentation
#   http://hdr.undp.org/en/content/human-development-index-hdi
#   http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

# Tasks:
# Load the ‘human’ data into R. Explore the structure and the dimensions of the data and describe 
# the dataset briefly, assuming the reader has no previous knowledge of it (this is now close to 
# the reality, since you have named the variables yourself). (0-1 point)

#Reading the previous data (created with create_human.R)
human <- read.table("./data/human.rData")

library(dplyr)

dim(human)
glimpse(human)
summary(human)
#195 cases, 19 variables

# Country        = Country name
# HDI            = Human Developmental Index (HDI)
# HDI.Rank       = HDI rank
# exp.life       = Life expectancy at birth
# exp.educ       = Expected years of schooling
# mean.educ      = Mean years of schooling
# GNIpc          = Gross national income (GNI) per capita		
# GNIpc.HDI.diff = GNI per capita rank minus HDI rank		
#
# GII            = Gender Inequality Index (GII)
# GII.Rank       = GII rank
# Mat.Mor        = Maternal mortality ratio,
# Adol.BR        = Adolescent birth rate,
# Rep.pct        = Percent representation in Parliament
# eduF           = Population with secondary education, females
# eduM           = Population with secondary education, males
# labF           = Labour Force Participation Rate, females
# labM           = Labour Force Participation Rate, males
# edu.ratio      = Female/male ratio of population with secondary education
# lab.ratio      = Female/male ratio of labour force participation ratios

# 1. Mutate the data: transform the Gross National Income (GNI) variable to numeric (Using string 
# manipulation. Note that the mutation of 'human' was not done on DataCamp). (1 point)

# tidyr package and human are available

# access the stringr package
library(stringr)

# look at the structure of the GNI column in 'human'
str(human$GNIpc)
#Comma is thousand separator, it has to be removed. Column type is factor.

# remove the commas from GNIpc and save it into data as GNI
human$GNI <- str_replace(human$GNIpc, pattern=",", replace ="") %>% as.numeric()
str(human$GNI)
#Commas are gone, variable is now numeric

# 2. Exclude unneeded variables: keep only the columns matching the following variable names 
# (described in the meta file above):  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", 
# "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" (1 point)

# columns to keep
keep <- c("Country", "edu.ratio", "lab.ratio", "exp.life", "exp.educ", "GNI", "Mat.Mor", "Adol.BR", "Rep.pct")

# select the 'keep' columns
human <- select(human, one_of(keep))

dim(human)
#195 cases and 9 variables left

# 3. Remove all rows with missing values (1 point).

# filter out all rows with NA values
human <- filter(human, complete.cases(human)==TRUE)
dim(human)
#162 cases, 19 variables

# 4. Remove the observations which relate to regions instead of countries. (1 point)

#last 7 observations seem to be associated with continents or other groups of countries
#Niger is the last real country
tail(human,n=10)

# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]

dim(human)
tail(human,n=5)
#N=155, looks OK

# 5. Define the row names of the data by the country names and remove the country name column from 
# the data. The data should now have 155 observations and 8 variables. Save the human data in 
# your data folder including the row names. You can overwrite your old ‘human’ data. (1 point)

# add countries as rownames
rownames(human) <- human$Country

# remove the Country variable
human <- select(human, -Country)

dim(human)
#N=155, 8 variables.

#Saving R data object into permanent data file
write.table(human, file="./data/human.rData")
