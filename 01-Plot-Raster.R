## ----pseudo-code---------------------------------------------------------
# Plot raster file and change some parameters
plot(DSM_HARV) #Necessary to explicitly differentiate between base plot and raster plot?
pixels <- ncol(DSM_HARV) * nrow(DSM_HARV)
hist(DSM_HARV, col = "blue", maxpixels = pixels)
myCol <- terrain.colors(10)
plot(DSM_HARV, 
     breaks = c(320, 340, 360, 380, 400), 
     col = myCol,
     maxpixels = pixels) #optional argument

plot(DSM_HARV, 
     zlim = c(340, 400)) #optional argument
#`image` v. `plot`
# TODO: challenge


## ----hist-raster---------------------------------------------------------
#Plot entire raster
plot(DSM_HARV)

#Plot distribution of raster values 
hist(DSM_HARV)
# Warning? Hist by default only plots subset
pixels = ncol(DSM_HARV) * nrow(DSM_HARV)
hist(DSM_HARV, maxpixels = pixels)

## ----breaks-zlim---------------------------------------------------------
#Plot a subset of the pixel values, e.g., the bottom 50m of surface
plot(DSM_HARV, zlim = c(305, 355))

#Plot all pixel values using broader categories for values
myCol = terrain.colors(4)

plot(DSM_HARV, 
     breaks = c(305, 341, 377, 416), 
     col = myCol, 
     maxpixels = pixels)

## ----add-plot-title------------------------------------------------------
#Add axes and title to raster plot
plot(DSM_HARV, 
     xlab = "X Coordinates", 
     ylab = "Y Coordinates", 
     main = "Harvard Forest Digital Surface Model")


## ----challenge-code-plotting, echo=FALSE---------------------------------


## ----hillshade-----------------------------------------------------------
#import DSM hillshade
hill_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif")

#	Plot hillshade using a grayscale color ramp that looks like shadows.
plot(hill_HARV,
    col=grey(1:100/100),  #
    legend=F,
    main="NEON Hillshade - DSM\n Harvard Forest")

## ----overlay-hillshade---------------------------------------------------

#overlay the DSM on top of the hillshade
plot(DSM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)

