#Instlling rewuired packages
install.packages("tidyverse")
install.packages("tibble")
install.packages("installr")

#Load Packages
library(tidyverse)
library(stringr)
library(tibble)
library(dplyr)
list.files()

#I first read in the CSV file which contains the survey information with egg collections 
a <- read.csv("eggs_CUFES.csv")


#Checking the data Out
head(a)
str(a)


#goal 1 extract the year from the time_UTC column
## Create a character string from the column time_UTC
date <- as.character(a$time_UTC)

#Subset the first four cahracters to extract the year, month, and day
yr <- substr(date, 1,4)


#Check to see if this worked 
head(yr)

#add the new extracted year to a column on the dataframe
a1 <-  bind_cols(a, yr)

##Check to see if this worked 
head(a1)

#Rename the column to date
a1 <- rename(a1, year = ...29)

#Select out required data
a2 <- select(a1, "cruise","lat_degN","lon_degE","anchovy_eggs_count","sardine_eggs_count", "year" )

#Write this data to a file
write.csv(a2, file = "eggs_edit.csv")

########################################################################################################################

#I then read in the CSV file which contains the survey information with zooplankton collections 
b <- read.csv("195101-201404_Zoop.csv")

##Checking the data out
head(b)
str(b)

#Goal 1: extract the year and follow previous workflow
dateb <- as.character(b$Tow_Date)

yrb <- substr(dateb, 6,9)
head(yrb)

b1 <-  bind_cols(b, yrb)

##Check to see if this worked 
head(b1)

#Rename the column to date
b1 <- rename(b1, year = ...27)


#Goal2 is to split the lat and lon into individual pieces, fix them, and then put them back together

#seperate degerees
lat_deg <- as.character(b$Lat_Deg)

lon_deg <- as.character(b$Lon_Deg)

#Seperate Minutes and Seconds
lat_min <- str_sub(string = b1$Lat_Min, start = 1, end = 2)

lon_min <- str_sub(string = b1$Lon_Min, start = 1, end = 2)

lon_sec <- str_sub(string = b1$Lon_Min, start = 3, end = 4)
lon_sec <- is.na(lon_sec)
##Check to see if this worked
head(lat_deg)
head(lon_deg)

head(lat_min)

head(lon_min)
head(lon_sec)

#Change from charaters to numeric 
lat_deg <- as.numeric(lat_deg)
lon_deg <- as.numeric(lon_deg)

lat_min <- as.numeric(lat_min)

lon_min <- as.numeric(lon_min)

lon_sec <- as.numeric(lon_sec)

#Fixing missing data
lon_sec[is.na(lon_sec)] = 0


#Start Processing to get decimal degrees

#change lat into decimal degrees
head(lat_min)

deg.lat <- lat_deg + lat_min/60
head(deg.lat)


#Change Long into decimal degrees, since the longitude cordinates have seconds they need to be incorperated 
min.lon <- lon_min + lon_sec/60

head(min.lon)


deg.long <- (lon_deg + min.lon/60)*-1 #multiply the longitude by a negative one because the cardinal direction is west "W"
head(deg.long)


#Step 3: put them back into the data set!
b1$lon.decdeg <- deg.long
b1$lat.decdeg <- deg.lat

#Select the required data

b2 <- select(b1,"Cruise","St_Station","Tow_Date","Tow_Time","Vol_StrM3", "Tow_DpthM","lat.decdeg","lon.decdeg","year")

#Write to new file
write.csv(b2, file = "Zoop_edit.csv")
