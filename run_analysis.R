
#
# Step 0:  
#	Set the correct working directory
#	Load the libraries needed
#	read in the common files for both train and test data
#
setwd("C:/Coursera/Get and Clean up the data/Project/UCI HAR Dataset")
library(dplyr)
library(reshape2)

features <- read.table("features.txt", stringsAsFactors=FALSE)
activity_labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)

#
# Step 1: Merge the training and test sets to create one data set
#   1a) for training
#	X_train.txt contains 561 records with length 16 per row (7352 rows)
#	y_train.txt contains the training label for each x-train row (7253 rows)
#	subject_train.txt contains the subject ID, each for each X-train row (7352 rows)
#
#	The measured columns are the column names containing  "-mean()" and "-std()", but not "-meanFreq()"
#
#
   trainx <- read.table("train/X_train.txt")					# read in the X_train.txt
   names(trainx) <- features[, 2]						# assign the column names
   train_measured <- trainx[, grepl("(-mean[^F]|-std)", names(trainx))]		# select the measured columns
   
   subject_train <- read.table("train/subject_train.txt")			# read in the corresponding subject ID
   train_activity <- read.table("train/y_train.txt")				# read in the corresponding activity code
   
   #
   #	do column Combine the subject_train, train_activity and train_measured to create dataset train
   #
   train <- cbind(subject=subject_train, activity=train_activity, train_measured)	
   names(train)[1] <- "subject"							# set the column name 1 as "subject"
   names(train)[2] <- "activity"						# set the column name 2 as "activity"
   train_activityLabel <- activity_labels[train$activity, ]			# Map the activity code to activity label
   
   #
   #	do column Combine the subject, activityLabel and train_measured to create dataset train2
   #   
   train2 <- cbind(subject=train[, 1], activityLabel = train_activityLabel[, 2], train[, -c(1,2)])

#   
#   1b) for test
#	X_test.txt contains 561 records with length 16 per row (2947 rows)
#	y_test.txt contains the testing label for each x-test row (2947 rows)
#	subject_test.txt contains the subject ID, each for each X_test row (2947 rows)
#
#	The measured columns are the column names containing  "-mean()" and "-std()", but not "-meanFreq()"
#
#
   testx <- read.table("test/X_test.txt")					# read in the X_test.txt
   names(testx) <- features[, 2]						# assign the column names
   test_measured <- testx[, grepl("(-mean[^F]|-std)", names(testx))]		# select the measured columns
   
   subject_test <- read.table("test/subject_test.txt")				# read in the corresponding subject ID
   test_activity <- read.table("test/y_test.txt")				# read in the corresponding activity code
   
   #
   #	do column Combine the subject_test, test_activity and test_measured to create dataset test
   #
   test <- cbind(subject=subject_test, activity=test_activity, test_measured)	
   names(test)[1] <- "subject"							# set the column name 1 as "subject"
   names(test)[2] <- "activity"							# set the column name 2 as "activity"
   test_activityLabel <- activity_labels[test$activity, ]			# Map the activity code to activity label
   
   #
   #	do column Combine the subject, activityLabel and test_measured to create dataset test2
   #   
   test2 <- cbind(subject=test[, 1], activityLabel = test_activityLabel[, 2], test[, -c(1,2)])

#
#  1c) do row combine the train2 and test2 dataset as myData (10299 rows)
#     
   myData <- rbind(train2, test2)
   
   
#
#   Step 2: 
#    
   varList <- names(myData)    	# get all columns names
   varList <- varList[3:length(varList)]   # exclude the first two columns, which will be used as keys
   Molten <- melt(myData, id.vars = c("subject", "activityLabel"), measure.vars = varList)
   final <- dcast(Molten, subject + activityLabel ~ variable, mean)
#
#  Step 3:
#	Write out the final data set as "tidydata.txt"
#
   write.table(final, file="tidydata.txt", row.name=FALSE)