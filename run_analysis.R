#
# Step 0:  Set the correct working directory
#
setwd("C:/Coursera/Get and Clean up the data/Project/UCI HAR Dataset")
features <- read.table("features.txt", stringsAsFactors=FALSE)

# Step 1: Merge the training and test sets to create one data set
#   1a) for training
#	X-train contains 561 records with length 16 per row (7352 rows)
#	Y-train contains the training label for each x-train row (7253 rows)
#	subject-train.txt contains the subject ID, each for each X-train row (7352 rows)
#
   trainx <- read.fwf("train/X_train.txt", widths=c(rep(16, 561)), n=10)
   
   testx <- read.fwf("train/X_train.txt", widths=c(rep(16, 561)), n=10)
   

