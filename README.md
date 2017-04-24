# TidyingData
## Download the zipped dataset from the given URL using download.file in wb mode

download.file (zipfileURL, destfile="UCI HAR Dataset.zip", mode = "wb", 
               method="auto")

## Unzip the data files.  Current working directory is D:/Vikas
unzip ("UCI HAR Dataset.zip")

## Set the working directory and Read all the required data files one by one using read.table   
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

## Set the Column names for the data read from each of the files  
## The first column for the Training data is the Activity ID
colnames(YTrainLabels) <-"ActivityId"
## The second column for the Training data is the Subject ID
colnames(SubjectTrainData) <- "SubjectId"
## The column names of Training data are taken from Features file  
colnames(XTrainData) <- Features[,2] 

## The first column for the Test data also is the Activity ID
colnames(YTestLabels) <- "ActivityId"
## The second column for the Training data also is the Subject ID
colnames(SubjectTestData) <- "SubjectId"
## The column names of Test data are taken from Features file  
colnames(XTestData) <- Features[,2] 

## The Activity Labels
colnames(ActivityLabels) <- c('ActivityId','ActivityType')

## Merge the Training data files into a Training dataset using Column binding. The first 2 columns are Activity Id and Subject ID, followed by the Training data columns.   
TrainData <-  cbind(YTrainLabels, SubjectTrainData, XTrainData)
## Merge the Test data files into a Test dataset using Column binding. The first 2 columns are Activity Id and Subject ID, followed by the Test data columns.   
TestData <- cbind(YTestLabels, SubjectTestData, XTestData)

## Merge the Training dataset and the Test dataset into a single dataset using row binding.  We are appending the rows as the column names of the two dataset are the same.  
MergedData <- rbind (TrainData, TestData)

## Extract only the measurements on the mean and standard deviation for 
## each measurement.
## Find the column numbers which contain the texts mean or std
ColumnNumbers <- grep("mean|std", Features$V2)
## Take these columns containing mean or std from our merged dataset  
MeanAndStdData <- MergedData[,c(1,2,ColumnNumbers + 2)]

## Use descriptive activity names to name the activities in the data set   
## Merge the Activity Labels and our single merged dataset by Activity ID column
TidyData <- merge(ActivityLabels, MergedData, by='ActivityId', all.x=TRUE)

## Appropriately label the data set with descriptive variable names.       
DescriptiveVariables <- names(TidyData)
## Remove ()
DescriptiveVariables <- gsub("[(][)]", "", DescriptiveVariables)
## Replace ^t by TimeDomain
DescriptiveVariables <- gsub("^t", "TimeDomain_", DescriptiveVariables)
## Replace ^f by FrequencyDomain
DescriptiveVariables <- gsub("^f", "FrequencyDomain_", DescriptiveVariables)
## Replace Acc by Accelerometer
DescriptiveVariables <- gsub("Acc", "Accelerometer", DescriptiveVariables)
## Replace Gyro by Gyroscope
DescriptiveVariables <- gsub("Gyro", "Gyroscope", DescriptiveVariables)
## Replace Mag by Magnitude
DescriptiveVariables <- gsub("Mag", "Magnitude", DescriptiveVariables)
## Replace mean by Mean
DescriptiveVariables <- gsub("-mean-", "_Mean_", DescriptiveVariables)
## Replace std by StandardDeviation
DescriptiveVariables <- gsub("-std-", "_StandardDeviation_", 
                             DescriptiveVariables)
## Replace dash by underscore
DescriptiveVariables <- gsub("-", "_", DescriptiveVariables)
names(TidyData) <- DescriptiveVariables

## Create a second, independent tidy data set with the average of each variable for each activity and each subject.   
##Take the average of each data element
NewTidyData <- aggregate(. ~SubjectId + ActivityId, TidyData, mean)
## Order this tidy dataset by subject and activity
NewTidyData <- NewTidyData [order(NewTidyData$SubjectId, 
                                  NewTidyData$ActivityId),]
## Write this tidy dataset to a file 
write.table(NewTidyData, "NewTidyData.txt", row.name=FALSE)
