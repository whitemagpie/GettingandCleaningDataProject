# GettingandCleaningDataProject
This project is created towards partial fulfillment of course "Getting And Cleaning Data", offered by John Hopkins University as part of Data Science Specialization.

The main file in this project is called "run_analysis.R"

"run_analysis.R" contains functions to create tidy data set. 

The main function that actually calls other functions and performs all tasks is called "Mainfn". 
It is the fourth function defined in the file. There are three more functions defined in the file - 
1. append_data 
2. create_labels 
3. rename_columns
These three functions are called by "Mainfn" to comlete its job.

Mainfn stores the final result in file called "final_tidy.txt" in "UCI HAR Dataset" folder
It is assumed "UCI HAR Dataset" folder exists in current folder.

Mainfn creates three intermediate files "subject_tidy.txt", "X_tidy.txt" and "y_tidy.txt" to complete its task. 
After storing "final_tidy.txt", it deletes the three intermediate files before exiting.

