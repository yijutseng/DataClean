library(data.table)
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

# Appropriately labels the data set with descriptive variable names. 
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)

#features$V2 <- gsub(pattern = '[()]',replacement = '',features$V2)
colnames(Total)<-c("Subject","DataSource","Label",features[,2])

# Extracts only the measurements on the mean and standard deviation for 
# each measurement. 
Total_MSD<-Total[,grepl('mean()|std()|Subject|Label',colnames(Total))]

# Uses descriptive activity names to name the activities in the data set
labelsDes <- read.table("UCI HAR Dataset/activity_labels.txt", 
                        stringsAsFactors=FALSE)
colnames(labelsDes)<-c("Label","ActivityLabel")
Total_MSD<-merge(labelsDes,Total_MSD)
Total_MSD<-Total_MSD[,-1]

# creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
Total_MSDDT<-data.table(Total_MSD)
Mean_Var<-Total_MSDDT[,lapply(.SD,mean),by=list(ActivityLabel,Subject)]

#Output text file from last step
write.table(x = Mean_Var,file = 'step5.txt', row.name=FALSE) 

