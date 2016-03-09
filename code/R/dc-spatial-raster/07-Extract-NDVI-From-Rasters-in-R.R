## ----load-libraries-data-------------------------------------------------

library(raster)
library(rgdal)
library(ggplot2)

# Create list of NDVI file paths
all_HARV_NDVI <- list.files("NEON-DS-Landsat-NDVI/HARV/2011/NDVI",
                            full.names = TRUE,
                            pattern = ".tif$")

# Create a time series raster stack
NDVI_HARV_stack <- stack(all_HARV_NDVI)

# apply scale factor
NDVI_HARV_stack <- NDVI_HARV_stack/10000


## ----calculate-avg-NDVI--------------------------------------------------
# calculate mean NDVI for each raster
avg_NDVI_HARV <- cellStats(NDVI_HARV_stack,mean)

# convert output array to data.frame
avg_NDVI_HARV <- as.data.frame(avg_NDVI_HARV)

# To be more efficient we could do the above two steps with one line of code
# avg_NDVI_HARV <- as.data.frame(cellStats(NDVI_stack_HARV,mean))

# view data
avg_NDVI_HARV

# view only the value in row 1, column 1 of the data frame
avg_NDVI_HARV[1,1]

## ----view-dataframe-output-----------------------------------------------
# view column name slot
names(avg_NDVI_HARV)

# rename the NDVI column
names(avg_NDVI_HARV) <- "meanNDVI"

# view cleaned column names
names(avg_NDVI_HARV)


## ----insert-site-name----------------------------------------------------
# add a site column to our data
avg_NDVI_HARV$site <- "HARV"

# add a "year" column to our data
avg_NDVI_HARV$year <- "2011"

# view data
head(avg_NDVI_HARV)

## ----extract-julian-day--------------------------------------------------

# note the use of the vertical bar character ( | ) is equivalent to "or". This
# allows us to search for more than one pattern in our text strings.
julianDays <- gsub(pattern = "X|_HARV_ndvi_crop", #the pattern to find 
            x = row.names(avg_NDVI_HARV), #the object containing the strings
            replacement = "") #what to replace each instance of the pattern with

# alternately you can include the above code on one single line
# julianDays <- gsub("X|_HARV_NDVI_crop", "", row.names(avg_NDVI_HARV))

# make sure output looks ok
head(julianDays)

# add julianDay values as a column in the data frame
avg_NDVI_HARV$julianDay <- julianDays

# what class is the new column
class(avg_NDVI_HARV$julianDay)

## ----convert-jd----------------------------------------------------------
# set the origin for the julian date (1 Jan 2011)
origin <- as.Date("2011-01-01")

# convert "julianDay" from class character to integer
avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)

# create a date column; -1 added because origin is the 1st. 
# If not -1, 01/01/2011 + 5 = 01/06/2011 which is Julian day 6, not 5.
avg_NDVI_HARV$Date<- origin + (avg_NDVI_HARV$julianDay-1)

# did it work? 
head(avg_NDVI_HARV$Date)

# What are the classes of the two columns now? 
class(avg_NDVI_HARV$Date)
class(avg_NDVI_HARV$julianDay)


## ----challenge-answers, include=TRUE, results="hide", echo=FALSE---------
# Create list of NDVI file paths
NDVI_path_SJER <- "NEON-DS-Landsat-NDVI/SJER/2011/NDVI"
all_NDVI_SJER <- list.files(NDVI_path_SJER,
                            full.names = TRUE,
                            pattern = ".tif$")

# Create a time series raster stack
NDVI_stack_SJER <- stack(all_NDVI_SJER)

# Calculate Mean, Scale Data, convert to data.frame all in 1 line!
avg_NDVI_SJER <- as.data.frame(cellStats(NDVI_stack_SJER,mean)/10000)

# rename NDVI column
names(avg_NDVI_SJER) <- "meanNDVI"

# add a site column to our data
avg_NDVI_SJER$site <- "SJER"

# add a "year" column to our data
avg_NDVI_SJER$year <- "2011"

# Create Julian Day Column 
julianDays_SJER <- gsub(pattern = "X|_SJER_ndvi_crop", #the pattern to find 
            x = row.names(avg_NDVI_SJER), #the object containing the strings
            replacement = "") #what to replace each instance of the pattern with

## Create Date column based on julian day & make julianDay an integer

# set the origin for the julian date (1 Jan 2011)
origin<-as.Date ("2011-01-01")

#add julianDay values as a column in the data frame
avg_NDVI_SJER$julianDay <- as.integer(julianDays_SJER)

# create a date column, 1 once since the origin IS day 1.  
avg_NDVI_SJER$Date<- origin + (avg_NDVI_SJER$julianDay-1)

# did it work? 
avg_NDVI_SJER


## ----ggplot-data---------------------------------------------------------

# plot NDVI
ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI), na.rm=TRUE) +
  geom_point(size=4,colour = "PeachPuff4") + 
  ggtitle("Landsat Derived NDVI - 2011\n NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


## ----challenge-code-ggplot-data, echo=FALSE------------------------------

# plot NDVI
ggplot(avg_NDVI_SJER, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "SpringGreen4") + 
  ggtitle("Landsat Derived NDVI - 2011\n NEON SJER Field Site") +
  xlab("Julian Day") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


## ----merge-df-single-plot------------------------------------------------
# Merge Data Frames
NDVI_HARV_SJER <- rbind(avg_NDVI_HARV,avg_NDVI_SJER)  
  
# plot NDVI values for both sites
ggplot(NDVI_HARV_SJER, aes(julianDay, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + 
  geom_line(aes(group=site)) +
  ggtitle("Landsat Derived NDVI - 2011\n Harvard Forest vs San Joaquin \n NEON Field Sites") +
  xlab("Julian Day") + ylab("Mean NDVI") +
  scale_colour_manual(values=c("PeachPuff4", "SpringGreen4"))+   
	# scale_colour : match previous plots
  theme(text = element_text(size=20))


## ----challenge-code-plot2, echo=FALSE------------------------------------
# plot NDVI values for both sites
ggplot(NDVI_HARV_SJER, aes(Date, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + 
  geom_line(aes(group=site)) +
  ggtitle("Landsat Derived NDVI - 2011\n Harvard Forest vs San Joaquin \n NEON Field Sites") +
  xlab("Date") + ylab("Mean NDVI") +
  scale_colour_manual(values=c("PeachPuff4", "SpringGreen4"))+  # match previous plots
  theme(text = element_text(size=20))


## ----view-all-rgb-Harv---------------------------------------------------
# open up RGB imagery

rgb.allCropped <-  list.files("NEON-DS-Landsat-NDVI/HARV/2011/RGB/", 
                              full.names=TRUE, 
                              pattern = ".tif$")
# create a layout
par(mfrow=c(4,4))

# super efficient code
for (aFile in rgb.allCropped){
  NDVI.rastStack <- stack(aFile)
  plotRGB(NDVI.rastStack, stretch="lin")
  }

# reset layout
par(mfrow=c(1,1))


## ----view-all-rgb-SJER---------------------------------------------------
# open up the cropped files
rgb.allCropped.SJER <-  list.files("NEON-DS-Landsat-NDVI/SJER/2011/RGB/", 
                              full.names=TRUE, 
                              pattern = ".tif$")
# create a layout
par(mfrow=c(5,4))

# Super efficient code
# note that there is an issue with one of the rasters
# NEON-DS-Landsat-NDVI/SJER/2011/RGB/254_SJER_landRGB.tif has a blue band with no range
# thus you can't apply a stretch to it. The code below skips the stretch for
# that one image. You could automate this by testing the range of each band in each image

for (aFile in rgb.allCropped.SJER)
  {NDVI.rastStack <- stack(aFile)
  if (aFile =="NEON-DS-Landsat-NDVI/SJER/2011/RGB//254_SJER_landRGB.tif")
    {plotRGB(NDVI.rastStack) }
  else { plotRGB(NDVI.rastStack, stretch="lin") }
}

# reset layout
par(mfrow=c(1,1))


## ----remove-bad-values---------------------------------------------------

# retain only rows with meanNDVI>0.1
avg_NDVI_HARV_clean<-subset(avg_NDVI_HARV, meanNDVI>0.1)

# Did it work?
avg_NDVI_HARV_clean$meanNDVI<0.1


## ----plot-clean-HARV-----------------------------------------------------

# plot without questionable data

ggplot(avg_NDVI_HARV_clean, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "SpringGreen4") + 
  ggtitle("Landsat Derived NDVI - 2011\n NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


## ----write-csv-----------------------------------------------------------

# confirm data frame is the way we want it

head(avg_NDVI_HARV_clean)


## ----drop-rownames-write-csv---------------------------------------------

# create new df to prevent changes to avg_NDVI_HARV
NDVI_HARV_toWrite<-avg_NDVI_HARV_clean

# drop the row.names column 
row.names(NDVI_HARV_toWrite)<-NULL

# check data frame
head(NDVI_HARV_toWrite)

# create a .csv of mean NDVI values being sure to give descriptive name
# write.csv(DateFrameName, file="NewFileName")
write.csv(NDVI_HARV_toWrite, file="meanNDVI_HARV_2011.csv")


## ----challenge-code-write-sjer,  include=TRUE, results="hide", echo=FALSE----

# retain only rows with meanNDVI>0.1
avg_NDVI_SJER_clean<-subset(avg_NDVI_SJER, meanNDVI>0.1)

# create new df to prevent changes to avg_NDVI_HARV
NDVI_SJER_toWrite<-avg_NDVI_SJER_clean

# drop the row.names column 
row.names(NDVI_SJER_toWrite)<-NULL

# check data frame
head(NDVI_SJER_toWrite)

# create a .csv of mean NDVI values being sure to give descriptive name
# write.csv(DateFrameName, file="NewFileName")
write.csv(NDVI_SJER_toWrite, file="meanNDVI_SJER_2011.csv")


