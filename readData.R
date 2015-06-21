#readData() reads in all the necessary files and assigns them to variables in the global environment

readData <- function(){
  
  #Read in Activity Labels
  if(!exists("activity_labels")){
    activity_labels <<- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE);
    colnames(activity_labels) <- c("ID","Description");
  }
  
  #Read in Training Data
  if(!exists("subject_train")){
    subject_train <<- read.table("UCI HAR Dataset/train/subject_train.txt");
  }
  if(!exists("x_train")){
    x_train <<- read.table("UCI HAR Dataset/train/X_train.txt");
  }
  if(!exists("y_train")){
    y_train <<- read.table("UCI HAR Dataset/train/y_train.txt");
  }
  
  #Read in Test data
  if(!exists("subject_test")){
    subject_test <<- read.table("UCI HAR Dataset/test/subject_test.txt");
  }
  if(!exists("x_test")){
    x_test <<- read.table("UCI HAR Dataset/test/X_test.txt");
  }
  if(!exists("y_test")){
    y_test <<- read.table("UCI HAR Dataset/test/y_test.txt");
  }
  
  #Read in Features
  features <<- read.table("UCI HAR Dataset/features.txt");
}

##combineData() creates a new vector that is the amalgamation of the train and test results for all subjects and all activities.
## It renames the activities from their integer value to their textual value
## It returns the resulting data frame
combineData <- function(){
  new_frame <- data.frame(matrix(ncol=563));
  feature_list <- as.vector(features[,2]);
  colnames(new_frame) <- c(feature_list,"Subject","Activity");
  
  ##Replaces activity integer values with textual values for training rows
  for(i in 1:nrow(y_train)){
    label <- y_train[i,1];
    y_train[i,1] <- activity_labels[label,2];
  }
  ##Replace activity integer values with textual values for test rows
  for(i in 1:nrow(y_test)){
    label <- y_test[i,1];
    y_test[i,1] <- activity_labels[label,2];
  }
  
  ##Combine results with subject and activity values for each
  combine_train <- cbind(subject_train, y_train);
  combine_test <- cbind(subject_test, y_test);
  train_complete <- cbind(x_train,combine_train);
  test_complete <- cbind(x_test,combine_test);
  colnames(train_complete) <- c(feature_list,"Subject","Activity");
  colnames(test_complete) <- c(feature_list,"Subject","Activity");
  new_frame <- rbind(new_frame,train_complete);
  new_frame <- rbind(new_frame, test_complete);
  
  ##dump empty first row
  new_frame <- new_frame[-1,]
  
  return(new_frame)
}

##Filters values to only those dealing with the standard deviation or mean, keeping the Subject and Activity values.
##Returns resulting data frame
grabMeans <- function(frame){
  means <- frame[, grepl("mean\\(\\)|std|Subject|Activity", names(frame), ignore.case=TRUE)];
  return(means);
}

##Gets the average of the results for each subject for each activity, returns resulting data frame
getAverages <- function(frame){
  #averages <- ddply(frame, c("Subject", "Activity"), summarize, Average = "5");
  averages <- aggregate(frame[,1:66], list(Subject = frame$Subject, Activity =frame$Activity), mean);
  return(averages);
}


