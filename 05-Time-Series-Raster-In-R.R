## ----load-libraries------------------------------------------------------

library(raster)
library(rgdal)


## ----import-ndvi-rasters-------------------------------------------------

# Create list of NDVI file paths
NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"  #assign path to object = cleaner code
all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")

#view list - note the full path, relative to our working directory, is included
all_NDVI


## ----create-timeSeries-raster-stack--------------------------------------
# Create a time series raster stack
NDVI_stack <- stack(all_NDVI)

## ----explore-RasterStack-tags--------------------------------------------
#view crs of rasters
crs(NDVI_stack)

#view extent of rasters in stack
extent(NDVI_stack)

#view the y resolution of our rasters
yres(NDVI_stack)

#view the x resolution of our rasters
xres(NDVI_stack)


## ----challenge-code-raster-metadata, eval=FALSE, echo=FALSE--------------
## #1. UTM zone 19 WGS 84
## #2. 30x30 meters
## 

## ----plot-time-series----------------------------------------------------

#view a plot of all of the rasters
#'nc' specifies number of columns (we will have 13 plots)
plot(NDVI_stack, 
     zlim = c(1500, 10000), 
     nc = 4)


## ----view-stack-histogram------------------------------------------------

#create histograms of each image
hist(NDVI_stack, 
     xlim = c(0, 10000))


## ----view-temp-data, echo=FALSE------------------------------------------

library(ggplot2)
library(scales)
harMetDaily <- read.csv("AtmosData/HARV/hf001-06-daily-m.csv",
                 stringsAsFactors = FALSE)

#set the field to be a date field
harMetDaily$date <- as.Date(harMetDaily$date, format = "%Y-%m-%d")

#subset out some of the data - 2010-2013 
yr.09.11_dailyAvg <- subset(harMetDaily, date >= as.Date('2011-01-01') & date <=
as.Date('2012-01-01'))

#plot Air Temperature Data (airt) by julian day (jd)
  
myPlot <- ggplot(yr.09.11_dailyAvg,aes(jd, airt)) +
           geom_point() +
           ggtitle("2011 Air Temperature\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Julian Day") + ylab("Mean Air Temperature")

myPlot


## ----view-all-rgb, echo=FALSE--------------------------------------------
#open up the cropped files
#create list of files to make raster stack
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


#code parrallel to what was previously taught in lesson
#RGB_NDVIstack <- stack(rgb.allCropped)
#plotRGB(RGB_NDVIstack,
     #r = 1, g = 2, b = 3,
     #stretch ="lin")

#reset layout
par(mfrow=c(1,1))


