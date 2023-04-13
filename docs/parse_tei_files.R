library(tei2r)
library(stringr)

# set working directory (folder with files to process)
# (the path might be different on your computer)
setwd("docs/letters_Der_Sturm/")

# create list that contains names of all xml-files in folder
files = list.files(pattern="*.xml")

# create an empty list with length equal to the amount of files to process
parsed_files <- vector(mode = "list", length = length(files))

# create a loop that does the following exactly n times, where "n" is the length of
# files to process; in the current example, this is "45", so for all files from
# file 1 to file 45, do:
for (i in 1:length(files)){
# create a list within every list entry (i.e. for every file)
# and fill it with the content of the node "placeName",
# using the function parseTEI() from package "tei2r":
  parsed_files[[i]] <- paste(parseTEI(files[i], node = "placeName"))
}

# as nested lists are not so handy, unlist it: 
# instead of 45 list entries that contain a list each, 
# flatten the list format and write the entries of the sublists
# one after the other, creating one long list with the name "parsed_files_unlisted"
parsed_files_unlisted <- unlist(parsed_files)

# take the unlisted file (which is still a list) and create a data frame out of it, 
# using the functions matrix() and as.data.frame(), with a resulting data frame
# "df_parsed_files"
df_parsed_files <- as.data.frame(matrix(parsed_files_unlisted,nrow=length(parsed_files_unlisted),byrow=TRUE))

# rename column
colnames(df_parsed_files) <- "Address"

# remove all rows with entry "Unknown"
df_parsed_files_na <-subset(df_parsed_files, Address!="Unknown")

# remove superfluous whitespace in column "place" 
# with function str_squish() from package "stringr"
df_parsed_files_na$Address <- str_squish(df_parsed_files_na$Address)

# save file as csv for further processing
write.csv(df_parsed_files_na, "place_names_letters.csv")





# test: remove tags from files
library(xml2)
doc <- read_xml("Documents/GitHub/digital_history_intro/docs/letters_Der_Sturm/Q.01.19151106.FMA.01.xml")
text <- xml_text(doc)
text <- str_remove_all(text, "<.*?>")
