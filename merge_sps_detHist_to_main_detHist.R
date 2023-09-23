

# Load the required library
library(dplyr)

# Read the two CSV files
spsDH <- read.csv("sps.csv")
mainDH <- read.csv("main.csv")


################################################################################
################################################################################
################################################################################

# For one CSV file

# Create a new data frame by copying CSV 2
new_data <- mainDH

# Copy data from CSV 1 to the corresponding rows in the new data frame where 'stn' matches
matching_stn <- mainDH$stn %in% spsDH$stn
matching_rows <- spsDH[spsDH$stn %in% mainDH$stn, ]

# Merge matching rows based on 'stn' and update columns 2 to the end
new_data[matching_stn, 2:ncol(new_data)] <- matching_rows[match(new_data$stn[matching_stn], matching_rows$stn), -1]

# Save the new data as a new CSV file
write.csv(new_data, "path/to/output.csv", row.names = FALSE)

################################################################################
################################################################################
################################################################################

# For a bunch of CSV files

# List of CSV 1 file paths (update with the actual file paths)
csv1_files <- list(
  "sps.csv",
  "sps2.csv",
  "sps3.csv",
  "sps4.csv",
  "sps5.csv"
  # Add more CSV 1 file paths as needed
)

# Loop through each CSV 1 file
for (csv1_file_path in csv1_files) {
  # Read the current CSV 1 file
  csv_file1 <- read.csv(csv1_file_path)
  
  # Create a new data frame by copying CSV 2
  new_data <- mainDH
  
  # Copy data from CSV 1 to the corresponding rows in the new data frame where 'stn' matches
  matching_stn <- mainDH$stn %in% csv_file1$stn
  matching_rows <- csv_file1[csv_file1$stn %in% mainDH$stn, ]
  
  # Merge matching rows based on 'stn' and update columns 2 to the end
  new_data[matching_stn, 2:ncol(new_data)] <- matching_rows[match(new_data$stn[matching_stn], matching_rows$stn), -1]
  
  # Extract the CSV 1 file name (without extension) to use in the output file name
  csv1_file_name <- tools::file_path_sans_ext(basename(csv1_file_path))
  
  # Save the new data as a new CSV file
  write.csv(new_data, paste0("output_", csv1_file_name, ".csv"), row.names = FALSE)
}


################################################################################
################################################################################
################################################################################

# For hundreds of CSV files

# Set the paths to the folder containing your CSV files
folder_path <- "E:/UgyenP/myDocs/SEASIA_DATA/A_Merge_species/wrangling_230623/test_230923/input"

# Set the path to save the output files
output_path <- "E:/UgyenP/myDocs/SEASIA_DATA/A_Merge_species/wrangling_230623/test_230923/output"

# List all CSV files in the specified folder
csv1_files <- list.files(path=folder_path, pattern="\\.csv$", full.names=TRUE)

# Read CSV 2 as the template data frame
csv2_template <- read.csv("main.csv")

# Loop through each CSV 1 file
for (csv1_file_path in csv1_files) {
  # Read the current CSV 1 file
  csv_file1 <- read.csv(csv1_file_path)
  
  # Create a new data frame by copying CSV 2
  new_data <- csv2_template
  
  # Copy data from CSV 1 to the corresponding rows in the new data frame where 'stn' matches
  matching_stn <- csv2_template$stn %in% csv_file1$stn
  matching_rows <- csv_file1[csv_file1$stn %in% csv2_template$stn, ]
  
  # Merge matching rows based on 'stn' and update columns 2 to the end
  new_data[matching_stn, 2:ncol(new_data)] <- matching_rows[match(new_data$stn[matching_stn], matching_rows$stn), -1]
  
  # Extract the CSV 1 file name (without extension) to use in the output file name
  csv1_file_name <- tools::file_path_sans_ext(basename(csv1_file_path))
  
  # Save the new data as a new CSV file in the same folder with a name based on the CSV 1 file
  output_file_path <- file.path(output_path, paste0("output_", csv1_file_name, ".csv"))
  write.csv(new_data, output_file_path, row.names=FALSE)
}

################################################################################
################################################################################
################################################################################
