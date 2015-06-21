#ReadMe.md
##Purpose
The purpose of these files is to read in data containing the results of 30 volunteers performing six activies(Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing, Laying) while wearing a smartphone (Samsung Galaxy S II) on their waists. Data about 3-axial linear acceleration and 3-axial angular velocity was captured. This data was broken into multiple data sets corresponding to results, subject id, and activity id.

###readData.R
The functions contained in readData.R read in the different data files and combine them to match the results for each activity with each participant (Subject). They also replace the activity integer ID with it's corresponding textual value (Walking, Sitting, etc) and variable names (v1, v2, etc) with their corresponding descriptive name. Of the 561 variables measured, the 66 variables that contain information related to the mean or standard deviation are retained. This is accomplished by filtering only the columns that contain the text "mean()" or "std()" while retaining the Subject and Activity values.

Once narrowed down to just these 66 values, we calculate the average for each Subject for each Activity. This means we take the average of all of Subject 1's Walking values for each variable, the average of all of Subject 1's Standing values for each variable, and so forth for each Activity and each Subject. This gives us 6 groups of averages for each of the 30 Subjects.

####readData()
Reads in required files of data, including: /train/subject_train.txt, /train/X_train.txt, /train/y_train.txt, /test/subject_test.txt, /test/X_test.txt, /test/y_test.txt, /activity_labels.txt, and /features.txt.

####combineData()
Relabels both y_test and y_train values to replace their activity ID with the corresponding textual activity description from /activity_labels.txt

Combines the subject data with the activity values for each result (both the train and  test data) and then combines these values with each result (again, both train and test) to create one large data frame containing all provided information. This amalgamation is the returned to be passed on to grabMeans().

####grabMeans(x)
This function subsets the data frame passed to it (x) to only contain values that relate to mean or standard deviation. This is achieved by matching the column variables to either "mean()" or "std()" (case-insensitive) while maintaining the Subject and Activity for each row. These new, smaller data frame is returned to be passed on to getAverages();

####getAverages(x)
This function takes a data frame (in this case our smaller mean/std data frame obtained from  grabMeans()) and returns the averages for each variable when grouped by both Subject and Activity. For example, it takes all the data present for Subject 1 with the Activity of "Walking" and calculates an average for each variable. An average for each variable for Subject 1 is also calculated for the Activity of "Standing." Averages are calculated for each Activity for each Subject. This new data frame is then returned.

###run_analysis.R
This file is the primary file for running the process. It first sources readData.R to load in variables and then runs them in the proper order.
Data is read in (readData()), combined and labeled (combineData()), narrowed down to means/stds (grabMeans()), and then averaged (getAverages()). This resulting data frame is then writen to a txt file, and the value is outputted to the console.