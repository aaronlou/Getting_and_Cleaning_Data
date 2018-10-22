library(dplyr)
# download data from url and unzip it
download_data <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","~/Downloads/Human_Activity_Recognition_Using_Smartphones.zip")
unzip("~/Downloads/Human_Activity_Recognition_Using_Smartphones.zip",exdir = "~/Downloads/")

# read raw data from local files
har_x_train <- read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt")
har_y_train <- read.table("~/Downloads/UCI HAR Dataset/train/y_train.txt")
har_train_subject <- read.table("~/Downloads/UCI HAR Dataset/train/subject_train.txt")

har_train <- cbind(har_x_train,har_y_train,har_train_subject)


har_x_test <- read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt")
har_y_test <- read.table("~/Downloads/UCI HAR Dataset/test/y_test.txt")
har_test_subject <- read.table("~/Downloads/UCI HAR Dataset/test/subject_test.txt")

har_test <- cbind(har_x_test,har_y_test,har_test_subject)

# Merges the training and the test sets to create one data set.
har_union <- rbind(har_train,har_test)

# > nrow(har_union )
# [1] 10299
# > ncol(har_union)
# [1] 563

###############################################################################################
# Extracts only the measurements on the mean and standard deviation for each measurement.
# find out the column index of the mean and standard deviation for each measurement
feature <- read.table("~/Downloads/UCI HAR Dataset/features.txt",sep=" ")

#     > head(feature)
# V1                V2
# 1 tBodyAcc-mean()-X
# 2 tBodyAcc-mean()-Y
# 3 tBodyAcc-mean()-Z
# 4  tBodyAcc-std()-X   

# In order to extract mean() or std(), we could seperate the column of V2
library(tidyr)
target_col <- feature %>% separate(V2,c("signal","measure","direction"),"-") %>% filter(measure == "mean()" | measure == "std()") %>% select(V1)
# turn data frame into a vector
vector_target_col <- c(target_col$V1,c(562,563))

mean_std_har <- har_union[,vector_target_col]

###############################################################################################
# Uses descriptive activity names to name the activities in the data set
conv_act <- function(x){
    if(x == 1){
        "WALKING"
    }else if (x == 2){
        "WALKING_UPSTAIRS"
    }else if(x == 3){
        "WALKING_DOWNSTAIRS"
    }else if(x == 4){
        "SITTING"
    }else if (x == 5){
        "STANDING"
    }else if (x == 6){
        "LAYING"
    }else{
        "NA"
    }
}


# convert 1 to 6 to descriptive activity names
mean_std_har$V1.1 <- sapply(mean_std_har$V1.1, conv_act)
###############################################################################################
#Appropriately labels the data set with descriptive variable names.
# use column names in the file of features.txt to lable the variables
colnames(mean_std_har) <- c(as.vector(feature[target_col$V1,2]),"activity","subject")

###############################################################################################
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

stat <- aggregate(mean_std_har[,1:66], by = list(activity = mean_std_har$activity,subject = mean_std_har$subject), FUN = mean )
write.table(stat,file="~/Downloads/cleaning_data_week4.txt",row.name=FALSE)


