# This codebook describles all the variables used in run_analysis.R

# zipfileURL stores the URL from which the dataset is downloaded

# Features stores the data from the 'features.txt' file.
# ActivityLabels stores the data from the 'activity_labels.txt' file. Links the class labels with their activity name.
# XTrainData stores the data from the 'train/X_train.txt' file.  It is the Training dataset.
# YTrainLabels stores the data from the 'train/y_train.txt' file.  It has the Training labels.
# XTestData stores the data from the 'test/X_test.txt' file.  It is the Test dataset. 
# YTestLabels stores the data from the 'test/y_test.txt' file.  It has the Test labels.
# SubjectTrainData stores the data from the 'train/subject_train.txt' file. 
# SubjectTestData stores the data from the 'test/subject_test.txt' file.

# TrainData stores the Training dataset. It is formed by binding the columns of YTrainLabels, SubjectTrainData and XTrainData.
# TestData stores the Test dataset.  It is formed by binding the columns of YTestLabels, SubjectTestData and XTestData.

# MergedData stores the required single merged dataset.  It is formed by binding the rows of TrainData and TestData.

# ColumnNumbers stores the numbers of the columns which contain the texts mean or std in the column names.  
# MeanAndStdData stores the required extract of only the measurements on the mean and standard deviation for each measurement. 

# TidyData stores the required dataset with descriptive activity names to name the activities in the dataset   

# DescriptiveVariables stores the names of the columns in TidyData. It is used to label the TidyData dataset with descriptive variable
# names.       

# NewTidyData is the independent tidy data set with the average of each variable for each activity and each subject.   
