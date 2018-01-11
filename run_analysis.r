#create a directory if not found, in which the downloded data will be stored
if(!file.exists("./Assignment")){dir.create("./Assignment")}

#data set zip Url, from where the data will be downloded
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download the zip file
download.file(fileUrl,destfile="./Assignment/Dataset.zip")

# unzip the zip file to Assignment directory
unzip(zipfile="./Assignment/Dataset.zip",exdir="./Assignment")

#reading test tables
xtest<- read.table("./Assignment/UCI HAR Dataset/test/X_test.txt")
ytest<- read.table("./Assignment/UCI HAR Dataset/test/y_test.txt")
subject_test<- read.table("./Assignment/UCI HAR Dataset/test/subject_test.txt")

#reading train tables
xtrain<- read.table("./Assignment/UCI HAR Dataset/train/X_train.txt")
ytrain<- read.table("./Assignment/UCI HAR Dataset/train/y_train.txt")
subject_train<- read.table("./Assignment/UCI HAR Dataset/train/subject_train.txt")

#reading features vector
features<- read.table("./Assignment/UCI HAR Dataset/features.txt")

#reading the activity labels
Activity_labels<- read.table("./Assignment/UCI HAR Dataset/activity_labels.txt")

#renaming the colums
colnames(xtest)<- features[,2]
colnames(ytest)<- "ActivityID"
colnames(subject_test)<- "subjectID"
colnames(xtrain)<- features[,2]
colnames(ytrain)<- "ActivityID"
colnames(subject_train)<- "subjectID"
colnames(Activity_labels)<- c("ActivityID", "ActivityName")

#merging the test tables
mergetest<- cbind(ytest, subject_test, xtest)

#merging the train tables
mergetrain<- cbind(ytrain, subject_train, xtrain)

#merging the test and train rows
allinone<- rbind(mergetrain, mergetest)

#extracting the measurments of the mean and standard deviation
colNames<- colnames(allinone)
meanandstd<- grepl("ActivityID", colNames)|
grepl("subjectID", colNames)|
grepl("mean..", colNames)|
grepl("std..", colNames)

#New data with only the measurments of the mean and standard deviation
setmeanandstd<- allinone[, meanandstd==TRUE]

#assiging a activity names and ordering the data set 
setactivitynames<- merge(Activity_labels,setmeanandstd, by='ActivityID', all.x=TRUE)
setactivitynamesordered<- setactivitynames[order(setactivitynames$subjectID, setactivitynames$ActivityID),]

#creating independent tidy data set with the average of each variable for each activity and each subject.
dataset<- aggregate(. ~subjectID + ActivityName, setactivitynamesordered, mean)
datasetordered<- dataset[order(dataset$subjectID, dataset$ActivityID),]

#writing the tidy data
write.table(datasetordered, "datasetordered.txt", row.name=FALSE
