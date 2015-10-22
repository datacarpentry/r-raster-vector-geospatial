## ----load-libraries------------------------------------------------------

#work with rasters
library(raster)
#best for importing shapefiles
library(rgdal) 
#plotting
library(ggplot2)

options(stringsAsFactors = FALSE)

#set the working directory
setwd("~/Documents/data/1_DataPortal_Workshop/1_WorkshopData")


## ----view-basemap--------------------------------------------------------

#import imagery
chm <- raster("NEON_RemoteSensing/HARV/CHM/HARV_chmCrop.tif")
#plot chm (make map?)
plot(chm, main="NEON Canopy Height Model (Tree Height)\nHarvard Forest")

#customize legend, add units (m), remove x and y labels



## ----import-rgb-image----------------------------------------------------
################### IMPORT MULTI BAND RASTER (image) #########################
#note that when you import a multi band image you have to import it as a stack 
#rather than a raster... this might be worth pointing out in the lesson.
#it could be good to start with just a single band raster like a CHM, DEM etc?

baseImage <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

#plot the image for the site
#is there a way to plot RGB and add titles, etc (data viz group??)
plotRGB(baseImage,r=1,g=2,b=3, 
        main="Harvard Tower Site")


## ----work-with-vectors---------------------------------------------------
#Import the shapefile 
#note: read ogr is preferred as it maintains prj info
squarePlot <- readOGR("boundaryFiles/HARV/","HarClip_UTMZ18")

#view attributes
squarePlot

#view crs
crs(squarePlot)
#view extent
extent(squarePlot)

#look at the polygon
plot(squarePlot, col="purple")

#look at the polygon on top of the imagery
plotRGB(baseImage)

#add the plot boundary to the image. Make it a transparent box with a thick outline
#Note: leah needs to fix the crop box to make it UTM z18 friendly! it will happen.
plot(squarePlot, col="yellow", add=TRUE)

#open a line shapefile
#NOte: this file has attributes so the viz group should work on 
#making maps with multi attribute shapefiles
#adding legends, etc
roads <- readOGR("boundaryFiles/HARV/","HARV_roadStream")
plot(roads, col="yellow", add=TRUE)

#add a point
tower <- readOGR("boundaryFiles/HARV/","HARVtower_UTM18N")
#make this a cooler symbol
plot(tower, col="red", add=TRUE)


## ----crop-image----------------------------------------------------------
#crop the image to the plot boundary?
#note that crop just uses the extent - not that actual shape of the polygon.
new <- crop(baseImage,squarePlot)

plotRGB(new, axes=F,main="RGB image cropped")
#not sure how to add a title to plotRGB??

#export geotiff
#write the geotiff - change overwrite=TRUE to overwrite=FALSE if you want to 
#make sure you don't overwrite your files!
writeRaster(new,"new","GTiff", overwrite=TRUE)


## ----process-NDVI-images-HARV--------------------------------------------

#define the path to write tiffs
#the other time series for the california sites is in NDVI/D17
#Note: if it's best we can also remove the nesting of folders here. I left it
#just to remember where i got the data from originally! i can just include a note to myself.
ndvi.tifPath <- "Landsat_NDVI/HARV/2011/ndvi/"

#open up the cropped files
#create list of files to make raster stack
allCropped <-  list.files(ndvi.tifPath, full.names=TRUE, pattern = ".tif$")

#create a raster stack from the list
rastStack <- stack(allCropped)

#layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
#would like to figure out how to plot these with 2-3 in each row rather than 4
plot(rastStack, zlim=c(1500,10000),nc=3)

#VIZ people can show us how to customize the title on the plots
#Viz people can show us how to adjust the LAYOUT so the figures
#are easier to read...

#adjust the layout
#par(mfrow=c(7,2))
#not sure how to plot fewer columns without throwing errors

#plot histograms for each image
hist(rastStack,xlim=c(1500,10000))

## ----plot-rgb-images-----------------------------------------------------


#open up the cropped files
#create list of files to make raster stack
rgb.allCropped <-  list.files("Landsat_NDVI/HARV/2011/RGB/", full.names=TRUE, pattern = ".tif$")

#create a layout
par(mfrow=c(4,4))

#plot all images
#would be nice to label each one but not sure how with plotRGB
for (aFile in rgb.allCropped){
  ndvi.rastStack <- stack(aFile)
  plotRGB(ndvi.rastStack, stretch="lin")
}

#reset layout
par(mfrow=c(1,1))

## ----calc-NDVI-----------------------------------------------------------
#create data frame, calculate NDVI
ndvi.df.HARV <- as.data.frame(matrix(-999, ncol = 2, nrow = length(allCropped)))
colnames(ndvi.df.HARV) <- c("julianDays", "meanNDVI")
i <- 0
for (crop in allCropped){
  i=i+1
  #open raster
  imageCrop <- raster(crop)
  
  #calculate the mean of each
  ndvi.df.HARV$meanNDVI[i] <- cellStats(imageCrop,mean) 
  
  #grab julian days
  ndvi.df.HARV$julianDays[i] <- substr(crop,nchar(crop)-21,nchar(crop)-19)
}

#add and populate a year column to the data frame
ndvi.df.HARV$yr <- as.integer(2009)
#add and populate a site column to the data frame
ndvi.df.HARV$site <- "HARV"


## ----plot-mean-NDVI------------------------------------------------------
##plot stuff
#need to figure out the best plotting method to connect the dots! Or a better input format object
#we also should remove bad points in this layer and explain why the points are bad 
#cloud cover)
ggplot(ndvi.df.HARV, aes(julianDays, meanNDVI)) +
  geom_point(size=4,colour = "blue") + 
  ggtitle("NDVI for HARVARD forest 2011\nLandsat Derived") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


## ----process-NDVI-images-SJER--------------------------------------------

#define the path to write tiffs
tifPath <- "Landsat_NDVI/SJER/2011/ndvi/"

#open up the cropped files
#create list of files to make raster stack
allCropped <-  list.files(tifPath, full.names=TRUE, pattern = ".tif$")

#create a raster stack from the list
rastStack <- stack(allCropped)

#layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
#would like to figure out how to plot these with 2-3 in each row rather than 4
plot(rastStack, zlim=c(1500,10000),nc=3)

#adjust the layout
#par(mfrow=c(7,2))
#not sure how to plot fewer columns without throwing errors

#plot histograms for each image
hist(rastStack,xlim=c(1500,10000))

#create data frame, calculate NDVI
ndvi.df.SJER <- as.data.frame(matrix(-999, ncol = 2, nrow = length(allCropped)))
colnames(ndvi.df.SJER) <- c("julianDays", "meanNDVI")
i <- 0
for (crop in allCropped){
  i=i+1
  #open raster
  imageCrop <- raster(crop)
  
  #calculate the mean of each
  ndvi.df.SJER$meanNDVI[i] <- cellStats(imageCrop,mean) 
  
  #grab julian days
  ndvi.df.SJER$julianDays[i] <- substr(crop,nchar(crop)-21,nchar(crop)-19)
}

ndvi.df.SJER$yr <- as.integer(2011)
ndvi.df.SJER$site <- "SJER"

#plot NDVI
ggplot(ndvi.df.SJER, aes(julianDays, meanNDVI)) +
  geom_point(size=4,colour = "blue") + 
  ggtitle("NDVI for SJER 2011\nLandsat Derived") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


## ----create-animation----------------------------------------------------

#create animation ot the NDVI outputs
library(animation)

#if(!file.exists("ndvi.gif")) { # Check if the file exists
  saveGIF(
    for (i in 1:length(allCropped)) {
                      plot(rastStack[[i]],
                      main=names(rastStack[[i]]),
                      legend.lab="NDVI",
                      col=rev(terrain.colors(30)),
                      zlim=c(1500,10000) )
      }, 
    movie.name = "ndvi.gif", 
    ani.width = 300, ani.height = 300, 
    interval=.5)
#}


## ----compare-NDVI--------------------------------------------------------
  
#Compare the two sites
ndvi.df <- rbind(ndvi.df.SJER,ndvi.df.HARV)  
  
#plot NDVI
#make it look prettier
ggplot(ndvi.df, aes(julianDays, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + geom_line(aes(group=site))+
  ggtitle("NDVI HARV vs. SJER 2011\nLandsat Derived") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))


#the end of this section  
  

## ----project-organization------------------------------------------------
#might have stuff about storing data
#stuff on the files associated with a shapefile

#in this case, our data are organized by
#metric or type of data and then location then year. 
#thinking about organizing data is important.

#crs and metadata in the geospatial world is also important...


## ----load-libraries-date-function----------------------------------------

#load ggplot for plotting 
library(ggplot2)
#the scales library supports breaks and formatting in ggplot
library(scales)

#don't load strings as factors
options(stringsAsFactors = FALSE)


## ----import-harvard-met-data-15min---------------------------------------


#read in 15 min average data
harMet <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv")

#clean up dates
#remove the "T"
#harMet$datetime <- fixDate(harMet$datetime,"America/New_York")

# Replace T and Z with a space
harMet$datetime <- gsub("T|Z", " ", harMet$datetime)
  
#set the field to be a date field
harMet$datetime <- as.POSIXct(harMet$datetime,format = "%Y-%m-%d %H:%M", 
                          tz = "GMT")

#list of time zones
#https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#convert to local time for pretty plotting
attributes(harMet$datetime)$tzone <- "America/New_York"

#subset out some of the data - 2010-2013 
yr.09.11 <- subset(harMet, datetime >= as.POSIXct('2009-01-01 00:00') & datetime <=
as.POSIXct('2011-01-01 00:00'))

#as.Date("2006-02-01 00:00:00")
#plot Some Air Temperature Data
  
myPlot <- ggplot(yr.09.11,aes(datetime, airt)) +
           geom_point() +
           ggtitle("15 min Avg Air Temperature\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
myPlot + scale_x_datetime(labels = date_format("%m/%d/%y"))




## ----convert-daily-------------------------------------------------------
#convert to daily  julian days
temp.daily <- aggregate(yr.09.11["airt"], format(yr.09.11["datetime"],"%Y-%j"),
                 mean, na.rm = TRUE) 


#not working yet - weird!
#qplot(temp.daily$datetime,temp.daily$airt)
#ggplot(temp.daily,aes(datetime, airt)) +
#           geom_point() +
#           ggtitle("Daily Avg Air Temperature\nHarvard Forest") +
#           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
#          theme(text = element_text(size=20)) +
#           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
#myPlot + scale_x_date(labels = date_format("%m/%d/%y"))


## ----read-Daily-avg------------------------------------------------------

#read in daily data
harMetDaily <- read.csv(file="AtmosData/HARV/hf001-06-daily-m.csv")

  
#set the field to be a date field
harMetDaily$date <- as.Date(harMetDaily$date, format = "%Y-%m-%d")

#subset out some of the data - 2010-2013 
yr.09.11_monAvg <- subset(harMetDaily, date >= as.Date('2009-01-01') & date <=
as.Date('2011-01-01'))

#as.Date("2006-02-01 00:00:00")
#plot Some Air Temperature Data
  
myPlot <- ggplot(yr.09.11_monAvg,aes(date, airt)) +
           geom_point() +
           ggtitle("Daily Air Temperature\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
myPlot + scale_x_date(labels = date_format("%m/%d/%y"))


#plot Some Air Temperature Data
  
myPlot <- ggplot(yr.09.11_monAvg,aes(date, prec)) +
           geom_point() +
           ggtitle("Daily Precipitation\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
myPlot + scale_x_date(labels = date_format("%m/%d/%y"))

#plot Some Air Temperature Data
  
myPlot <- ggplot(yr.09.11_monAvg,aes(date, part)) +
           geom_point() +
           ggtitle("Daily Avg Total PAR\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Total PAR")

#format x axis with dates
myPlot + scale_x_date(labels = date_format("%m/%d/%y"))



## ----soil-temp-----------------------------------------------------------

#
#plot soil temp data 
  
myPlot <- ggplot(yr.09.11_monAvg,aes(date, s10t)) +
           geom_point() +
           ggtitle("Daily Avg Soil Temp\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Soil Temp")

#format x axis with dates
myPlot + scale_x_date(labels = date_format("%m/%d/%y"))


## ------------------------------------------------------------------------


## ----Clean-Up-Day-Length-------------------------------------------------

#load the lubridate package to work with time
library(lubridate)
#readr is ideal to open fixed width files (faster than utils)
library(readr)

#read in fixed width file  
dayLengthHar2011 <- read.fwf(
  file="daylength/HARV/Petersham_Mass_2011.txt",
  widths=c(8,9,9,9,9,9,9,9,9,9,9,9,9))
 
names(dayLengthHar2011) <- c("Day","Jan","Feb","Mar","Apr",
                             "May","June","July","Aug","Sept",
                             "Oct","Nov","Dec") 
#open file  
#dayLengthHar2015 <- read.csv(file = "precip_Daylength/Petersham_Mass_2009.txt", stringsAsFactors = FALSE)

#just pull out the columns with time information
tempDF <- dayLengthHar2011[,2:13]
tempDF[] <- lapply(tempDF, function(x){hm(x)$hour + hm(x)$minute/60})
#populate original DF with the new time data in decimal hours 
dayLengthHar2011[,2:13] <- tempDF

#plot One MOnth of  data
ggplot(dayLengthHar2011, aes(Day, Jan)) +
  geom_point()+
  ggtitle("Day Length\nJan 2009") +
  xlab("Day of Month") + ylab("Day Length (Hours)") +
  theme(text = element_text(size=20))



## ----plot-daylength------------------------------------------------------

#convert to julian days

#stack the data frame
dayLengthHar2011.st <- stack(dayLengthHar2011[2:13])
#remove NA values
dayLengthHar2011.st <- dayLengthHar2011.st[complete.cases(dayLengthHar2011.st),]
#add julian days (count)
dayLengthHar2011.st$JulianDay<-seq.int(nrow(dayLengthHar2011.st))
#fix names
names(dayLengthHar2011.st) <- c("Hours","Month","JulianDay")

#plot Years Worth of  data
ggplot(dayLengthHar2011.st, aes(JulianDay,Hours)) +
  geom_point()+
  ggtitle("Day Length\nJan 2011") +
  xlab("Julian Days") + ylab("Day Length (Hours)") +
  theme(text = element_text(size=20))


## ----data-viz------------------------------------------------------------


#Here are things to work on

# Creating a Map in r with a legend and multiple elements
# import the RGB base image, the shapefile, color the shapefile by atttibute
# add teh point, customize symbology, colors, labels, title, etc, add a north arrow
# SO imagine a GIS work flow but do that in R.

# Create a leaflet map showing something?? (optional but could be cool. would require
#converting to geojson potentially)

#customizing Ggplots and adding multiple variables that are different 
#IE the dataframes can't be stacked.



## ------------------------------------------------------------------------
#end of section

