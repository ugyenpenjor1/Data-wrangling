
# Read multiple CSV files in different paths and bind them together 

### ******************************************************************************** ###
### IMPORTANT (!): THIS SCRIPT SHOULD BE PLACED INSIDE THE "main_dir" FOLDER TO RUN ###
### ******************************************************************************** ###

# Load packages
library(dplyr)
library(readr)
library(stringr)


# Get the folder names
main_dir <- "E:/UgyenP/myDocs/SEASIA_DATA/DATA_WRANGLING_07_10_23/Final_SITES_071023/"
# Main_dir has folders for each study area containing species detection histories
# Example: Folder01_CCPF_2023-24, Folder02_PPWS_2012-13, Folder03_SWS_2019, etc
# The species name of each CSV file in each folder must be exactly the same.
# Example: CCPF_Rusa unicolor_detHist.csv, PPWS_Rusa unicolor_detHist.csv, SWS_Rusa unicolor_detHist.csv

# get the list of folders in the main directory
dir_list <- list.dirs(main_dir, full.names=F, recursive=FALSE) 
# full.names=F removes directory path
# recursive=F excludes the main directory
print(dir_list)

# Define folder names
folder_names <- dir_list


# Define the strings to search for in the file names
search_strings <- c("Axis axis", "Axis porcinus", "Arctictis binturong", "Atherurus macrourus", "Aonyx cinereus", "Acerodon mackloti",
                    "Arctonyx hoevenii", "Arctonyx collaris", "Arctogalidia trivirgata", "Aeromys thomasi",
                    "Ailurus fulgens",
                    "Bos gaurus", "Bos javanicus", "Bos taurus domesticus", "Bubalus bubalis", "Boselaphus tragocamelus", "Budorcas taxicolor",
                    "Canis aureus", "Canis familiaris domesticus", "Canis lupus familiaris", "Cuon alpinus", "Cynogale bennettii",
                    "Catopuma temminckii", "Catopuma badia",
                    "Capricornis sumatraensis", "Capricornis milneedwardsii", "Capricornis rubidus", "Capricornis thar",
                    "Callosciurus pygerythrus", "Callosciurus erythraeus", "Callosciurus notatus", "Callosciurus prevostii",
                    "Cannomys badius", "Chrotogale owstoni", "Capra aegagrus domesticus",
                    "Dremomys rufigenis", "Diplogale hosei", "Dicerorhinus sumatrensis",
                    "Elephas maximus", "Elephas maximus sumatrensis", "Elephas maximus borneensis", "Echinosorex gymnura", 
                    "Felis chaus", "Felis silvestris catus",
                    "Helarctos malayanus", "Homo sapiens", "Hylobates muelleri", "Hylobates pileatus",
                    "Hystrix brachyura", "Hystrix crassispinis", "Hystrix indica",
                    "Herpestes javanicus", "Herpestes brachyurus", "Herpestes urva", "Herpestes semitorquatus", "Herpestes edwardsii", "Herpestes smithii", "Herpestes auropunctatus",
                    "Hemigalus derbyanus", "Hyaena hyaena",
                    "Lariscus insignis", "Lariscus hosei", "Lepus peguensis", "Lepus nigricollis", "Leopoldamys Sabanus", 
                    "Lutra lutra", "Lutra sumatrana", "Lutrogale perspicillata",
                    "Macaca fascicularis", "Macaca leonina", "Macaca assamensis", "Macaca nemestrina", "Macaca arctoides", "Macaca mulatta",
                    "Muntiacus atherodes", "Muntiacus muntjak", "Muntiacus vaginalis", "Muntiacus vuquangensis", "Muntiacus montanus", "Muntiacus feae",
                    "Mustela kathiah", "Mustela nudipes", "Melogale everetti", "Melogale personata", "Menetes berdmorei", "Mustela altaica", "Mustela sibirica", "Melogale moschata",
                    "Manis javanica", "Manis pentadactyla", "Martes flavigula", "Mydaus javanensis", "Maxomys surifer", "Mellivora capensis",
                    "Melursus ursinus", "Moschus leucogaster", "Marmota himalayana",
                    "Neofelis nebulosa", "Neofelis diardi", "Nesolagus netscheri", "Nasalis larvatus", "Nycticebus menagensis",
                    "Naemorhedus goral",
                    "Ovis aries domesticus",
                    "Paguma larvata", "Paradoxurus hermaphroditus", "Pardofelis marmorata", "Petaurista philippensis", "Petaurista nobilis", "Pseudois nayaur",
                    "Prionailurus bengalensis", "Prionailurus planiceps", "Prionailurus rubiginosus", "Prionailurus viverrinus",
                    "Prionodon pardicolor", "Prionodon linsang",
                    "Pygathrix nigripes", "Pygathrix nemaeus", "Pongo pygmaeus", "Pongo abelii",
                    "Panthera tigris", "Panthera tigris sumatrae", "Panthera tigris corbetti", "Panthera pardus", "Panthera pardus delacouri", "Panthera pardus fusca",
                    "Presbytis rubicunda", "Presbytis melalophos", "Presbytis hosei",
                    "Rusa unicolor", "Rheithrosciurus macrotis", "Rhinosciurus laticaudatus", "Rhinoceros unicornis", 
                    "Rattus hoogerwerfi", "Rattus exulans", "Ratufa bicolor", "Ratufa affinis", 
                    "Sus scrofa", "Sus barbatus", "Sundasciurus hippurus", "Sundasciurus lowii", "Sus scrofa domesticus",
                    "Semnopithecus hector", "Semnopithecus schistaceus", "Symphalangus syndactylus", "Sundamys muelleri", 
                    "Tragulus kanchil", "Tragulus napu", "Tupaia belangeri", "Tupaia tana", "Tupaia glis",
                    "Trachypithecus phayrei", "Trachypithecus cristatus", "Trachypithecus obscurus", "Trachypithecus shortridgei", "Trachypithecus geei", "Trachypithecus pileatus",
                    "Tapirus indicus", "Trichys fasciculata", "Tarsius bancanus", "Tetracerus quadricornis", "Tamiops macclellandii",
                    "Ursus thibetanus", 
                    "Viverra zibetha", "Viverra megaspila", "Viverra tangalunga", "Viverricula indica", "Vulpes bengalensis", "Vulpes vulpes")

search_strings

################################################################################

# Or load a CSV with species names (no header) - a single-column CSV
# Must "character" string

species_names <- read.csv("E:/UgyenP/myDocs/SEASIA_DATA/DATA_WRANGLING_07_10_23/SiteWise_sps_list/ALL_unique_species_list.csv", header=FALSE)
class(species_names)

( sps_search <- as.character(species_names[,1]) )

( search_strings <- sps_search[-c(158, 164)] ) # these two are not needed

################################################################################

# Define column names for each CSV output
column_names <- c("stn", "o1", "o2", "o3", "o4", "o5", "o6", "o7", "o8", "o9")

################################################################################

# Combine all sites where species occur and export as CSV under a species name as file name

# Loop through each search string
for(search_string in search_strings){
  
  # Create an empty data frame to store the combined data
  combined_data <- data.frame()
  
  # Loop through each folder
  for(folder_name in folder_names){
    
    # Get the list of files in the current folder
    file_list <- list.files(path = folder_name, full.names=TRUE)
    
    # Loop through each file
    for(file in file_list){
      
      # Check if the file name contains the search string
      if(grepl(search_string, file)){
        
        # Import the file
        data <- read_csv(file)
        
        # Bind the current data with the combined data
        combined_data <- bind_rows(combined_data, data)
      }
    }
  }
  
  # Change column names
  colnames(combined_data) <- column_names
  
  # Export the combined data as a CSV file with the search string name
  file_name <- paste0(gsub(" ", "_", search_string), ".csv")
  write_csv(combined_data, file_name)
}

# You should see the progress and not an error message
