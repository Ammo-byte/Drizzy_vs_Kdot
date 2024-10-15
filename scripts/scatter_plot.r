# Load library
library(scales)

# Source the load_data.R script to load and prepare the data
source("scripts/load_data.R")

# Reindex song indices to start from 1 for both artists
kendrick_plays$song_index <- seq_along(kendrick_plays$Title)  # 1 to 128
drake_plays$song_index <- seq_along(drake_plays$Title)  # 1 to 141

# Set up the plotting area
par(mar = c(5, 5, 4, 2) + 0.1)  # Adjust plot margins

# Plot Kendrick's songs
plot(
  jitter(kendrick_plays$song_index, factor = 3),  # Jittered indices to avoid overlap
  kendrick_plays$Plays / 1e6,  # Convert plays to millions
  col = alpha("blue", 0.5),  # Semi-transparent blue points
  pch = 19,  # Solid circle points
  xlab = "Song Index",  # X-axis label
  ylab = "Artist Plays in millions",  # Y-axis label
  main = "Number of Plays: Drake vs Kendrick",  # Plot title
  xlim = c(0, max(nrow(kendrick_plays), nrow(drake_plays))),  # Adjust X-axis limit
  ylim = c(0, 2200)  # Y-axis limit based on max plays
)

# Add Drake's songs to the plot
points(
  jitter(drake_plays$song_index, factor = 3),  # Jittered indices to avoid overlap
  drake_plays$Plays / 1e6,  # Convert plays to millions
  col = alpha("red", 0.5),  # Semi-transparent red points
  pch = 19  # Solid circle points
)

# Add legend to differentiate between the two artists
legend(
  "topright",  # Position of the legend
  legend = c("Kendrick Lamar", "Drake"),  # Labels for the legend
  col = alpha(c("blue", "red"), 0.5),  # Colors matching the points
  pch = 19  # Solid circle points
)