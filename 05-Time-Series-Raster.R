## ----load-libraries------------------------------------------------------

library(raster)
library(rgdal)
library(rasterVis)


## ----import-ndvi-rasters-------------------------------------------------

# Create list of NDVI file paths
NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"
all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")

#view list - note that the full path (relative to our working directory)
#is included
all_NDVI


## ----create-timeSeries-raster-stack--------------------------------------
# Create a time series raster stack
NDVI_stack <- stack(all_NDVI)

#view crs of rasters
crs(NDVI_stack)

#view extent of rasters in stack
extent(NDVI_stack)

#view the y resolution of our rasters
yres(NDVI_stack)

#view the x resolution of our rasters
xres(NDVI_stack)


## ----plot-time-series----------------------------------------------------

#view a histogram of all of the rasters
#nc specifies number of columns
plot(NDVI_stack, 
     zlim = c(1500, 10000), 
     nc = 4)


## ----levelplot-time-series-----------------------------------------------

library(rasterVis)

#create a level plot - plot
levelplot(NDVI_stack,
          main="Landsat NDVI\nHarvard Forest")


## ----change-color-ramp---------------------------------------------------
#use color brewer which loads with rasterVis to generate
#a color ramp of yellow to green
cols <- colorRampPalette(brewer.pal(9,"YlGn"))
#create a level plot - plot
levelplot(NDVI_stack,
          main="Landsat NDVI better colors \nHarvard Forest",
          col.regions=cols)



## ----view-stack-histogram------------------------------------------------

#create histogram
hist(NDVI_stack, xlim = c(0, 10000))


## ----view-temp-data, echo=FALSE------------------------------------------

library(ggplot2)
library(scales)
harMetDaily <- read.csv("AtmosData/HARV/hf001-06-daily-m.csv",
                 stringsAsFactors = FALSE)

#set the field to be a date field
harMetDaily$date <- as.Date(harMetDaily$date, format = "%Y-%m-%d")

#subset out some of the data - 2010-2013 
yr.09.11_monAvg <- subset(harMetDaily, date >= as.Date('2011-01-01') & date <=
as.Date('2012-01-01'))

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


## ----view-all-rgb, echo=FALSE--------------------------------------------
# we can create a prettier time series using level plot

#open up the cropped files
#create list of files to make raster stack
rgb.allCropped <-  list.files("Landsat_NDVI/HARV/2011/RGB/", 
                              full.names=TRUE, 
                              pattern = ".tif$")

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


