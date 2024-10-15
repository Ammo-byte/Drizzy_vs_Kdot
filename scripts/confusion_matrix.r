# Load the dataset from the CSV file (replace with the correct path if needed)
kvd_data <- read.csv("data/kendrick_v_drake.csv", header = TRUE, stringsAsFactors = TRUE)

# Create a binary column to represent the artist: 1 for Kendrick, 0 for Drake
kvd_data$Artist_Group_Bin <- NA
kvd_data$Artist_Group_Bin[1:128] <- 1  # Kendrick's songs
kvd_data$Artist_Group_Bin[129:269] <- 0  # Drake's songs

# Convert song plays to millions for easier interpretation
kvd_data$Plays_mil <- kvd_data$Plays / 1e6  # Plays in millions

# Helper function: Find the nearest neighbor for a given value 'x'
nearest_neighbour <- function(v, x) {
  len <- length(v)  # Length of the input vector
  diff <- abs(v[1] - x)  # Initial difference
  list_pos <- list()  # Initialize a list to store nearest neighbor indices

  # Loop through the vector to find the closest value(s)
  for (i in 1:len) {
    if (diff > abs(v[i] - x)) {
      diff <- abs(v[i] - x)  # Update the minimum difference
      list_pos <- list(i)  # Store the new closest index
    } else if (diff == abs(v[i] - x)) {
      list_pos <- append(list_pos, i)  # Add the index if there's a tie
    }
  }
  return(unlist(list_pos))  # Return the nearest neighbor positions as a vector
}

# Helper function: Determine the majority class (1 or 0) from a list
majority <- function(list) {
  a <- sum(list == 1)  # Count of Kendrick's songs (1)
  b <- sum(list == 0)  # Count of Drake's songs (0)

  # Return the majority class, with ties favoring Kendrick (1)
  if (a >= b) return(1) else return(0)
}

# kNN function: Classify each song based on the nearest neighbors
knn <- function(vx, vy, k) {
  final_list <- list()  # Initialize a list to store predictions

  # Loop through each element in the input vector
  for (i in 1:length(vx)) {
    vx1 <- vx[-i]  # Exclude the current element (leave-one-out)
    vy1 <- vy[-i]  # Exclude the corresponding label

    neighbors <- list()  # Temporary list for neighbors

    # Find 'k' nearest neighbors
    for (j in 1:k) {
      val <- nearest_neighbour(vx1, vx[i])  # Get the nearest neighbor index
      neighbors <- append(neighbors, vy1[val[1]])  # Store the corresponding label
      vx1 <- vx1[-val[1]]  # Remove the used neighbor
      vy1 <- vy1[-val[1]]  # Remove the corresponding label
    }

    # Store the majority class of the 'k' neighbors
    final_list <- append(final_list, majority(unlist(neighbors)))
  }

  return(unlist(final_list))  # Return the predictions
}

# Prepare the input features and labels
x <- kvd_data$Plays_mil  # Feature: Song plays in millions
y <- kvd_data$Artist_Group_Bin  # Label: 1 for Kendrick, 0 for Drake

# Set the number of neighbors (k)
k <- 5

# Run the kNN function to get predictions
results <- knn(x, y, k)

# Initialize variables to store confusion matrix values
TP <- 0  # True Positive: Kendrick predicted correctly
FN <- 0  # False Negative: Kendrick predicted as Drake
FP <- 0  # False Positive: Drake predicted as Kendrick
TN <- 0  # True Negative: Drake predicted correctly

# Loop through predictions and labels to compute the confusion matrix
for (i in 1:length(y)) {
  if (y[i] == 1 & results[i] == 1) TP <- TP + 1  # True Positive
  if (y[i] == 1 & results[i] == 0) FN <- FN + 1  # False Negative
  if (y[i] == 0 & results[i] == 0) TN <- TN + 1  # True Negative
  if (y[i] == 0 & results[i] == 1) FP <- FP + 1  # False Positive
}

# Create the confusion matrix
confusion_matrix <- matrix(
  c(TP, FN, FP, TN),  # Fill the matrix with counts
  nrow = 2,  # 2 rows (Actual Kendrick and Actual Drake)
  byrow = TRUE  # Fill the matrix by row
)

# Add column and row names for clarity
colnames(confusion_matrix) <- c("Predicted Kendrick", "Predicted Drake")
rownames(confusion_matrix) <- c("Actual Kendrick", "Actual Drake")

# Print the confusion matrix
print(confusion_matrix)

# Example output:
#                 Predicted Kendrick Predicted Drake
# Actual Kendrick                 84               44
# Actual Drake                    38              103