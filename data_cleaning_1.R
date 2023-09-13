
# Data wrangling

dat <- read.csv("GK_bird_RAW.csv", header=T)
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
  mutate(Rep=case_when(
    between(Dist_m, 0, 100) | between(Dist_m, 501, 600) | between(Dist_m, 1001, 1100) | between(Dist_m, 1501, 1600) ~ 1,
    between(Dist_m, 101, 200) | between(Dist_m, 601, 700) | between(Dist_m, 1101, 1200) | between(Dist_m, 1601, 1700) ~ 2,
    between(Dist_m, 201, 300) | between(Dist_m, 701, 800) | between(Dist_m, 1201, 1300) | between(Dist_m, 1701, 1800) ~ 3,
    between(Dist_m, 301, 400) | between(Dist_m, 801, 900) | between(Dist_m, 1301, 1400) | between(Dist_m, 1801, 1900) ~ 4,
    between(Dist_m, 401, 500) | between(Dist_m, 901, 1000) | between(Dist_m, 1401, 1500) | between(Dist_m, 1901, 2000) ~ 5,
    TRUE ~ NA_integer_
  ))

# View the updated data frame
View(df)

write.csv(df, file="data_cleaning_GK_bird_Rep_created_120923.csv", row.names=F)

################################################################################

# Contract Latin names by picking first four letters of Genus and species names

#lat <- read.csv("data_cleaning_GK_bird_Latin_name_contraction.csv", header=T)
lat <- df
# lat$scientific_name <- df$Latin_name
# lat$check <- ifelse(lat$Latin_name == lat$scientific_name, 1, 0)
head(lat)
str(lat)

library(tidyr)

# Split the Latin names column into two separate columns
lat_split <- lat %>%
  separate(Latin_name, into=c("First_Name", "Second_Name"), sep=" ")
str(lat_split)

# Extract the first four letters from both names and combine them in uppercase
lat_split$new_column <- toupper(substr(lat_split$First_Name, 1, 4)) 
lat_split$new_column <- paste(lat_split$new_column, toupper(substr(lat_split$Second_Name, 1, 5)), sep="")

head(lat_split)
str(lat_split)

count_dh <- lat_split[, c(5, 28, 27, 18)]
head(count_dh)

write.csv(lat_split, file="data_cleaning_GK_bird_Rep_Latin_name_contracted_120923.csv", row.names=F)
write.csv(count_dh, file="GK_bird_count_120923.csv", row.names=F)

################################################################################

# Extract only unique species names and produce contraction for the list

#sps <- read.csv("GK_bird_raw_species_list.csv", header=T)
sps <- cbind(lat_split, "Latin_name"=df$Latin_name)
sps <- lat_split
head(sps)
str(sps)

spsls <- unique(sps$scientific_name)
length(spsls)
str(spsls)

# Create a new data frame with only unique individuals
unique_lat <- !duplicated(sps$scientific_name)
str(unique_lat)

unique_df <- subset(sps, unique_lat)
str(unique_df)

sps <- unique_df[, c(28, 12, 13)]
head(sps)

write.csv(unique_df, file="data_cleaning_GK_bird_Rep_Latin_name_contracted_unique_sps_list_120923.csv", row.names=F)
write.csv(sps, file="GK_bird_species_120923.csv", row.names=F)

################################################################################

# Check for mismatches
( mismatches <- unique(lat_split$new_column) != unique_df$new_column ) # should be all FALSE

# Display elements in column 1 that don't match column 2
( mismatched_elements <- unique(lat_split$new_column)[mismatches] ) # should be 0

################################################################################

# Prepare unique site with site characteristics

site <- read.csv("GK_bird_raw_sites.csv", header=T)
head(site)
str(site)

# Create a new data frame with only unique sites
unique_site <- !duplicated(site$seg_1)
str(unique_site)

# Extract only unique sites
site_fin <- subset(site, unique_site)
str(site_fin)

write.csv(site_fin, file="GK_bird_unique_sites_final.csv", row.names=F)

################################################################################
