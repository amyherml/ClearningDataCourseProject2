Read Me
==========================
#Introduction:
This project proform an excise to collect and clean data. Main tasks include the following: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This code book aims to give a description of the variables, the data, and any transformations or work performed to clean up the data.

#Data: 
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

Here are the data for the project: 

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

#Data Processing
The main data processing tasks include the following: 
1. downloading the data from the link above, then 
2. load all data table to R,
3. merge all data together
4. correctly label the data set with
..1. activity names,
..2. feature names,
..3. test or training data, and 
..4. subject identifier;
5. extracts only the measurements on the mean and standard deviation for each measurement, and 
6. creates a second, independent tidy data set with the average of each variable for each activity and each subject. The result data set is stored in a txt file named "Mean_grouped_X.txt".

#Files
- *run_analysis.R* contains the codes used to perform the tasks above and generate result data set.
- *CodeBook.md* gives a description of the variables, the data, and any transformations or work performed to clean up the data.
- *Mean_grouped_X.txt* contains the cleaned data set from task #6 above
- *Data* folder contains all the data download from the link above

##Naming Rules
We are following the naming convention of the original work and name the main data set "x", which is a 561-feature vector with time an frequency domain variables for each record, "y" is the activity lables for each record, and "subject" is the subject identifier. Variables for training data will also contain a "_train" in the name, and "_test" for test data. 

##1. Data download

```r
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="Data.zip")
unzip("Data.zip",exdir = "./Data")
```
##2. Load all data
###2.1 Loading features and activity labels

```r
temp   <- read.table("./Data/UCI HAR Dataset/features.txt")  
temp   <- gsub("-","_",temp[,2])
temp <- gsub("\\(\\)","B",temp)
features <- gsub("\\(|\\)",".",temp)
# 561 rows  and 2 columns, stored the identifier of 561 features
activities <- read.table("./Data/UCI HAR Dataset/activity_labels.txt")
# 6 rows and 2 columns, stored the identifier of 6 different activities
```

###2.2 Loading traning data

```r
x_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt")
```

###2.3 Loading test data

```r
x_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt")
```
##3. Merge training and test data sets, and label data
Test data will be put above the training data, but this ordering should not affect the later data analysis, as each obervation will be correctly labeled. 

###3.1 Merge all activity labels, and uses descriptive activity names to name the activities in the data set

```r
y_all <- rbind(y_test, y_train)
y_all_activities <- activities[y_all[,1],2]
```
###3.2 Merge all subject identifiers

```r
subject_all <- rbind(subject_test,subject_train)
colnames(subject_all) <- "subject"
```
###3.3 get a test/training data identifier
As mentioned, test data is going to be put at the top and then the training data set, so this is the rule we are going to use when constructing this test identifier. 

```r
test <- c(rep("Test",times = nrow(y_test)),rep("Train",times = nrow(y_train)))
```
###3.4 Merge all 561-feature data, and put together a data frame to contain all activity names, subject identifiers and test/training identifiers.

```r
x_all <- rbind(x_test, x_train)
colnames(x_all) <- features
x_all <- data.frame (activities =y_all_activities, Test=test, subject=subject_all, x_all[,])
```
x_all is the data set containing all training data and test data. the first column of x_all is the activities labels for each observations, and the second column is the identifier indicating whether the observation is a "train" or a "test". The third column is the "subject" column, each row identifies the subject who performed the activity for each window sample. The rest 561 columns corresponding to the 561 features. The test data are put before the train data, but this ordering should not affect the results for data analyst. 

##4. extracts only the measurements on the mean and standard deviation for each measurement
The measurements on the mean and standard deviation will have feature names containing "mean()" or "std()". So the aim at this part is to find the features with names satisfy the criteria and extra the relavant columns from the data set. 

```r
index <- which(grepl("meanB",features)| grepl("stdB",features) ) 
features_mean_std <- features[index]
x_all_mean_std <- x_all[,c(1:3,index+3)]
```
##5. creates a second, independent tidy data set with the average of each variable for each activity and each subject. Result data set is saved to Mean_grouped_X.txt.

```r
#library(dplyr)


n <- 0
tlist_activity<- matrix()
tlist_subject <-  matrix()
tlist_test    <- matrix()
temp<-matrix(NaN, nrow=nrow(activities)*30,ncol = length(features_mean_std))
for (a in 1: nrow(activities)){
        
        for( s in 1: 30){
                subset <- x_all_mean_std[which(x_all_mean_std$activities==activities[a,2] 
                                               & x_all_mean_std$subject==s),]       
                n <- n+1
                tlist_activity[n] <- as.character(activities[a,2])
                tlist_subject [n] <- s 
                tlist_test [n]  <- as.character(subset$Test[1])
                if (length(subset)>0){
                        temp[n,1:(ncol(subset)-3)]<-colMeans(subset[,4:ncol(subset)])
                }
        }
}


colnames(temp) <- colnames(subset[,4:ncol(subset)])
aver_grouped_x <- data.frame(activities = as.factor(tlist_activity), Test = as.factor(tlist_test),      
                        subject = tlist_subject,temp[,])

write.table(aver_grouped_x,file="Mean_grouped_X.txt")
```


