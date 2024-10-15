# Source the load_data.R script to load and prepare the data
source("scripts/load_data.R")

# Display summary statistics for Kendrick's plays to verify the data
summary(kendrick_plays$Plays)

# Display summary statistics for Drake's plays
summary(drake_plays$Plays)

# Set up the plotting area to display two plots side-by-side
par(mfrow = c(1, 2))  # 1 row, 2 columns of plots

# Create the boxplot for Kendrick Lamar's song plays
# We divide the plays by 1 million (1e6) to improve readability on the Y-axis
boxplot(
  kendrick_plays$Plays / 1e6,             # Kendrick's plays in millions
  xlab = "Songs with Kendrick",           # X-axis label
  ylab = "Plays in millions",             # Y-axis label
  main = "Number of Plays for Kendrick"   # Title of the plot
)

# Create the boxplot for Drake's song plays
# Plays are also divided by 1 million for consistency with Kendrick's plot
boxplot(
  drake_plays$Plays / 1e6,                # Drake's plays in millions
  xlab = "Songs with Drake",              # X-axis label
  ylab = "Plays in millions",             # Y-axis label
  main = "Number of Plays for Drake"      # Title of the plot
)

# Reset the plotting area to the default (1 row, 1 column) for future plots
par(mfrow = c(1, 1))