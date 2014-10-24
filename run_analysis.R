
## ----,echo=TRUE----------------------------------------------------------
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="Data.zip")
unzip("Data.zip",exdir = "./Data")


## ----,echo=TRUE----------------------------------------------------------
temp   <- read.table("./Data/UCI HAR Dataset/features.txt")  

# The feature names are changed in the R codes to a R-frendly version, which 
# includes the following tranformation: 

temp   <- gsub("-","_",temp[,2]) # 1. change "-" to "_"
temp <- gsub("\\(\\)","B",temp)  # 2. change "()" to "B"
features <- gsub("\\(|\\)",".",temp) # 3. change any other "(" or ")" to "." 
# features: 561 rows  and 2 columns, stored the identifier of 561 features
activities <- read.table("./Data/UCI HAR Dataset/activity_labels.txt")
# activities: 6 rows and 2 columns, stored the identifier of 6 different activities


## ----,echo=TRUE----------------------------------------------------------
x_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt")


## ----,echo=TRUE----------------------------------------------------------
x_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt")


## ----,echo=TRUE----------------------------------------------------------
y_all <- rbind(y_test, y_train)
y_all_activities <- activities[y_all[,1],2]


## ----,echo=TRUE----------------------------------------------------------
subject_all <- rbind(subject_test,subject_train)
colnames(subject_all) <- "subject"


## ----,echo=TRUE----------------------------------------------------------
test <- c(rep("Test",times = nrow(y_test)),rep("Train",times = nrow(y_train)))


## ----,echo=TRUE----------------------------------------------------------
x_all <- rbind(x_test, x_train)
colnames(x_all) <- features
x_all <- data.frame (activities =y_all_activities, Test=test, subject=subject_all, x_all[,])


## ----,echo=TRUE----------------------------------------------------------
index <- which(grepl("meanB",features)| grepl("stdB",features) ) 
features_mean_std <- features[index]
x_all_mean_std <- x_all[,c(1:3,index+3)]


## ----,echo=TRUE,message=FALSE,results='hide'-----------------------------
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


