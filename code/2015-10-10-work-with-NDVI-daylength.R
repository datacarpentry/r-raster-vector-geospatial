## ----load-libraries------------------------------------------------------

#work with rasters
library(raster)
#best for importing shapefiles
library(rgdal) 
#plotting
library(ggplot2)

options(stringsAsFactors = FALSE)

#set the working directory
setwd("~/Documents/data/1_DataPortal_Workshop")

## ----view-basemap--------------------------------------------------------

#import imagery
baseImage <- stack("AOP/14060113_EH021656(20140601155722)-0263_ort.tif")

#plot the image for the site
plotRGB(baseImage,r=1,g=2,b=3, 
        main="Harvard Tower Site")

#add the shapefile 
#note: read ogr is preferred as it maintains prj info
squarePlot <- readOGR("Landsat_TimeSeries/","HarClip_UTMZ18")

#add the plot boundary to the image.
plot(squarePlot, col="yellow", add=TRUE)

## ----crop-image----------------------------------------------------------
#crop the image to the plot boundary?
new <- crop(baseImage,squarePlot)

plotRGB(new, axes=F,main="RGB image cropped")
#not sure how to add a title to plotRGB??

#export geotiff
#write the geotiff - change overwrite=TRUE to overwrite=FALSE if you want to 
#make sure you don't overwrite your files!
writeRaster(new,"new","GTiff", overwrite=TRUE)


## ----process-NDVI-images-------------------------------------------------

#define the path to write tiffs
tifPath <- "Landsat_TimeSeries/D01/LS5/P12R31/2011/"

#open up the cropped files
#create list of files to make raster stack
allCropped <-  list.files(tifPath, full.names=TRUE)

#create a raster stack from the list
rastStack <- stack(allCropped)



#layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
#would like to figure out how to plot these with 2-3 in each row rather than 4
plot(rastStack, zlim=c(1500,10000),nc=3)

#adjust the layout
par(mfrow=c(7,2))
#plot histograms for each image
hist(rastStack,xlim=c(1500,10000))

#create data frame, calculate NDVI
ndvi.df <- as.data.frame(matrix(-999, ncol = 2, nrow = length(allCropped)))
colnames(ndvi.df) <- c("julianDays", "meanNDVI")
i <- 0
for (crop in allCropped){
  i=i+1
  #open raster
  imageCrop <- raster(crop)
  
  #calculate the mean of each
  ndvi.df$meanNDVI[i] <- cellStats(imageCrop,mean) 
  
  #grab julian days
  ndvi.df$julianDays[i] <- substr(crop,nchar(crop)-16,nchar(crop)-14)
}


## ----plot-mean-NDVI------------------------------------------------------
##plot stuff
#need to figure out the best plotting method to connect the dots! Or a better input format object

ggplot(ndvi.df, aes(julianDays, meanNDVI)) +
  geom_point(size=4,colour = "blue") +
  ggtitle("NDVI for 2011\nLandsat Derived") +
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


## ----load-rgb-image------------------------------------------------------

#load the imagery here. Then potentially crop it. Use as a base map
  
#load xy point for tower location - overlay on to imagery base map
  
#load the CHM here. then crop it and get average tree height
  
#load DTM hill shade -- use that as a base map??
  
  

## ----Clean-Up-Day-Length-------------------------------------------------

#load the lubridate package to work with time
library(lubridate)
#readr is ideal to open fixed width files (faster than utils)
library(readr)

#read in fixed width file  
dayLengthHar2011 <- read.fwf(
  file="precip_Daylength/Petersham_Mass_2011.txt",
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


