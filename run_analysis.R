##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Grace Cao
## 2015-10-21

# File Description:

# Data download from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# The scrip will do the following
# Function DeriveTidy1 will process the data, generate Tidy data1 based on requirements #1 to #4. 
# Function DeriveTidy2 will process the data, generate Tidy data2 based on requirement #5

# The script will do the following requirements
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################
#read the zip file
rm (list=ls())

require("plyr")
require("reshape2")
downloadData <- function() {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipFile <- "./data/Dataset.zip"  
    if(!file.exists(zipFile)){
        download.file(url, zipFile)
    }
    
    dataDir <- "UCI HAR Dataset"
    if(!file.exists(dataDir)) { unzip(zipFile, exdir = ".") }
    
    dataDir
    
}

dataDir <- downloadData()

genTidy1 <- function(dataDir = "UCI HAR Dataset") {
# Merge the training and the test sets to create one data set.

    XTrain <- read.table(file.path(dataDir, "train/X_train.txt")) 
    XTest  <- read.table(file.path(dataDir, "test/X_test.txt") )
    merged <- rbind(XTrain, XTest)
    
    #add feature names as column names
    featureNames <- read.table(file.path(dataDir, "features.txt"))[[2]]
    colnames(merged) <- featureNames
    
    #only select the columns that have mean, std or activityLabel in their name
    selected <- merged[,grep("mean|std|activityLabel",featureNames)]
    
    #rename variable names to more readable form.
    #I have deliberately chosen not to rename to a full English words,
    #because column names tend to get very long then
    varNames = names(selected)
    varNames <- gsub(pattern="^t",replacement="time",x=varNames)
    varNames <- gsub(pattern="^f",replacement="freq",x=varNames)
    varNames <- gsub(pattern="-?mean[(][)]-?",replacement="Mean",x=varNames)
    varNames <- gsub(pattern="-?std[()][)]-?",replacement="Std",x=varNames)
    varNames <- gsub(pattern="-?meanFreq[()][)]-?",replacement="MeanFreq",x=varNames)
    varNames <- gsub(pattern="BodyBody",replacement="Body",x=varNames)
    names(selected) <- varNames
    
    #use the activity names to name the activities in the set?
    activityLabels <- read.table(file.path(dataDir, "activity_labels.txt"),stringsAsFactors=FALSE)
    colnames(activityLabels) <- c("activityID","activityLabel")
    
    #Label the data set with descriptive activity name
    #first we create the activity coloum for the entire data set, test + train
    
    testLabels <- read.table(file.path(dataDir, "test/y_test.txt"), stringsAsFactors = FALSE)
    trainLabels <- read.table(file.path(dataDir, "train/y_train.txt"), stringsAsFactors = FALSE)
    allLables <- rbind(trainLabels, testLabels)
    
    #assign a column name so we can merge on it 
    colnames(allLables)[1] <- "activityID"
    
    #join the activityLabels - we use join from the plyr package and not merge, because join
    #preserves order
    activities <- join(allLables,activityLabels,by="activityID")
    
    #add colume of activities name to entire data set
    selected <- cbind(activity=activities[,"activityLabel"],selected)
    
    trainSubjects <- read.table(file.path(dataDir, "train/subject_train.txt"), stringsAsFactors = FALSE)
    testSubjects <- read.table(file.path(dataDir, "test/subject_test.txt"), stringsAsFactors = FALSE)
    allSubjects <- rbind(trainSubjects, testSubjects)
    
    colnames(allSubjects) <- "subject"
    selected <- cbind(allSubjects, selected)
    
    #sort all data based on subject and activity
    sorted <- selected[order(selected$subject,selected$activity),]
    sorted
}

genTidy2 <- function(rawData) {
    #create a long shaped dataset from a wide shaped dataset
    molten <- melt(rawData,id.vars= c("subject","activity"))
    #transform the long shaped dataset back into a wide shaped dataset, aggregating on subject 
    #and activity using the mean function
    cast <- dcast(molten, subject+activity ~ variable, fun.aggregate=mean)
    cast
}


tidy1 <- genTidy1()
tidy2 <- genTidy2(tidy1)
write.csv(tidy1,file="tidy1.csv")
#write.csv(tidy2,file="tidy2.csv")

write.table(tidy2, "tidy2.txt", row.names = FALSE)

