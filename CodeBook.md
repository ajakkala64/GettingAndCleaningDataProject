# Getting and Cleaning Data Course Project
####  Author : Jayarama Ajakkala
#### Date: January 31, 2016

The purpose of this project is to prepare tidy data which can be used for later analysis. Raw data from wearable device experiments conducted by SmartLab is used in the project. 
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Following data files are processed to create a tidy data set.

* features.txt  - File contains features list correspons to the data set
* subject_train.txt - File contains the subject who produced the training data
* subject_test.txt - File contains the subject who produced the test data
* x_train.txt  - File contains the train data lables indentifying the activity performed
* y_train.txt  - File contains the train data set (gyro and accelorometer reading in XYZ axis)
* x_test.txt  - File contains the test data lables indentifying the activity performed
* y_test.txt  - File contains the test data set (gyro and accelorometer reading in XYZ axis)

### 1. Merging the training and test data set

Data is downloaded and extracted in the working directory. 


```r
featuresFile <- "./UCI HAR Dataset/features.txt"

trainIdFile <- "./UCI HAR Dataset/train/subject_train.txt"
xtrainFile <- "./UCI HAR Dataset/train/x_train.txt"
ytrainFile <- "./UCI HAR Dataset/train/y_train.txt"

testIdFile <- "./UCI HAR Dataset/test/subject_test.txt"
xtestFile <- "./UCI HAR Dataset/test/x_test.txt"
ytestFile <- "./UCI HAR Dataset/test/y_test.txt"
```

Read the features list

```r
dataHdr <- read.table(featuresFile)
dim(dataHdr)
```

```
## [1] 561   2
```

```r
head(dataHdr)
```

```
##   V1                V2
## 1  1 tBodyAcc-mean()-X
## 2  2 tBodyAcc-mean()-Y
## 3  3 tBodyAcc-mean()-Z
## 4  4  tBodyAcc-std()-X
## 5  5  tBodyAcc-std()-Y
## 6  6  tBodyAcc-std()-Z
```
Read training data and create data frame from traing data set for each subject and activity.

```r
trainId <- read.table(trainIdFile)
trainLabel <- read.table(ytrainFile)
trainSet <- read.table(xtrainFile)
trainData <- data.frame(trainId, trainLabel, trainSet)
```
Read test data set and create data frame from test data set for each subject and activity.

```r
testId <- read.table(testIdFile)
testLabel <- read.table(ytestFile)
testSet <- read.table(xtestFile)
testData <- data.frame(testId, testLabel, testSet)
```
Since traing data and test data contains same variables, both came be merged into to one data set.

```r
mergedData <- rbind(trainData, testData)
```
### 2. Extract mean and standard deviation data from the mesurements.
Based on the features_info.txt, features containing "-mean()" is the mean and feature variable containing "-std()" is the standard deviation mesurement. First 2 columns of the above merged data has Subject and Activity. Remaining columns are the features measurements. In order to extract the mean and standard deviation mesurement data, first need to assign variable names to the data frame.


```r
colnames(mergedData) <- c(c("SubjectID","Activity"), as.character(dataHdr$V2))
subData <- mergedData[,names(mergedData) %in% c("SubjectID","Activity") | grepl("mean",names(mergedData)) | grepl("std",names(mergedData))]
```
### 3. Use descriptive names to to Activity
Based on activity_labels.txt description activity lables are replaced by descriptive activity names. 

```r
levels <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING",
            "STANDING","LAYING")
subData$Activity <- factor(subData$Activity,labels=levels)
```
### 4. Update data set variable names more descriptive
The following rules applied to substitue variable names.
-std()   Standard deviation
-mean()  Mean
-meanFreq() Mean Frequency
Names starting with t is Time sampling
Names starting with f is frequency sampling and updated appropriatly.
Write the data to a file analysis_data.txt

```r
colnames(subData) <- gsub("-mean\\(\\)"," Mean",names(subData))
colnames(subData) <- gsub("-std\\(\\)"," Standard Deviation",names(subData))
colnames(subData) <- gsub("-meanFreq\\(\\)"," Mean Frequency",names(subData))
colnames(subData) <- gsub("^t","Time ",names(subData))
colnames(subData) <- gsub("^f","Frequency ",names(subData))
write.table(subData,"analysis_data.txt")
```
### 5. Create a new data set by averaging Subject and Activity.
Created grouped average data and write the data frame to a file.
New tidy data set is stored in average_data.txt after removing row names.
Sample data from the data frame is printed below

```r
suppressWarnings(suppressMessages(library(dplyr)))
groupData <- subData  %>% group_by(SubjectID,Activity) %>% summarise_each(funs(mean))

write.table(groupData, "average_data.txt",row.name = FALSE)

suppressWarnings(suppressMessages(library(knitr)))
kable(groupData[1:5,1:7])
```



| SubjectID|Activity           | Time BodyAcc Mean-X| Time BodyAcc Mean-Y| Time BodyAcc Mean-Z| Time BodyAcc Standard Deviation-X| Time BodyAcc Standard Deviation-Y|
|---------:|:------------------|-------------------:|-------------------:|-------------------:|---------------------------------:|---------------------------------:|
|         1|WALKING            |           0.2773308|          -0.0173838|          -0.1111481|                        -0.2837403|                         0.1144613|
|         1|WALKING_UPSTAIRS   |           0.2554617|          -0.0239531|          -0.0973020|                        -0.3547080|                        -0.0023203|
|         1|WALKING_DOWNSTAIRS |           0.2891883|          -0.0099185|          -0.1075662|                         0.0300353|                        -0.0319359|
|         1|SITTING            |           0.2612376|          -0.0013083|          -0.1045442|                        -0.9772290|                        -0.9226186|
|         1|STANDING           |           0.2789176|          -0.0161376|          -0.1106018|                        -0.9957599|                        -0.9731901|
