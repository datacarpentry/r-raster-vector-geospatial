## ----load-libraries------------------------------------------------------

#load libraries
library(raster)
library(rgdal)


## ----import-NDVI-rasters-------------------------------------------------

# Create list of NDVI file paths
# assign path to object = cleaner code
NDVI_HARV_path <- "NEON-DS-Landsat-NDVI/HARV/2011/NDVI" 
all_NDVI_HARV <- list.files(NDVI_HARV_path,
                            full.names = TRUE,
                            pattern = ".tif$")

#view list - note the full path, relative to our working directory, is included
all_NDVI_HARV


## ----create-timeSeries-raster-stack--------------------------------------

# Create a raster stack of the NDVI time series
NDVI_HARV_stack <- stack(all_NDVI_HARV)


## ----explore-RasterStack-tags--------------------------------------------
#view crs of rasters
crs(NDVI_HARV_stack)

#view extent of rasters in stack
extent(NDVI_HARV_stack)

#view the y resolution of our rasters
yres(NDVI_HARV_stack)

#view the x resolution of our rasters
xres(NDVI_HARV_stack)


## ----challenge-code-raster-metadata, eval=FALSE, echo=FALSE--------------
## #1. UTM zone 19 WGS 84
## #2. 30x30 meters
## #3. meters
## 

## ----plot-time-series----------------------------------------------------

#view a plot of all of the rasters
#'nc' specifies number of columns (we will have 13 plots)
plot(NDVI_HARV_stack, 
     zlim = c(1500, 10000), 
     nc = 4)


## ----apply-scale-factor--------------------------------------------------

#apply scale factor to data
NDVI_HARV_stack <- NDVI_HARV_stack/10000
#plot stack with scale factor applied
#apply scale factor to limits to ensure uniform plottin
plot(NDVI_HARV_stack,
     zlim = c(.15, 1),  
     nc = 4)


## ----view-stack-histogram------------------------------------------------

#create histograms of each raster
hist(NDVI_HARV_stack, 
     xlim = c(0, 1))


## ----view-temp-data, echo=FALSE, warning=FALSE---------------------------

library(ggplot2)
library(scales)
harMetDaily <- 
  read.csv("NEON-DS-Met-Time-Series/HARV/FisherTower-Met/hf001-06-daily-m.csv",
                 stringsAsFactors = FALSE)

#set the field to be a date field
harMetDaily$date <- as.Date(harMetDaily$date, format = "%Y-%m-%d")

#subset out some of the data - 2011
yr.11_dailyAvg <- subset(harMetDaily, 
                            date >= as.Date('2011-01-01') & 
                            date <= as.Date('2011-12-31'))

#plot Air Temperature Data (airt) by julian day (jd)
  
myPlot <- ggplot(yr.11_dailyAvg,aes(jd, airt)) +
           geom_point() +
           ggtitle("Daily Mean Air Temperature\nNEON Harvard Forest Field Site") +
           theme(plot.title = element_text(lineheight=.8, face="bold",
                                           size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Julian Day 2011") + ylab("Mean Air Temperature (Celcius)")

myPlot


## ----view-all-rgb, echo=FALSE--------------------------------------------
#open up the cropped files
#create list of files to make raster stack
RGB_HARV_allCropped <-  list.files("NEON-DS-Landsat-NDVI/HARV/2011/RGB/", 
                              full.names=TRUE, 
                              pattern = ".tif$")

#create a layout
par(mfrow=c(4,4))

#Super efficient code
for (aFile in RGB_HARV_allCropped){
  NDVI.rastStack <- stack(aFile)
  plotRGB(NDVI.rastStack, stretch="lin")
}

#code parrallel to what was previously taught in lesson
#RGB_NDVI_HARV_stack <- stack(RGB_HARV_allCropped)
#plotRGB(RGB_HARV_NDVIstack,
     #r = 1, g = 2, b = 3,
     #stretch ="lin")

#reset layout
par(mfrow=c(1,1))


