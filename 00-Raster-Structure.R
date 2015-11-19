## ----load-libraries-1, results='hide', echo=FALSE------------------------

library(raster)
library(rgdal)


## ----elevation-map, echo=FALSE-------------------------------------------
#render DSM for lesson content background
DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# code output here - DEM rendered on the screen
plot(DSM_HARV, main="NEON Elevation Map\nHarvard Forest")


## ----classified-elevation-map, echo=FALSE--------------------------------
# Just a demonstration image for the lesson

#add a color map with 5 colors
col=terrain.colors(3)
#add breaks to the colormap (6 breaks = 5 segments)
brk <- c(250,350, 380,500)

# Expand right side of clipping rect to make room for the legend
par(xpd = FALSE,mar=c(5.1, 4.1, 4.1, 4.5))
#DEM with a custom legend
plot(DSM_HARV, col=col, breaks=brk, main="Classified Elevation Map\nHarvard Forest",legend = FALSE)
#turn xpd back on to force the legend to fit next to the plot.
par(xpd = TRUE)
#add a legend - but make it appear outside of the plot
legend( par()$usr[2], 4713700,
        legend = c("High Elevation", "Middle","Low Elevation"), 
        fill = rev(col))

## ----load-libraries------------------------------------------------------
#load libraries
library(raster)
library(rgdal)


## ----open-raster---------------------------------------------------------
# Make sure to set the directory to your data
# setwd("path-to-data-here")

# Load raster into R
DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# View raster structure
DSM_HARV 

#quickly plot the raster
#note \n in the title forces a line break in the title
plot(DSM_HARV, 
     main="NEON Digital Surface Model\nHarvard Forest")


## ----view-resolution-units-----------------------------------------------
#view resolution units
crs(DSM_HARV)

#assign crs to an object (class) to use for reprojection and other tasks
myCRS <- crs(DSM_HARV)
myCRS

## ----set-min-max---------------------------------------------------------

#This is the code if min/max weren't calculated: 
#DSM_HARV <- setMinMax(DSM_HARV) 

#view the calculated min value
minValue(DSM_HARV)

#view only max value
maxValue(DSM_HARV)


## ----demonstrate-no-data-blaco, echo=FALSE-------------------------------
#demonstration code below - not being taught - just demonstrating no data values
# Use stack function to read in all bands
RGB_stack <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

# Create an RGB image from the raster stack
par(col.axis="white",col.lab="white",tck=0)
plotRGB(RGB_stack, r = 1, g = 2, b = 3, 
        axes=TRUE, main="Raster With No Data Values\nRendered in Black")


## ----demonstrate-no-data, echo=FALSE-------------------------------------
#reassign cells with 0,0,0 to NA
#this is simply demonstration code - we will not teach this.
f <- function(x) {
  x[rowSums(x == 0) == 3, ] <- NA
  x}

newRGBImage <- calc(RGB_stack, f)


par(col.axis="white",col.lab="white",tck=0)
# Create an RGB image from the raster stack
plotRGB(newRGBImage, r = 1, g = 2, b = 3,
        axes=TRUE, main="Raster With No Data Values\nNodata= NA")
 

## ----view-raster-histogram-----------------------------------------------

#view histogram of data
hist(DSM_HARV,
     main="Digital Surface Model - Range of Values\n NEON Harvard Forest")


## ----view-raster-histogram2----------------------------------------------
#NOTE: force R to plot all pixel values in the histogram COULD be problematic
#when dealing with very large datasets. USE WITH CAUTION!

#View the total number of pixels (cells) in is our raster 
ncell(DSM_HARV)

#create histogram that includes with all pixel values in the raster
hist(DSM_HARV, 
     maxpixels=ncell(DSM_HARV),
     main="Digital Surface Model Histogram\n All Pixel values Included")


## ----view-raster-bands---------------------------------------------------

#view unmber of bands
nlayers(DSM_HARV)


## ----view-attributes-gdal------------------------------------------------

# view attributes before opening file
GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")


## ----challenge-code-attributes, eval=FALSE, echo=FALSE-------------------
## GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif")
## 
## #ANSWERS ###
## # 1. If this file has the same CRS as DSM_HARV?  Yes: UTM Zone 18, WGS84, meters.
## #2. What format NoData values take?  -9999
## #3. The resolution of the raster data? 1x1
## #4. How large a 5x5 pixel area would be? 5mx5m How? We are given resolution of
## #1x1 and units in meters, therefore rolution of 5x5 means 5x5m.
## #5. If the file is a multi- or single-band raster?  Single
## 

