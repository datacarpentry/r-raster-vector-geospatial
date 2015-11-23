## ----load-libraries------------------------------------------------------
#if they are not already loaded
library(rgdal)
library(raster)

#import raster - Used in lesson 00
DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")


## ----hist-raster---------------------------------------------------------

#Plot raster object
plot(DSM_HARV,
     main="NEON Digital Surface Model\nHarvard Forest Field Site")


## ----create-histogram-2-breaks-------------------------------------------
#Plot distribution of raster values 
hist(DSM_HARV,
     breaks=2,
     main="Histogram Digital Surface Model\nHarvard Forest Field Site",
     col="wheat3")


## ----plot-with-breaks----------------------------------------------------

#Create a color palette of 3 colors
myCol = terrain.colors(3)

#plot using breaks.
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="NEON Digital Surface Model\nHarvard Forest Field Site")


## ----add-plot-title------------------------------------------------------
#Add axes and title and subtitle to raster plot
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="NEON Digital Surface Model", 
     xlab = "X Coordinates (m)", 
     ylab = "Y Coordinates (m)")

## ----turn-off-axes-------------------------------------------------------
#or we can turn off the axis altogether
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="NEON Digital Surface Model\nHarvard Forest Field Site", 
     axes=FALSE)


## ----challenge-code-plotting, echo=FALSE---------------------------------




## ----hillshade-----------------------------------------------------------
#import DSM hillshade
hill_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif")

#plot hillshade using a grayscale color ramp that looks like shadows.
plot(hill_HARV,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="NEON Hillshade - DSM\n Harvard Forest",
    axes=FALSE)


## ----overlay-hillshade---------------------------------------------------

#plot hillshade using a grayscale color ramp that looks like shadows.
plot(hill_HARV,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="NEON Hillshade - DSM\n Harvard Forest",
    axes=FALSE)

#add the DSM on top of the hillshade
plot(DSM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)

## ----challenge-plots, echo=FALSE-----------------------------------------
#import DSM 
DSM_SJER <- raster("NEON_RemoteSensing/SJER/DSM/SJER_DSMcrop.tif")
#import DSM hillshade
hill_SJER <- raster("NEON_RemoteSensing/SJER/DSM/SJER_DSMhill.tif")

#plot hillshade using a grayscale color ramp that looks like shadows.
plot(hill_SJER,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="NEON Hillshade - DSM\n SJER Field Site",
    axes=FALSE)

#add the DSM on top of the hillshade
plot(DSM_SJER,
     col=terrain.colors(100),
     alpha=0.4,
     add=T,
     legend=F)

#import DSM 
DTM_SJER <- raster("NEON_RemoteSensing/SJER/DTM/SJER_DTMcrop.tif")
#import DSM hillshade
hillDTM_SJER <- raster("NEON_RemoteSensing/SJER/DTM/SJER_DTMhill.tif")

#plot hillshade using a grayscale color ramp that looks like shadows.
plot(hillDTM_SJER,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="NEON Hillshade - Digital Terrain Model\n SJER Field Site",
    axes=FALSE)

#add the DSM on top of the hillshade
plot(DTM_SJER,
     col=terrain.colors(100),
     alpha=0.4,
     add=T,
     legend=F)


