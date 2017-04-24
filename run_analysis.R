################################################################################
## This R program has the following functionality,                            ##
## 1. Merge the Training and the Test datasets to create one data set.        ##
## 2. Extract only the measurements on the mean and standard deviation for    ##
##    each measurement.                                                       ##
## 3. Use descriptive activity names to name the activities in the data set   ##
## 4. Appropriately label the data set with descriptive variable names.       ##
## 5. From the data set in step 4, create a second, independent tidy data set ##
##    with the average of each variable for each activity and each subject.   ##
################################################################################

## Download the data
zipfileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUC
I%20HAR%20Dataset.zip?accessType=DOWNLOAD"
download.file (zipfileURL, destfile="UCI HAR Dataset.zip", mode = "wb", 
               method="auto")
unzip ("UCI HAR Dataset.zip")

## Read the data files 
setwd ("D:/Vikas/UCI HAR Dataset")
Features <- read.table('features.txt')

ActivityLabels <- read.table ('activity_labels.txt')
        ##: Links the class labels with their activity name.

XTrainData <- read.table ('train/X_train.txt') 
        ## : Training set.

YTrainLabels <- read.table ('train/y_train.txt') 
        ## : Training labels.

XTestData <- read.table ('test/X_test.txt') 
        ## : Test set.

YTestLabels <- read.table ('test/y_test.txt')  
        ## : Test labels.

SubjectTrainData <- read.table ('train/subject_train.txt')
SubjectTestData <- read.table ('test/subject_test.txt')

## Set the Column names
colnames(YTrainLabels) <-"ActivityId"
colnames(SubjectTrainData) <- "SubjectId"
colnames(XTrainData) <- Features[,2] 

colnames(YTestLabels) <- "ActivityId"
colnames(SubjectTestData) <- "SubjectId"
colnames(XTestData) <- Features[,2] 

colnames(ActivityLabels) <- c('ActivityId','ActivityType')

## Merge the data
TrainData <-  cbind(YTrainLabels, SubjectTrainData, XTrainData)
TestData <- cbind(YTestLabels, SubjectTestData, XTestData)

MergedData <- rbind (TrainData, TestData)

## Extract only the measurements on the mean and standard deviation for 
## each measurement.
ColumnNumbers <- grep("mean|std", Features$V2)

MeanAndStdData <- MergedData[,c(1,2,ColumnNumbers + 2)]

## Use descriptive activity names to name the activities in the data set   
TidyData <- merge(ActivityLabels, MergedData, by='ActivityId', all.x=TRUE)

## Appropriately label the data set with descriptive variable names.       
DescriptiveVariables <- names(TidyData)
DescriptiveVariables <- gsub("[(][)]", "", DescriptiveVariables)
DescriptiveVariables <- gsub("^t", "TimeDomain_", DescriptiveVariables)
DescriptiveVariables <- gsub("^f", "FrequencyDomain_", DescriptiveVariables)
DescriptiveVariables <- gsub("Acc", "Accelerometer", DescriptiveVariables)
DescriptiveVariables <- gsub("Gyro", "Gyroscope", DescriptiveVariables)
DescriptiveVariables <- gsub("Mag", "Magnitude", DescriptiveVariables)
DescriptiveVariables <- gsub("-mean-", "_Mean_", DescriptiveVariables)
DescriptiveVariables <- gsub("-std-", "_StandardDeviation_", 
                             DescriptiveVariables)
DescriptiveVariables <- gsub("-", "_", DescriptiveVariables)
names(TidyData) <- DescriptiveVariables

## Create a second, independent tidy data set with the average of each variable 
## for each activity and each subject.   

NewTidyData <- aggregate(. ~SubjectId + ActivityId, TidyData, mean)
NewTidyData <- NewTidyData [order(NewTidyData$SubjectId, 
                                  NewTidyData$ActivityId),]

write.table(NewTidyData, "NewTidyData.txt", row.name=FALSE)
