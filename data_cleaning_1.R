

dat <- read.csv("data_cleaning_GK_bird.csv", header=T)
head(dat)
str(dat)

# all values between 0 - 100, 501 - 600, 1001 - 1100, 1501 - 1600     = 1 
# all values between 101 - 200, 601 - 700, 1101 - 1200, 1601 - 1700,  = 2 
# all values between 201 - 300, 701 - 800, 1201 - 1300, 1701 - 1800   = 3 
# all values between 301 - 400, 801 - 900, 1301 - 1400, 1801 - 1900   = 4 
# all values between 401 - 500, 901 - 1000, 1401 - 1500, 1901 - 2000  = 5

################################################################################

library(dplyr)

# Assign categories
df <- dat %>%
  mutate(B = case_when(
    between(Dist_m, 0, 100) | between(Dist_m, 501, 600) | between(Dist_m, 1001, 1100) | between(Dist_m, 1501, 1600) ~ 1,
    between(Dist_m, 101, 200) | between(Dist_m, 601, 700) | between(Dist_m, 1101, 1200) | between(Dist_m, 1601, 1700) ~ 2,
    between(Dist_m, 201, 300) | between(Dist_m, 701, 800) | between(Dist_m, 1201, 1300) | between(Dist_m, 1701, 1800) ~ 3,
    between(Dist_m, 301, 400) | between(Dist_m, 801, 900) | between(Dist_m, 1301, 1400) | between(Dist_m, 1801, 1900) ~ 4,
    between(Dist_m, 401, 500) | between(Dist_m, 901, 1000) | between(Dist_m, 1401, 1500) | between(Dist_m, 1901, 2000) ~ 5,
    TRUE ~ NA_integer_
  ))

# View the updated data frame
df

write.csv(df, file="data_cleaning_GK_bird_segmentation1.csv", row.names=F)

################################################################################

# Contract Latin names by picking first four letters of Genus and species names

lat <- read.csv("data_cleaning_GK_bird_Latin_name_contraction.csv", header=T)
head(lat)
str(lat)

library(tidyr)

# Split the Latin names column into two separate columns
lat_split <- lat %>%
  separate(Latin_name, into=c("First_Name", "Second_Name"), sep=" ")
str(lat_split)

# Extract the first four letters from both names and combine them in uppercase
lat_split$new_column <- toupper(substr(lat_split$First_Name, 1, 4)) 
lat_split$new_column <- paste(lat_split$new_column, toupper(substr(lat_split$Second_Name, 1, 4)), sep="")

head(lat_split)
str(lat_split)

write.csv(lat_split, file="data_cleaning_GK_bird_Latin_name_contraction_RESULTS.csv", row.names=F)


