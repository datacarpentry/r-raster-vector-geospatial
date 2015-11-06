## ----pseudo-code---------------------------------------------------------
# Plot raster file and change some parameters
plot(DSM) #Necessary to explicitly differentiate between base plot and raster plot?
pixels <- ncol(DSM) * nrow(DSM)
hist(DSM, col = "blue", maxpixels = pixels)
myCol <- terrain.colors(10)
plot(DSM, breaks = c(320, 340, 360, 380, 400), col = myCol, maxpixels = pixels) #optional argument
plot(DSM, zlim = c(340, 400)) #optional argument
#`image` v. `plot`
# TODO: challenge


