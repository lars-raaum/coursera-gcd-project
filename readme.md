Readme.md
# Coursera JHS - Getting and Cleaning Data Course Project - week 4
Clean up and summarization for smart phone sensor data. 

This repo contains: 
- The dataset output.txt
- Data is documented in codebook.md
- A script named run_analysis.R that transforms the original data into tidydata.txt 
- The details of the cleaning operations carried out in the script is documented in this readme.md (It was unclear to me where to put details - in codebook or readme, I have opted for a high-level description in codebook and a detailed description in the readme)

Acknowledgment: 
In the work with this project, David Hoods blog post that was linked in the forums, was highly useful
( https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/ ) Thanks!

The rscript run_analysis.R does the following: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average 
of each variable for each activity and each subject.

## 1. Merges the training and the test sets to create one data set.
This is achieved by the following steps: 
1.1 Reads the different datasets
The following datasets read for both test and train:
- The X-dataset the set / features
- The y-dataset contains the id for the activity
- The subject contains the id for the subject performing the activity
- Inertial Signals-datasets are not necessary to read as the end goal for the end data set is just to collect the mean and Sd of each measurement.My interpretation is that they are included in the aggregate measurs in the X-dataset.

1.2 Reads the test data into one dataframe
1.3 Reads the train data into one dataframe
1.4 Combines training and test data frame into one data frame
1.4 Sets the name for the colums subject, activity and the rest from features.txt

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
From the documentation we can see that the data contains several means and standard deviation variables. Inclusion of all means and sds could be interpreted as all the variables labeled with mean or std.

All of these could be extracted by:
m <- grep("mean", names(mainDf), ignore.case = TRUE)
std <- grep("std", names(mainDf), ignore.case = TRUE)

However, this would in my opinion be a to wide definition. 
- The angle(). is defined in the documentation as the Angle between to vectors.
These are not means of the actual measurements / signals. They should therefore not be extracted. The meanFreq variables are also excluded. 

The variables to be extracted are therefore the ones containing: 
mean(): Mean value
std(): Standard deviation

2.1. Create vectors with column numbers that includes mean and std. 
mstd <- grep("std\\()|mean\\()", names(mainDf), ignore.case = TRUE)

2.2. Create a new dataframe with only the mean and standard deviation using vectors created, include subject and activity (1 and 2)

## 3. Uses descriptive activity names to name the activities in the data set
The mainDf-dataframe only contains a number for the acticity. The activity names can be found in the 'activity_labels.txt' that contains the number of the activity and the corresponding label.

3.1. Read in the names of activities from 'activity_labels.txt' to a data frame 
3.2  Create a factor of the activity column and assign the labels

## 4. Appropriately labels the data set with descriptive variable names
4.1 Extend the abbreviations, remove dashes and paranthesis
The original data has several abbrevations. They are replaced with their full meaning (eg gyro = gyroscope, t = time)
From the documentation of the data, we know that the variable names include spaces, paranthesis and dashes. These should be cleaned up. There is also a errror, where Body is duplicated to BodyBody

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
The principles of tidy data: 
1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

5.1 Load the reshape library, melt the dataset
5.2 Create a new df, cast it with the mean

5.3 Output data to output.txt
For the output data, add a prefix "mean-" to the measurevariables.
It is not clear for the reader of the dataset that these are the means, unless this is clarified in the column names.
