## ----load-libraries------------------------------------------------------
# if they are not already loaded
library(rgdal)
library(raster)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")

# import raster
DSM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")


## ----hist-raster---------------------------------------------------------
# Plot raster object
plot(DSM_HARV,
     main="Digital Surface Model\nNEON Harvard Forest Field Site")


## ----create-histogram-breaks---------------------------------------------
# Plot distribution of raster values 
DSMhist<-hist(DSM_HARV,
     breaks=3,
     main="Histogram Digital Surface Model\n NEON Harvard Forest Field Site",
     col="wheat3",  # changes bin color
     xlab= "Elevation (m)")  # label the x-axis

# Where are breaks and how many pixels in each category?
DSMhist$breaks
DSMhist$counts


## ----plot-with-breaks----------------------------------------------------
# plot using breaks.
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = terrain.colors(3),
     main="Digital Surface Model (DSM)\n NEON Harvard Forest Field Site")


## ----add-plot-title------------------------------------------------------
# Assign color to a object for repeat use/ ease of changing
myCol = terrain.colors(3)

# Add axis labels
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="Digital Surface Model\nNEON Harvard Forest Field Site", 
     xlab = "UTM Westing Coordinate (m)", 
     ylab = "UTM Northing Coordinate (m)")

## ----turn-off-axes-------------------------------------------------------
# or we can turn off the axis altogether
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="Digital Surface Model\n NEON Harvard Forest Field Site", 
     axes=FALSE)


## ----challenge-code-plotting, include=TRUE, results="hide", echo=FALSE----
# Find min & max
DSM_HARV@data

# Pixel range & even category width
(416.07-305.07)/6

# Break every 18.5m starting at 305.07

# Plot with 6 categories at even intervals across the pixel value range. 
plot(DSM_HARV, 
     #breaks = c(305, 323.5, 342, 360.5, 379, 397.5, 417),  #manual entry
     breaks = seq(305, 417, by=18.5),  #define start & end, and interval
     col = terrain.colors (6),
      main="Digital Surface Model\nNEON Harvard Forest Field Site", 
     xlab = "UTM Westing Coordinate", 
     ylab = "UTM Northing Coordinate")


## ----hillshade-----------------------------------------------------------
# import DSM hillshade
DSM_hill_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DSM_hill_HARV,
    col=grey(1:100/100),  # create a color ramp of grey colors
    legend=FALSE,
    main="Hillshade - DSM\n NEON Harvard Forest Field Site",
    axes=FALSE)


## ----overlay-hillshade---------------------------------------------------

# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DSM_hill_HARV,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="DSM with Hillshade \n NEON Harvard Forest Field Site",
    axes=FALSE)

# add the DSM on top of the hillshade
plot(DSM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)

## ----challenge-hillshade-layering, echo=FALSE----------------------------
# CREATE DSM MAPS
# import DSM 
DSM_SJER <- raster("NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMcrop.tif")
# import DSM hillshade
DSM_hill_SJER <- 
  raster("NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill.tif")

# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DSM_hill_SJER,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="DSM with Hillshade\n NEON SJER Field Site",
    axes=FALSE)

# add the DSM on top of the hillshade
plot(DSM_SJER,
     col=terrain.colors(100),
     alpha=0.7,
     add=T,
     legend=F)

# CREATE SJER DTM MAP
# import DTM 
DTM_SJER <- raster("NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_DTMcrop.tif")
# import DTM hillshade
DTM_hill_SJER <- 
  raster("NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_DTMhill.tif")

# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DTM_hill_SJER,
    col=grey(1:100/100),  #create a color ramp of grey colors
    legend=F,
    main="DTM with Hillshade\n NEON SJER Field Site",
    axes=FALSE)

# add the DSM on top of the hillshade
plot(DTM_SJER,
     col=terrain.colors(100),
     alpha=0.4,
     add=T,
     legend=F)


