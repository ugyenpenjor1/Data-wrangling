

library(dplyr)

dat <- read.csv("data_raw.csv", header=T)
str(dat)

################################################################################

# Create a new column 'Species' that combines data from columns Primates, Bovids, Carnivores, PangolinRodent and Human
dat <- dat %>%
  rowwise() %>%
  mutate(species=paste(Primates, Bovids, Carnivores, PangolinRodent, Human, sep="")) %>%
  ungroup()
str(dat)

write.csv(dat, file="raw_new_species_col.csv")

################################################################################

# Export data for each camera station/site

# Split the data frame into a list of subsets based on the values in the 'RelativePath' column. 
# Each subset will contain rows with the same 'RelativePath' value.

# Split the data frame based on the 'RelativePath' column
data_list <- split(dat, dat$RelativePath)
data_list

# Export each subset as a separate CSV file - specifying destination folder as well as prefix (CT_)
for(i in seq_along(data_list)){
  csv_file <- paste0("path/CT_", names(data_list)[i], ".csv")
  write.csv(data_list[[i]], file=csv_file, row.names=FALSE)
}

# List the exported CSV files
list.files(path="", pattern="CT_.*\\.csv")

################################################################################
