# run_analysis.R

# Coursera JHS - Getting and Cleaning Data Course Project - week 4

# This R-script does the following: 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.

# See codebook.md for description of data
# See README.md for further explantion of scripts

## Skipping setting the working directory and downloading files as submission says:
## "Code should have a file run_analysis.R in the main directory that can be run as long as the Samsung data is in your working directory"
## As the file unzips into a directory named "UCI HAR Dataset" it is assumed that this directory exists in the working directory. 

#### 1. Merges the training and the test sets to create one data set.####

#1.1 Reads the test data into one dataframe
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt")
varsTest <- read.table("UCI HAR Dataset/test/X_test.txt")
testDf <- cbind(subjectTest, activityTest, varsTest)

#1.2 Reads the train data into one dataframe
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
varsTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
trainDf <- cbind(subjectTrain, activityTrain, varsTrain)

#1.3 Combines training and test sets
mainDf <- rbind(testDf, trainDf)

#1.4 Sets the name for the colums subject, activity and the rest from features.txt
namesDf <- read.table("UCI HAR Dataset/features.txt")
namesC <- c(as.character(namesDf$V2))
colnames(mainDf) <- c("subject", "activity", namesC)

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.#### 

# 2.1. Create vector with column numbers that includes mean and std. 

mstd <- grep("std\\()|mean\\()", names(mainDf), ignore.case = TRUE)

# 2.2. Create a new dataframe with only the mean and standard deviation using vectors created, include subject and activity (1 and 2)

mstdDf <- mainDf[, c(1, 2, mstd)]

#### 3. Uses descriptive activity names to name the activities in the data set #### 

# 3.1. Read in the names of activities from 'activity_labels.txt' to a data frame
# Change activity to factor, give it the correct labels
activityLabelsDf <- read.table("UCI HAR Dataset/activity_labels.txt")
activities <- factor(mstdDf$activity)
levels(activities) <- activityLabelsDf[,2]
mstdDf$activity <- activities

#### 4. Appropriately labels the data set with descriptive variable names. ####

# 4.1 Extend the abbreviations, remove dashes and paranthesis

names(mstdDf)<-gsub("\\-std\\()", "Sd", names(mstdDf))
names(mstdDf)<-gsub("\\-mean\\()", "Mean", names(mstdDf))
names(mstdDf)<-gsub("^t", "time", names(mstdDf))
names(mstdDf)<-gsub("^f", "frequency", names(mstdDf))
names(mstdDf)<-gsub("Acc", "Accelerometer", names(mstdDf))
names(mstdDf)<-gsub("Gyro", "Gyroscope", names(mstdDf))
names(mstdDf)<-gsub("Mag", "Magnitude", names(mstdDf))
names(mstdDf)<-gsub("BodyBody", "Body", names(mstdDf))
names(mstdDf)<-gsub("-", "", names(mstdDf))

#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. #### 
# 5.1 Load the reshape library, melt the dataset
library("reshape2")
tidyDf <- melt(mstdDf, id.vars=c("subject", "activity"))

# 5.2 Create a new df, cast it with the mean
outputDf = dcast(tidyDf, subject + activity ~ variable, mean)

## 5.3 Output data to output.txt
# For the output data, add a prefix "mean-" to the measurevariables
n <- ncol(outputDf)
colnames(outputDf)[3:n] <- paste("mean-", colnames(outputDf)[3:n], sep = "")
write.table(outputDf, file ="output.txt", row.name=FALSE)