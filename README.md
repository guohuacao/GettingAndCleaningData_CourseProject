---
title: "GettingandCleaningData Course Project"
author: "grace cao"
date: "October 21, 2015"
output: html_document
---

###Installation

Create a working directory for this project. In my directory is called 'courseProject'.     
Create a data directory called 'data' and download the raw data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to be under this directory. 

###Dependencies

The script run_analysis.R depends on the libraries plyr and reshape2. 

###Running the analysis

Change Rstudio working directory to the project working directory, on my machine, it is 'courseProject' directory. 
Source the script run_analysis.R in R: source("run_analysis.R")

The zip file will be unzipped and unzipped data are auto stored under directory 'UCI HAR Dataset'

Data set tidy1 will be generated from function genTidy1(). 
Data set tidy2 will be generated from function genTidy2(tidy1). 

tidy1 and tidy2 data set are written to tidy1.csv and tidy2.cs on hard disk. 

Information about the datasets is provided in CodeBook.md.
