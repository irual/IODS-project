# Lauri Sillanmäki 11.11.2020, IODS 2020, RStudio Exercise 3 DM. 
# Data import and management of Student performance data from Center for Machine Learning and Intelligent Systems at the University of California, Irvine.
# Secondary school student alcohol consumption in Portugal (P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance.)
# Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance
# Data description: https://archive.ics.uci.edu/ml/datasets/Student+Performance#

#setwd("~/R/projekteja/IODS-project")
#getwd()

# Load UCI CML ML Data from the web and unzip it
source <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip"
target <- "~/data/student.zip"

download.file(source,target)
unzip(target,exdir="~/data/student")

#3. Read both student-mat.csv and student-por.csv into R (from the data folder) and explore the structure and dimensions of the 
#data. (1 point)

math <- read.table("~/data/student/student-mat.csv", sep=";", header=TRUE)
por  <- read.table("~/data/student/student-por.csv", sep=";", header=TRUE)

str(math)
str(por)

#4. Join the two data sets using the variables "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", 
#"Fjob", "reason", "nursery","internet" as (student) identifiers. Keep only the students present in both data sets. Explore 
#the structure and dimensions of the joined data. (1 point)

# access the dplyr library
library(dplyr)

#Data camp script yields wrong number of cases. Using script from Reijo Sund instead.

#-------------------------
# Function from Reijo Sund
#-------------------------

# Define own id for both datasets
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be successful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

#-------------------------
# Reijo Sund part ends...
#-------------------------

# see the new column names
colnames(pormath)

# glimpse at the data
glimpse(pormath)
#370 cases, 51 variables, this is OK. Suffix "m" refers to math data, "p" to por data. 
#Suffixes are used when similar variables has not been identical in both datasets.

#Saving R data object into permanent data file
write.table(pormath, file="./data/alc.rData")


