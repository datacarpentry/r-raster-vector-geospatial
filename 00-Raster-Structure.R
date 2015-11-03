## ----elevation-map, echo=FALSE-------------------------------------------
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
        legend = c("Highest", "Middle","Lowest"), 
        fill = rev(col))

## ----load-libraris-------------------------------------------------------
library(raster)
library(rgdal)


## ----open-raster---------------------------------------------------------
# Load raster into r
DSM <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# Look at raster structure
DSM 

#quickly plot the raster
plot(DSM, main="NEON Digital Surface Model\nHarvard Forest")


## ----view-resolution-units-----------------------------------------------
#view resolution units
DSM@data@unit


## ----view-raster-CRS-----------------------------------------------------

#view raster crs - in Proj 4 format
crs(DSM)


## ------------------------------------------------------------------------
DSM <- setMinMax(DSM) #This step might be unnecessary

#view min value
DSM@data@min

#view max value
DSM@data@max


## ----no-data-values------------------------------------------------------
#view raster no data value
NAvalue(DSM)


## ----view-raster-histogram-----------------------------------------------

#view raster no data value
hist(DSM)


