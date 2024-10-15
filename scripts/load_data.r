# Load the dataset from the CSV file (assuming it's in the data/ directory)
kvd_data <- read.csv("data/kendrick_v_drake.csv", header = TRUE, stringsAsFactors = TRUE)

# Assign a song index to each row (for plotting purposes)
kvd_data$song_index <- seq_along(kvd_data$Title)  # Index from 1 to 269

# Split the data into Kendrick and Drake subsets based on song indices
kendrick_plays <- kvd_data[1:128, ]  # First 128 rows belong to Kendrick Lamar
drake_plays <- kvd_data[129:269, ]   # Remaining rows belong to Drake