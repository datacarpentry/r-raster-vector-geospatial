## ----elevation-map, echo=FALSE-------------------------------------------
library(raster)
library(rgdal)
DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# code output here - DEM rendered on the screen
# dem hillshade
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
library(raster)
library(rgdal)


## ----open-raster---------------------------------------------------------
# setwd()     #Make sure to set the directory to your data
# Load raster into R
DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# Look at raster structure
DSM_HARV 

#quickly plot the raster
#note \n firces a line break in the title!
plot(DSM_HAV, main="NEON Digital Surface Model\nHarvard Forest")


## ----view-resolution-units-----------------------------------------------
#view resolution units
crs(DSM_HARV)


## ----set-min-max---------------------------------------------------------
#Our raster already has these values calculated. Slot "min" and Slot "max":
DSM_HARV@data

#This is the code if min/max weren't calculated: 
#DSM_HARV <- setMinMax(DSM_HARV) 

#view only min value
minValue(DSM_HARV)

#view only max value
maxValue(DSM_HARV)


## ----demonstrate-no-data-blaco, echo=FALSE-------------------------------
# Use stack function to read in all bands
RGB_stack <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

# Create an RGB image from the raster stack
plotRGB(RGB_stack, r = 1, g = 2, b = 3,
        addfun="(main='Test')" )

## ----demonstrate-no-data, echo=FALSE-------------------------------------
#reassign cells with 0,0,0 to NA

f <- function(x) {
  x[rowSums(x == 0) == 3, ] <- NA
  x}

newRGBImage <- calc(RGB_stack, f)

# Create an RGB image from the raster stack
plotRGB(newRGBImage, r = 1, g = 2, b = 3,
        addfun="(main='Test')" )
 

## ----view-raster-histogram-----------------------------------------------

#view histogram of data
hist(DSM_HARV)


## ----view-raster-histogram2----------------------------------------------
#how large is our raster.  ncell() give number of cells/ pixels
ncell(DSM_HARV)

#create histogram with all pixel values in the raster
hist(DSM_HARV, maxpixels=ncell(DSM_HARV))

## ----view-attributes-gdal------------------------------------------------
# view attributes before opening file
GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")


## ----challenge-code-attributes, echo=FALSE-------------------------------
GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif")

