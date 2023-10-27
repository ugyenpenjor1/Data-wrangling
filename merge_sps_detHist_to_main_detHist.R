

# Load the required library
library(dplyr)

# Read the two CSV files
spsDH <- read.csv("sps.csv")
mainDH <- read.csv("main.csv")

################################################################################
################################################################################
################################################################################

# For one CSV file

# Create a new data frame by copying the main detection history
new_data <- mainDH

# Copy data from species detection history to the corresponding rows in the new data frame where 'stn' matches
matching_stn <- mainDH$stn %in% spsDH$stn
matching_rows <- spsDH[spsDH$stn %in% mainDH$stn, ]

# Merge matching rows based on 'stn' and update columns 2 to the end
new_data[matching_stn, 2:ncol(new_data)] <- matching_rows[match(new_data$stn[matching_stn], matching_rows$stn), -1]

# Save the new data as a new file
write.csv(new_data, "output.csv", row.names = FALSE)

################################################################################
################################################################################
################################################################################

# For a bunch of CSV files

# List of species det hist file paths
sps_files <- list(
  "sps.csv",
  "sps2.csv",
  "sps3.csv",
  "sps4.csv",
  "sps5.csv"
)

# Loop through each species det hist file
for(sps_file_path in sps_files){
  # Read the current species det hist file
  sps_file1 <- read.csv(sps_file_path)
  
  # Create a new data frame by copying the main det hist
  new_data <- mainDH
  
  # Copy data from species det hist to the corresponding rows in the new data frame where 'stn' matches
  matching_stn <- mainDH$stn %in% sps_file1$stn
  matching_rows <- sps_file1[sps_file1$stn %in% mainDH$stn, ]
  
  # Merge matching rows based on 'stn' and update columns 2 to the end
  new_data[matching_stn, 2:ncol(new_data)] <- matching_rows[match(new_data$stn[matching_stn], matching_rows$stn), -1]
  
  # Extract the species file name (without extension) to use in the output file name
  sps_file_name <- tools::file_path_sans_ext(basename(sps_file_path))
  
  # Save the new data as a new det hist file
  write.csv(new_data, paste0("output_", sps_file_name, ".csv"), row.names=FALSE)
}

################################################################################
################################################################################
################################################################################

# For hundreds of CSV files

# Set the paths to the folder containing your species det hist files
folder_path <- "myDocs/wrangling_230623/input"

# Set the path to save the output files
output_path <- "myDocs/wrangling_230623/output"

# List all det hist files in the specified folder
sps_files <- list.files(path=folder_path, pattern="\\.csv$", full.names=TRUE)
head(read.csv(sps_files[1]))

# Read main det hist as the template data frame
dh_template <- read.csv("main.csv")

# Find row numbers with all NAs
rows_with_all_na <- which(apply(dh_template, 1, function(row) all(is.na(row))))
rows_with_all_na # should be 0 indicating no rows have all NAs in them

# Loop through each species det hist file
for(sps_file_path in sps_files){
  # Read the current species det hist file
  sps_file1 <- read.csv(sps_file_path)
  
  # Create a new data frame by copying main det hist
  new_data <- dh_template
  
  # Copy data from species det hist to the corresponding rows in the new data frame where 'stn' matches
  matching_stn <- dh_template$stn %in% sps_file1$stn
  matching_rows <- sps_file1[sps_file1$stn %in% dh_template$stn, ]
  
  # Merge matching rows based on 'stn' and update columns 2 to the end
  new_data[matching_stn, 2:ncol(new_data)] <- matching_rows[match(new_data$stn[matching_stn], matching_rows$stn), -1]
  
  # Extract the species file name (without extension) to use in the output file name
  sps_file_name <- tools::file_path_sans_ext(basename(sps_file_path))
  
  # Save the new data as a new CSV file in the same folder with a name based on the input species file
  output_file_path <- file.path(output_path, paste0("output_", sps_file_name, ".csv"))
  write.csv(new_data, output_file_path, row.names=FALSE)
}

################################################################################
################################################################################
################################################################################
