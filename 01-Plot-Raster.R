## ----pseudo-code---------------------------------------------------------
# Plot raster file and change some parameters
plot(DSM) #Necessary to explicitly differentiate between base plot and raster plot?
pixels <- ncol(DSM) * nrow(DSM)
hist(DSM, col = "blue", maxpixels = pixels)
myCol <- terrain.colors(10)
plot(DSM, 
     breaks = c(320, 340, 360, 380, 400), 
     col = myCol,
     maxpixels = pixels) #optional argument

plot(DSM, 
     zlim = c(340, 400)) #optional argument
#`image` v. `plot`
# TODO: challenge


## ----hist-raster---------------------------------------------------------
#Plot entire raster
plot(DSM)

#Plot distribution of raster values, get an error cause only plots subset
hist(DSM)
pixels = ncol(DSM) * nrow(DSM)
hist(DSM, maxpixels = pixels)

## ----breaks-zlim---------------------------------------------------------
#Plot a subset of the pixel values, e.g., the bottom 50m of surface
plot(DSM, zlim = c(305, 355))

#Plot all pixel values using broader categories for values
myCol = terrain.colors(4)

plot(DSM, 
     breaks = c(305, 341, 377, 416), 
     col = myCol, 
     maxpixels = pixels)

## ----add-plot-title------------------------------------------------------
#Add axes and title to raster plot
plot(DSM, 
     xlab = "X Coordinates", 
     ylab = "Y Coordinates", 
     main = "Harvard Forest Digital Surface Model")


## ----overlaying-hillshade------------------------------------------------
#import DSM hillshade
hill <- raster("NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif")

#	Plot hillshade using a grayscale color ramp 
plot(hill,
    col=grey(1:100/100),
    legend=F,
    main="NEON Hillshade - DSM\n Harvard Forest")


#overlay the DSM on top of the hillshade
plot(DSM,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)

