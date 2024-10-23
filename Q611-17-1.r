
##########################################################################
##### Module 3: Importing, exporting, and visualization              #####
##### Lecture 17: Reading and writing datasets                       #####
##########################################################################

## set up the environment
setwd("/Users/majelli/MOBS Dropbox/marco ajelli/_IU/teaching/2024-2025/Q611/classes/17")
getwd()

rm(list = ls())
ls()


######################################
#### Reading and writing datasets ####
######################################

###################
##### read.csv ####
###################

D = read.csv("Excess_Deaths_Associated_with_COVID-19_subsample.csv", 
             header = T)

# Get to know your data
head(D)
View(D)
str(D)
names(D)

unique(D$State) # Important
unique(D$Outcome)

# Options that may be useful in the future:

# If the file has no header
D = read.csv("Excess_Deaths_Associated_with_COVID-19_subsample.csv",
             header = F)
head(D[, 1:5]) # check how the data looks like (5 columns for brevity)

# If you want to skip the first row (i.e., the header)
D = read.csv("Excess_Deaths_Associated_with_COVID-19_subsample.csv",
             header = F, skip = 1) 
# if you want to skip more than one row, you can use skip=n, where n is the
# number of rows you want to skip.
# You cannot skip non-consecutive rows (e.g. you cannot keep 
# rows 1 to 3 and skip row 4) when reading a file with read.csv

head(D[, 1:5])

# to transform strings into factors
D = read.csv("Excess_Deaths_Associated_with_COVID-19_subsample.csv",
             header = T, stringsAsFactors = T)
str(D)


# transform to logical
str(D$Exceeds.Threshold)
D$Exceeds = as.logical(as.character(D$Exceeds.Threshold))
head(D)
str(D)


### Frequently used operations: ###

# define variables that you need
names(D)

idx.var = c(which(names(D) == "State"),
            which(names(D) == "Week.Ending.Date"),
            which(names(D) == "Year"),
            which(names(D) == "Exceeds.Threshold"),
            which(names(D) == "Type"),
            which(names(D) == "Outcome")) 

# Choose particular observations
idx.uw.allc = which(D$Type == "Unweighted" & D$Outcome == "All causes")


# Subset your data: chosen state and chosen variables.
myD = D[idx.uw.allc, idx.var] 
head(myD)
View(myD)


# Table of frequencies by state
table(myD$State, myD$Exceeds.Threshold)

a = table(myD$State, myD$Exceeds.Threshold)
str(a)

a = as.data.frame(table(myD$State, myD$Exceeds.Threshold))
a
colnames(a) = c("State", "Exceeds.Threshold", "Freq")
a

table(myD$State, myD$Exceeds.Threshold, myD$Year)

b = as.data.frame(table(myD$State, myD$Exceeds.Threshold, myD$Year))
colnames(b) = c("State", "Exceeds.Threshold", "Year", "Freq")
b


#########################
#### Write a csv ########
#########################

# Write your data in a .csv file
write.csv(myD, "mydata.csv", row.names = F)

A = read.csv("mydata.csv", header = T)
head(A)


######################################
##### read.table #####################
######################################

#read.table()
# it is better to explicitly state separator in read.table
# by default header = F
MD = read.table("mydata.csv", sep = ",")
head(MD)
MD = read.table("mydata.csv", sep = ",",
                header = T) 
head(MD)
 
# Define the name of columns/variables
MD = read.table("mydata.csv", 
                sep = ",", header = T,
                col.names = c("State", "Week", "Year", "Exceeds.Threshold", 
                              "Type", "Outcome")) 
head(MD)


#########################################################
#### Write a generic text file (not limited to csv) #####
#########################################################

write.table(myD, "mydata_2.txt", row.names = F, sep = " ", quote = T)
MD2 = read.table("mydata_2.txt", header = T, sep = " ")
head(MD2)



###########################
##### Exercise 17.1 #######
###########################
# Download the data "NCHS - Leading Causes of Death: United States", which is 
# available at
# https://data.cdc.gov/NCHS/NCHS-Leading-Causes-of-Death-United-States/bi63-dtpu
# (click export and then select csv)
# Read the downloaded csv file and familiarize yourself with its content



###########################
##### Exercise 17.2 #######
###########################
# Create a new dataset that includes two variables: cause of deaths and number
# of deaths. The datasset should contain only the observations for Indiana in 
# 2016




###########################
##### Exercise 17.3 #######
###########################
# Write in a txt file the dataset you created in Exercise 17.2. Use "|" as 
# separator and use "case of death" and "number of deaths" as names for the
# variables.
# HINT: since the names of your observations contain numbers, characters, and
# symbols, use quote = T when writing the dataset.



###########################
##### Exercise 17.4 #######
###########################
# Read the dataset from Exercise 17.3 and calculate the percentages of each 
# cause of death




