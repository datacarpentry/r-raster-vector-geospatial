## ----load-libraries-data-------------------------------------------------

library(raster)
library(rgdal)
library(ggplot2)

# Create list of NDVI file paths
NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"  #assign path to object = cleaner code
all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")

# Create a time series raster stack
NDVI_stack <- stack(all_NDVI)

## ----calculate-avg-NDVI--------------------------------------------------
#calculate mean NDVI for each raster
avg_NDVI_HARV <- cellStats(NDVI_stack,mean)

#convert output array to data.frame
avg_NDVI_HARV <- as.data.frame(avg_NDVI_HARV)

#To be more efficient we could do the above two steps with one line of code
#avg_NDVI_HARV <- as.data.frame(cellStats(NDVI_stack_HARV,mean))

#view data
avg_NDVI_HARV

#view only the value in row 1, column 1 of the data frame
avg_NDVI_HARV[1,1]

## ----view-dataframe-output-----------------------------------------------
#view column name slot
names(avg_NDVI_HARV)

#rename the NDVI column
names(avg_NDVI_HARV) <- "meanNDVI"

#view cleaned column names
names(avg_NDVI_HARV)

## ----insert-site-name----------------------------------------------------
#add a site column to our data
avg_NDVI_HARV$site <- "HARV"

#add a "year" column to our data
avg_NDVI_HARV$year <- "2011"

#view data
head(avg_NDVI_HARV)

## ----extract-julian-day--------------------------------------------------
#note the use of the vertical bar character ( | ) is equivalent to "or". This
# allows us to search for more than one pattern in our text strings.
julianDays <- gsub(pattern = "X|_HARV_ndvi_crop", #the pattern to find 
            x = row.names(avg_NDVI_HARV), #the object containing the strings
            replacement = "") #what to replace each instance of the pattern with

#alternate format
#julianDays <- gsub("X|_HARV_ndvi_crop", "", row.names(avg_NDVI_HARV))

#make sure output looks ok
head(julianDays)

#add julianDay values as a column in the data frame
avg_NDVI_HARV$julianDay <- julianDays

#what class is the new column
class(avg_NDVI_HARV$julianDay)

## ----convert-jd----------------------------------------------------------
#set the origin for the julian date (1 Jan 2011)
origin<-as.Date ("2011-01-01")

#convert "julianDay" from class character to integer
avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)

#create a date column
avg_NDVI_HARV$Date<- origin + avg_NDVI_HARV$julianDay

#did it work? 
head(avg_NDVI_HARV$Date)

#What are the classes of the two columns now? 
class(avg_NDVI_HARV$Date)
class(avg_NDVI_HARV$julianDay)


## ----scale-data----------------------------------------------------------
#de-scale data by 10,000
avg_NDVI_HARV$meanNDVI <- avg_NDVI_HARV$meanNDVI / 10000

#view output
head(avg_NDVI_HARV)


## ----challenge-answers,  include=TRUE, results="hide", echo=FALSE--------
# Create list of NDVI file paths
NDVI_path_SJER <- "Landsat_NDVI/SJER/2011/ndvi"
all_NDVI_SJER <- list.files(NDVI_path_SJER, full.names = TRUE, pattern = ".tif$")

# Create a time series raster stack
NDVI_stack_SJER <- stack(all_NDVI_SJER)


#Calculate Mean, Scale Data, convert to data.frame all in 1 line!
avg_NDVI_SJER <- as.data.frame(cellStats(NDVI_stack_SJER,mean)/10000)

#rename NDVI column
names(avg_NDVI_SJER) <- "meanNDVI"

#add a site column to our data
avg_NDVI_SJER$site <- "SJER"

#add a "year" column to our data
avg_NDVI_SJER$year <- "2011"

#Create Julian Day Column 
julianDays_SJER <- gsub(pattern = "X|_SJER_ndvi_crop", #the pattern to find 
            x = row.names(avg_NDVI_SJER), #the object containing the strings
            replacement = "") #what to replace each instance of the pattern with

##Create Date column based on julian day & make julianDay an integer

#set the origin for the julian date (1 Jan 2011)
origin<-as.Date ("2011-01-01")

#add julianDay values as a column in the data frame
avg_NDVI_SJER$julianDay <- as.integer(julianDays_SJER)

#create a date column
avg_NDVI_SJER$Date<- origin + avg_NDVI_SJER$julianDay

#did it work? 
avg_NDVI_SJER


## ----ggplot-data---------------------------------------------------------

#plot NDVI
ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "blue") + 
  ggtitle("NDVI for HARV 2011\nLandsat Derived") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


## ----challenge-code-ggplot-data------------------------------------------

#plot NDVI
ggplot(avg_NDVI_SJER, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "darkgreen") + 
  ggtitle("NDVI for SJER 2011\nLandsat Derived") +
  xlab("Julian Day") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


## ----merge-df-single-plot------------------------------------------------
#Merge Data Frames
ndvi_HARV_SJER <- rbind(avg_NDVI_HARV,avg_NDVI_SJER)  
  
#plot NDVI values for both sites
ggplot(ndvi_HARV_SJER, aes(julianDay, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + 
  geom_line(aes(group=site)) +
  ggtitle("Landsat Derived NDVI - 2011\nNEON Harvard Forest vs San Joaquin") +
  xlab("Julian Day") + ylab("Mean NDVI") +
  scale_colour_manual(values=c("blue", "darkgreen")) +   #match previous plots
  theme(text = element_text(size=20))


## ----challenge-code-plot2, echo=FALSE------------------------------------
#plot NDVI values for both sites
ggplot(ndvi_HARV_SJER, aes(Date, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + 
  geom_line(aes(group=site)) +
  ggtitle("Landsat Derived NDVI - 2011\n Harvard Forest vs San Joaquin") +
  xlab("Date") + ylab("Mean NDVI") +
  scale_colour_manual(values=c("blue", "darkgreen")) +   #match previous plots
  theme(text = element_text(size=20))


## ----view-all-rgb, echo=FALSE--------------------------------------------
#open up the cropped files
rgb.allCropped <-  list.files("Landsat_NDVI/HARV/2011/RGB/", 
                              full.names=TRUE, 
                              pattern = ".tif$")
#create a layout
par(mfrow=c(4,4))

#Super efficient code
for (aFile in rgb.allCropped){
  ndvi.rastStack <- stack(aFile)
  plotRGB(ndvi.rastStack, stretch="lin")
}

#reset layout
par(mfrow=c(1,1))

## ----remove-bad-values---------------------------------------------------
#retain only rows with meanNDVI>0.1
avg_NDVI_HARV_clean<-subset(avg_NDVI_HARV, meanNDVI>0.1)

#work?
avg_NDVI_HARV_clean$meanNDVI<0.1

## ----plot-clean-HARV-----------------------------------------------------
#plot without questionable data
ggplot(avg_NDVI_HARV_clean, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "blue") + 
  ggtitle("NDVI for HARV 2011\nLandsat Derived") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))

## ----write-csv-----------------------------------------------------------
#confirm data frame is the way we want it
head(avg_NDVI_HARV_clean)

## ----drop-rownames-write-csv---------------------------------------------
#create new df to prevent changes to avg_NDVI_HARV
NDVI_HARV_toWrite<-avg_NDVI_HARV_clean

#drop the row.names column 
row.names(NDVI_HARV_toWrite)<-NULL

#check data frame
head(NDVI_HARV_toWrite)

#create a .csv of mean NDVI values being sure to give descriptive name
#write.csv(DateFrameName, file="NewFileName")
write.csv(NDVI_HARV_toWrite, file="meanNDVI_HARV_2011.csv")

## ----challenge-code-write-sjer,  include=TRUE, results="hide", echo=FALSE----
#retain only rows with meanNDVI>0.1
avg_NDVI_SJER_clean<-subset(avg_NDVI_SJER, meanNDVI>0.1)

#create new df to prevent changes to avg_NDVI_HARV
NDVI_SJER_toWrite<-avg_NDVI_SJER_clean

#drop the row.names column 
row.names(NDVI_SJER_toWrite)<-NULL

#check data frame
head(NDVI_SJER_toWrite)

#create a .csv of mean NDVI values being sure to give descriptive name
#write.csv(DateFrameName, file="NewFileName")
write.csv(NDVI_SJER_toWrite, file="meanNDVI_SJER_2011.csv")

