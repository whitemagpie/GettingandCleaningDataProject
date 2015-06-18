## This file contains functions to create tidy data set. 
## The main function that actually calls other functions and performs all tasks is called "Mainfn". 
## It is the fourth function defined in the file. There are three more functions 
## defined in this file - 
## 1. append_data 
## 2. create_labels 
## 3. rename_columns
## These three functions are called by "Mainfn" to comlete its job.
## Mainfn stores the final result in file called "final_tidy.txt" in "UCI HAR Dataset" folder
## It is assumed "UCI HAR Dataset" folder exists in current folder.
## Mainfn creates three intermediate files "subject_tidy.txt", "X_tidy.txt" and "y_tidy.txt"
## to complete its task. 
## After storing "final_tidy.txt", it deletes the three intermediate files before exiting.


## append_data appends reads data of files x and y, appends both data sets and 
## writes the combined data sets in file z and stores it at the location address given in z
## x, y and z are assumed to be csv files
append_data <- function(x,y,z) {
    xdata<-read.table(x)
    ydata<-read.table(y)
    zdata<-rbind(xdata,ydata,deparse.level=0)
    write.table(zdata,file=z,row.names=FALSE)
}

## this function creates labels [like "WALKING","STANDING" etc] for activity classes
create_labels <- function(x,y,levels,labels) {
    
    xdata<-read.table(x,header=TRUE)
    ydata<-factor(xdata[[1]],levels=levels,labels=labels)
    ydata<-as.data.frame(ydata)
    names(ydata)<-"ACTIVITY_CLASS"
    write.table(ydata,file=y,row.names=FALSE)
}

## This function renames all columns in three files which have train and test data already merged:
## 1. The file with activity details [file with 561 length vector in each row] : the feature
## names are extracted from "features.txt" and are used to name the columns.
## 2. The file containing subject numbers - column name is renamed from "V1" to "SUBJECT"
## 3. The file containing activities - column name is renamed form "V1" to "ACTIVITY_CLASS" 
rename_columns <- function() {
    
    nfile<-"./UCI HAR Dataset/features.txt"
    n<-read.table(nfile)
    xfile<-"./UCI HAR Dataset/X_tidy.txt"
    xdata<-read.table(xfile,header=TRUE)
    names(xdata)<-n$V2
    write.table(xdata,file=xfile,row.names=FALSE)
    
    yfile<-"./UCI HAR Dataset/y_tidy.txt"
    ydata<-read.table(yfile,header=TRUE)
    names(ydata)<-"ACTIVITY_CLASS"
    write.table(ydata,file=yfile,row.names=FALSE)
    
    zfile<-"./UCI HAR Dataset/subject_tidy.txt"
    zdata<-read.table(zfile,header=TRUE)
    names(zdata)<-"SUBJECT"
    write.table(zdata,file=zfile,row.names=FALSE)
}


## the main workhorse function
mainfn <- function (){
    
    ## 1. append train and test data sets together
    
    xfile<-"./UCI HAR Dataset/train/subject_train.txt"
    yfile<-"./UCI HAR Dataset/test/subject_test.txt"
    zfile<-"./UCI HAR Dataset/subject_tidy.txt"
    append_data(xfile,yfile,zfile)
    
    xfile<-"./UCI HAR Dataset/train/X_train.txt"
    yfile<-"./UCI HAR Dataset/test/X_test.txt"
    zfile<-"./UCI HAR Dataset/X_tidy.txt"
    append_data(xfile,yfile,zfile)
    
    xfile<-"./UCI HAR Dataset/train/y_train.txt"
    yfile<-"./UCI HAR Dataset/test/y_test.txt"
    zfile<-"./UCI HAR Dataset/y_tidy.txt"
    append_data(xfile,yfile,zfile)
    
    ## 4. Appropriately labels the data set with descriptive variable names
    ## we need to rename columns before completing 2nd and 3rd steps as we need to be able to
    ## grep the column names to extract only std and mean columns as required in step 2.
    rename_columns()
    
    ## 3. Use descriptive activity names to name the activities in the data set :
    ## open y_tidy file and rename the activities with descriptive labels mentioned below
    xfile<-"./UCI HAR Dataset/y_tidy.txt"
    labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
    levels=c("1","2","3","4","5","6")
    create_labels(xfile,xfile,levels,labels)
    
    ## 2. Extract only the measurements on the mean and standard deviation for each measurement. 
    xfile<-"./UCI HAR Dataset/X_tidy.txt"
    xdata<-read.table(xfile,header=TRUE)
    x<-xdata[,grepl("mean|std",colnames(xdata))] ##shouldnt zdata be xdata instead? typo?
    
    ## 5. creates a second, independent tidy data set 
    ## with the average of each variable for each activity and each subject
    
    ## for step 5 first lets bind the subject, activity and (mean+std) data (extracted above) together
    zfile<-"./UCI HAR Dataset/subject_tidy.txt"
    yfile<-"./UCI HAR Dataset/y_tidy.txt"
    y<-read.table(yfile,header=TRUE)
    z<-read.table(zfile,header=TRUE)
    total<-cbind(z,y,x)
    ## finally summarize the data as per instruction - average of each variable by subject and activity
    final<-ddply(total,.(SUBJECT,ACTIVITY_CLASS),numcolwise(mean))
    write.table(final,"./UCI HAR Dataset/final_tidy.txt",row.names=FALSE)
    
    ## finally delete the intermediate files created to arrive at step 5
    unlink("./UCI HAR Dataset/subject_tidy.txt")
    unlink("./UCI HAR Dataset/X_tidy.txt")
    unlink("./UCI HAR Dataset/y_tidy.txt")
}



