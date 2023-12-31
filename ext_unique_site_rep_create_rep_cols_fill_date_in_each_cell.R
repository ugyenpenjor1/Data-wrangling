
# I want to extract unique sites (removing duplicates) and create 5 columns corresponding to
# the unique values of the replicate column (temporal replication) and fill the cells with 
# Julian day

# Load data 
site <- read.csv("GK_bird_raw_sites.csv", header=T)
head(site)
str(site)

# Convert the date to Julian day
# Since the date is in uniform character format, there was no need for additional steps,
# the conversion was straightforward.
# If this is not the case, you will have to do a workaround to fix the date first.

site$Julian <- as.POSIXlt(site$Date)$yday
str(site)

#write.csv(site, file="GK_bird_sites_Julian_day.csv", row.names=F)

################################################################################

library(dplyr)
library(tidyr)

str(site)

# Extract only the required data
dat <- site[, c(3, 5, 14)]
head(dat)
str(dat)

# Pivot the data
result <- dat |>
  distinct(seg_1, Rep, .keep_all=TRUE) |>   # only keep unique site and replicate values
  pivot_wider(names_from=Rep, values_from=Julian) # fill each replicate with Julian day
View(result)
str(result)

write.csv(result, file="GK_bird_sites_Julian_day_for_replicates.csv", row.names=F)

################################################################################
