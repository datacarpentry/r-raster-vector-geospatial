## ----demonstrate-RGB-Image, echo=FALSE-----------------------------------

# Use stack function to read in all bands
RGB_stack <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

names(RGB_stack) <- c("Red Band","Green Band","Blue Band")

grayscale_colors <- gray.colors(100, 
                                start = 0.0, 
                                end = 1.0, 
                                gamma = 2.2, 
                                alpha = NULL)

# Create an RGB image from the raster stack
plot(RGB_stack, col=grayscale_colors)


## ----plot-RGB-now, echo=FALSE--------------------------------------------
# Create an RGB image from the raster stack
plotRGB(RGB_stack, r = 1, g = 2, b = 3,
        addfun="(main='Test')" )
 

## ----read-single-band----------------------------------------------------
 
# Read in multi-band raster with raster function, the default is the first band
RGB_band1 <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

#create a grayscale color palette to use for the image
grayscale_colors <- gray.colors(100, 
                                start = 0.0, 
                                end = 1.0, 
                                gamma = 2.2, 
                                alpha = NULL)

#Point out dimension, CRS, and values attributes, but esp. band
plot(RGB_band1, 
     col=grayscale_colors, 
     main="NEON RGB Imagery - Band 1\nHarvard Forest") 

#view attributes
RGB_band1



## ----min-max-image-------------------------------------------------------

#view min value
minValue(RGB_band1)

#view max value
maxValue(RGB_band1)




## ----plot-single-band----------------------------------------------------

# Can specify which band you want to read in
RGB_band2 <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif", 
                    band = 2)

#plot band 2
plot(RGB_band2,
     col=grayscale_colors, 
     main="NEON RGB Imagery - Band 2\nHarvard Forest")

#view attributes of band 2 
RGB_band2


## ----intro-to-raster-stacks----------------------------------------------

# Use stack function to read in all bands
RGB_stack <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

#view attributes of stack object
RGB_stack 

#What is the CRS of the raster stack
crs(RGB_stack)


## ----plot-raster-layers--------------------------------------------------

#view raster attributes
RGB_stack@layers

#view attributes for one layer
RGB_stack[[1]]

#plot one band
plot(RGB_stack[[1]], main="band one", col=grayscale_colors)

#Metadata file? 
#plot all three bands
plot(RGB_stack, col=grayscale_colors)


## ----plot-rgb-image------------------------------------------------------

# Create an RGB image from the raster stack
plotRGB(RGB_stack, r = 1, g = 2, b = 3)

#what does stretch do?
plotRGB(RGB_stack,r = 1, g = 2, b = 3, scale=800,stretch = "Lin")

#The black bands on the edges are zeros but should be NAs, might want to show 
#them how to turn them into NAs? 

# TODO: Challenge: calculate NDVI, but would need an infrared band to do this
#-- on it!

