Read Me
==========================
#Introduction:
This project proform an excise to collect and clean data. Main tasks include the following: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

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


