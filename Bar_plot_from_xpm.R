
setwd("/Users/ibrahimimam/Desktop/Paper_materials/protein/sim_out/L858R-L792H/")


# Load necessary libraries
library("ggplot2")
library(tidyverse)
library(dbplyr)

# Read .xpm file
data_set=read.table(file="L858R-L792H-862-ss.xpm", skip=22, sep='\n')

# Extract the text values from the dataframe
input_strings <- data_set$V1

# Clean and process the text data
cleaned_strings <- gsub("[\n,0-9]", "", input_strings)

# Extract individual letters
letters <- unlist(strsplit(cleaned_strings, ""))

# Count the occurrences of each letter
letter_counts <- table(letters)/length(letters)

# Create a data frame
letter_data <- data.frame(DSSP = names(letter_counts), count = as.numeric(letter_counts))

# Rename letters
letter_data <- letter_data %>% 
  mutate(DSSP = recode(DSSP, 'E' = "B-Sheet", B = "B-Bridge", '~'="Coil", S="Bend", 'T'="Turn", H="A-Helix",
                         I="5-Helix", G="3-Helix"))

my_colors <- c("B-Sheet" = "red", "B-Bridge" = "black", "Coil"="white", "Bend"="green", "Turn"="yellow", "A-Helix"="blue",
               "5-Helix"="purple", "3-Helix"="grey")

# Create a plot with custom colors, white background, and border
ggplot(letter_data, aes(x = DSSP, y = count, fill = DSSP)) +
  geom_bar(stat = "identity", color = "black") +
  scale_fill_manual(values = my_colors) +
  labs(title = "", x = "Secondary Structure", y = "Proportion") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "white", color = "black", size = 1)
  )

# Save the plot in high resolution (600 DPI)
#ggsave("/Users/ibrahimimam/Desktop/Paper_materials/protein/sim_out/L858R-862-ss.png", plot = p, dpi = 600)
