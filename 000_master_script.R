##########################################################################
# Project:   Marica
# 
# Title:            [00_TITLE_OF_TTHE_SCRIPT]
# Author:           XXXXX
# Last modified:    XXXXX
# Date:             XXXXXX
# Version:          R studio
# 
# Summary:   A RESUME OF THE PURPOSE OF THE SCRIPT AND THE "PASO A PASO". THE IDEA IS THAT SOMEONE THAT DOESN'T KNOW THE SCRIPT CAN READ IT AND UNDERSTAND WHAT YOU ARE DOING.
#           THIS IS SUPER IMPORTANT 

# Important: IMPORTANT THINGS THE PERSON THAT READS THIS SCRIPT SHOULD CONSIDER. BE CLEAR SO EVERYONE UNDERSTANDS
##########################################################################

#Installing packages
# install.packages(c("stringr","XLConnect","xlsx","rjson","rgdal","sp","proj4","geosphere","reshape2","reshape","naniar",
#                    "doBy","tidyr","readstata13","tidyverse","foreign","plm","purrr","plotrix","sf","ggplot2","ggmap","tmap",
#                    "tmaptools","dplyr","Rcpp","XML","gridExtra","xtable","gtable","grid","viridis","pryr","plyr","xlsx",
#                    "readxl","multcomp","nlme","XLConnect","XLConnectJars","lme4","car","rJava", "Matching"))

#Libraries
libraries<-c("stringr","XLConnect","tidyr","tidyverse","foreign",
             "XML","gridExtra","xtable","gtable","grid","viridis","pryr","xlsx","readxl",
             "data.table","multcomp","nlme", "Matching", "RStata")

lapply(libraries, require, character.only = TRUE)


#Removing all the data

remove(list = ls())

#Data
user <- Sys.info()[["user"]]
message (sprintf("Current User: %s\n", user))
if (user == "[name_computer]") {
  ROOT <- "[root]"
} else {
  stop ("Invalid User")
}

setwd(ROOT)
getwd()

#1000 repetition code
  source("00_matching_1000.R")

#Max and min distance selection code
  source("00_matching_selected.R")