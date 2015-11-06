## ----elevation-map, echo=FALSE-------------------------------------------
library(raster)
library(rgdal)
DSM <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# code output here - DEM rendered on the screen
# dem hillshade
plot(DSM, main="NEON Elevation Map\nHarvard Forest")


## ----classified-elevation-map, echo=FALSE--------------------------------
# Just a demonstration image for the lesson

#add a color map with 5 colors
col=terrain.colors(3)
#add breaks to the colormap (6 breaks = 5 segments)
brk <- c(250,350, 380,500)

# Expand right side of clipping rect to make room for the legend
par(xpd = FALSE,mar=c(5.1, 4.1, 4.1, 4.5))
#DEM with a custom legend
plot(DSM, col=col, breaks=brk, main="Classified Elevation Map\nHarvard Forest",legend = FALSE)
#turn xpd back on to force the legend to fit next to the plot.
par(xpd = TRUE)
#add a legend - but make it appear outside of the plot
legend( par()$usr[2], 4713700,
        legend = c("High Elevation", "Middle","Low Elevation"), 
        fill = rev(col))

## ----load-libraries------------------------------------------------------
library(raster)
library(rgdal)


## ----view-attributes-gdal------------------------------------------------
# view attributes before opening file
GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")


## ----open-raster---------------------------------------------------------
# Load raster into r
DSM <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# Look at raster structure
DSM 

#quickly plot the raster
#note \n firces a line break in the title!
plot(DSM, main="NEON Digital Surface Model\nHarvard Forest")


## ----view-resolution-units-----------------------------------------------
#view resolution units
crs(DSM)


## ----set-min-max---------------------------------------------------------

#This step is unnecessary if the min max values are already calculated and 
#stored in the tags for the raster.
#our raster already has these values calculated!
#DSM <- setMinMax(DSM) 

#view min value
minValue(DSM)

#view max value
maxValue(DSM)


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
  x
}

newRGBImage <- calc(RGB_stack, f)

# Create an RGB image from the raster stack
plotRGB(newRGBImage, r = 1, g = 2, b = 3,
        addfun="(main='Test')" )
 

## ----no-data-values------------------------------------------------------

#view raster no data value using GDAL info.
#for our raster, all cells with a value of -9999 will assigned by R to NA
#when we import the data
GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")


## ----view-raster-histogram-----------------------------------------------

#view histogram of data
hist(DSM)

#oops - the histogram has a default number of pixels that it renders
#grab the number of pixels in the raster
ncell(DSM)

#create histogram with all pixel values in the raster
hist(DSM, maxpixels=ncell(DSM))


