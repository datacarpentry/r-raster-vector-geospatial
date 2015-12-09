## ----load-libraries------------------------------------------------------

library(raster)
library(rgdal)
library(ggplot2)


## ----import-ndvi-rasters-------------------------------------------------

# Create list of NDVI file paths
NDVI_path_HARV <- "Landsat_NDVI/HARV/2011/ndvi"
all_NDVI_HARV <- list.files(NDVI_path_HARV, full.names = TRUE, pattern = ".tif$")

#view list - note that the full path (relative to our working directory)
#is included
all_NDVI_HARV

# Create a time series raster stack
NDVI_stack_HARV <- stack(all_NDVI_HARV)


## ----calculate-avg-NDVI--------------------------------------------------
#calculate mean NDVI for each raster
avg_NDVI_HARV <- cellStats(NDVI_stack_HARV,mean)

#convert output to data.frame
avg_NDVI_HARV <- as.data.frame(avg_NDVI_HARV)

#We can do the above two steps with one line of code
avg_NDVI_HARV <- as.data.frame(cellStats(NDVI_stack_HARV,mean))

avg_NDVI_HARV

## ----view-dataframe-output-----------------------------------------------
#view row names for data frame
row.names(avg_NDVI_HARV)

#view the first value in the data.frame
avg_NDVI_HARV[1,1]

#view column names
names(avg_NDVI_HARV)

#rename the NDVI column
names(avg_NDVI_HARV) <- "meanNDVI"

#view cleaned column names
names(avg_NDVI_HARV)



## ----insert-site-name----------------------------------------------------

#add a site column to our data
avg_NDVI_HARV$site <- "HARV"


## ----extract-julian-day--------------------------------------------------

#note the use of | is equivalent to "or". this allows us to search for more than
#one pattern in our text strings
julianDays <- gsub(pattern = "X|_HARV_ndvi_crop", #the pattern to find 
            x = row.names(avg_NDVI_HARV), #the object containing the strings
            replacement = "") #what to replace each instance of the pattern with

#make sure output looks ok
head(julianDays)

#add julianDay values as a column in the dataframe
avg_NDVI_HARV$julianDay <- julianDays

#what class is the new column
class(avg_NDVI_HARV$julianDay)

#convert julian days into a time class
#avg_NDVI_HARV$julianDay <- as.POSIXlt(avg_NDVI_HARV$julianDay, format="%j")

#the code above does weird things. for one i think jday is 0 based indexing
#but also it seems to want a year and defaults to 2015. i am not sure how to force 
#it to 2011 which is when the data were collected
#being lazy and useing int for the time being.
avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)

# Parse that character vector
#strptime(date_info, "%Y %j")

## ----scale-data----------------------------------------------------------

#scale data by 10,000
avg_NDVI_HARV$meanNDVI <- avg_NDVI_HARV$meanNDVI / 10000
#view output
head(avg_NDVI_HARV)


## ----plot-data-----------------------------------------------------------

#plot NDVI
ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "blue") + 
  ggtitle("NDVI for HARV 2011\nLandsat Derived") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))



## ----challenge-answers, echo=FALSE---------------------------------------


# Create list of NDVI file paths
NDVI_path_SJER <- "Landsat_NDVI/SJER/2011/ndvi"
all_NDVI_SJER <- list.files(NDVI_path_SJER, full.names = TRUE, pattern = ".tif$")

# Create a time series raster stack
NDVI_stack_SJER <- stack(all_NDVI_SJER)


#Calculate Mean, Scale Data, convert to data.frame
avg_NDVI_SJER <- as.data.frame(cellStats(NDVI_stack_SJER,mean)/10000)

#rename NDVI column
names(avg_NDVI_SJER) <- "meanNDVI"


#add a site column to our data
avg_NDVI_SJER$site <- "SJER"


#Create Julian Day Column 
julianDays_SJER <- gsub(pattern = "X|_SJER_ndvi_crop", #the pattern to find 
            x = row.names(avg_NDVI_SJER), #the object containing the strings
            replacement = "") #what to replace each instance of the pattern with

#add julianDay values as a column in the dataframe
avg_NDVI_SJER$julianDay <- as.integer(julianDays_SJER)

#Merge Data Frames
ndvi_HARV_SJER <- rbind(avg_NDVI_HARV,avg_NDVI_SJER)  
  
#plot NDVI
#make it look prettier
ggplot(ndvi_HARV_SJER, aes(julianDay, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + 
  geom_line(aes(group=site)) +
  ggtitle("Landsat Derived NDVI - 2011\nNEON Harvard Forest vs San Joachim Field Sites") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


