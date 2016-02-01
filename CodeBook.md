---
title: "Getting and Cleaning Data Course Project"
author: "Jayarama Ajakkala"
date: "January 31, 2016"
output: html_document
---
The purpose of this project is to prepare tidy data which can be used for later analysis. Raw data from wearable device experiments conducted by SmartLab is used in the project. 
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


```r
featuresFile <- "./UCI HAR Dataset/features.txt"

trainIdFile <- "./UCI HAR Dataset/train/subject_train.txt"
xtrainFile <- "./UCI HAR Dataset/train/x_train.txt"
ytrainFile <- "./UCI HAR Dataset/train/y_train.txt"

testIdFile <- "./UCI HAR Dataset/test/subject_test.txt"
xtestFile <- "./UCI HAR Dataset/test/x_test.txt"
ytestFile <- "./UCI HAR Dataset/test/y_test.txt"
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
