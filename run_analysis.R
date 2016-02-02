## ====================================================================
## Getting and Cleaning Data Course Project.
## R script performs the following
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation for each measurement.
##  3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names.
##  5. From the data set in step 4, creates a second, independent tidy data set 
##     with the average of each variable for each activity and each subject.
##
## ===================================================================
### file location
library(dplyr)
featuresFile <- "./UCI HAR Dataset/features.txt"

trainIdFile <- "./UCI HAR Dataset/train/subject_train.txt"
xtrainFile <- "./UCI HAR Dataset/train/x_train.txt"
ytrainFile <- "./UCI HAR Dataset/train/y_train.txt"

testIdFile <- "./UCI HAR Dataset/test/subject_test.txt"
xtestFile <- "./UCI HAR Dataset/test/x_test.txt"
ytestFile <- "./UCI HAR Dataset/test/y_test.txt"

## Read features file
dataHdr <- read.table(featuresFile)

## Read training data
trainId <- read.table(trainIdFile)
trainLabel <- read.table(ytrainFile)
trainSet <- read.table(xtrainFile)
trainData <- data.frame(trainId, trainLabel, trainSet)

## Read test data
testId <- read.table(testIdFile)
testLabel <- read.table(ytestFile)
testSet <- read.table(xtestFile)
testData <- data.frame(testId, testLabel, testSet)

## merge train Data and test data
mergedData <- rbind(trainData, testData)

## Add descriptive header for first 2 columns
colnames(mergedData) <- c(c("SubjectID","Activity"), as.character(dataHdr$V2))


## subset by column "SubjectID", "Activity" and column names with  mean and std
subData <- mergedData[,names(mergedData) %in% c("SubjectID","Activity") | grepl("mean",names(mergedData)) | grepl("std",names(mergedData))]


### Convert to factor and apply descriptive activity labels
### to activity column in data frame
levels <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING",
            "STANDING","LAYING")

subData$Activity <- factor(subData$Activity,labels=levels)

## 4.Update variables with descriptive names.
##
colnames(subData) <- gsub("-mean\\(\\)"," Mean",names(subData))
colnames(subData) <- gsub("-std\\(\\)"," Standard Deviation",names(subData))
colnames(subData) <- gsub("-meanFreq\\(\\)"," Mean Frequency",names(subData))
colnames(subData) <- gsub("^t","Time ",names(subData))
colnames(subData) <- gsub("^f","Frequency ",names(subData))


### 5. create a new dataset, the average of each variable for each activity and each subject. 
##
groupData <- subData  %>% group_by(SubjectID,Activity) %>% summarise_each(funs(mean))

## Write tidy data to a file.
write.table(groupData, "analysis_data.txt",row.name = FALSE)
