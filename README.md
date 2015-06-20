# DataClean
Coursera Getting and Cleaning Data Course Project

The data is Human Activity Recognition Using Smartphones Data Set, downloaded from UC Irvine Machine Learning Repository http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

I merge measurements, subject ID, activity label from test and training dataset into one tidy dataset. 
```
#Read all data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors=FALSE)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors=FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                            stringsAsFactors=FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                           stringsAsFactors=FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", stringsAsFactors=FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", stringsAsFactors=FALSE)

# Merge the training and the test sets to create one data set.
Total<-rbind(cbind(subject_train,'Train',y_train,X_train),
             cbind(subject_test,'Test',y_test,X_test))
```
And change column names
```
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
colnames(Total)<-c("Subject","DataSource","Label",features[,2])
```

Use readable avtivity label
```
labelsDes <- read.table("UCI HAR Dataset/activity_labels.txt", 
                        stringsAsFactors=FALSE)
colnames(labelsDes)<-c("Label","ActivityLabel")
Total_MSD<-merge(labelsDes,Total_MSD)
Total_MSD<-Total_MSD[,-1]
```

After these process, we can get a tidy output data. 
In the output data:
'Subject' is from subject_*.txt
'DataSource' is coded based on 'Train' and 'Test' dataste.
'ActivityLabel' is based on activity_labels.txt and y_*.txt
Others are measurements from x_*.txt

For Data Cleaning course project, I extract only the measurements on the mean and standard deviation for each measurement. 
```
Total_MSD<-Total[,grepl('mean()|std()|Subject|Label',colnames(Total))]
```

Finally, I use data.table package to create a second, independent tidy data set with the average of each variable for each activity and each subject.

```
Total_MSDDT<-data.table(Total_MSD)
Mean_Var<-Total_MSDDT[,lapply(.SD,mean),by=list(ActivityLabel,Subject)]
```

Please check the code book for deatail infromation of features.
