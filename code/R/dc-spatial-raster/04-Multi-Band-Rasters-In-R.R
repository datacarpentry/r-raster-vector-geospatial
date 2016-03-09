## ----demonstrate-RGB-Image, echo=FALSE-----------------------------------
# Use stack function to read in all bands
RGB_stack_HARV <- 
  stack("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

names(RGB_stack_HARV) <- c("Red Band","Green Band","Blue Band")

grayscale_colors <- gray.colors(100, 
                                start = 0.0, 
                                end = 1.0, 
                                gamma = 2.2, 
                                alpha = NULL)

# Create an RGB image from the raster stack
plot(RGB_stack_HARV, 
     col=grayscale_colors,
     axes=F)


## ----plot-RGB-now, echo=FALSE, message=FALSE-----------------------------
# Create an RGB image from the raster stack

original_par <-par() # create original par for easy reversal at end
par(col.axis="white",col.lab="white",tck=0)
plotRGB(RGB_stack_HARV, r = 1, g = 2, b = 3,
        axes=TRUE, 
        main="3 Band Color Composite Image\n NEON Harvard Forest Field Site")
box(col="white")


## ----reset-par, echo=FALSE, results="hide", warning=FALSE----------------
par(original_par) # go back to original par


## ----load-libraries------------------------------------------------------

# work with raster data
library(raster)
# export GeoTIFFs and other core GIS functions
library(rgdal)


## ----read-single-band----------------------------------------------------
 
# Read in multi-band raster with raster function. 
# Default is the first band only.
RGB_band1_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# create a grayscale color palette to use for the image.
grayscale_colors <- gray.colors(100,            # number of different color levels 
                                start = 0.0,    # how black (0) to go
                                end = 1.0,      # how white (1) to go
                                gamma = 2.2,    # correction between how a digital 
                                # camera sees the world and how human eyes see it
                                alpha = NULL)   #Null=colors are not transparent

# Plot band 1
plot(RGB_band1_HARV, 
     col=grayscale_colors, 
     axes=FALSE,
     main="RGB Imagery - Band 1-Red\nNEON Harvard Forest Field Site") 

# view attributes: Check out dimension, CRS, resolution, values attributes, and 
# band.
RGB_band1_HARV

## ----min-max-image-------------------------------------------------------
# view min value
minValue(RGB_band1_HARV)

# view max value
maxValue(RGB_band1_HARV)

## ----read-specific-band--------------------------------------------------
# Can specify which band we want to read in
RGB_band2_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", 
           band = 2)

# plot band 2
plot(RGB_band2_HARV,
     col=grayscale_colors, # we already created this palette & can use it again
     axes=FALSE,
     main="RGB Imagery - Band 2- Green\nNEON Harvard Forest Field Site")

# view attributes of band 2 
RGB_band2_HARV


## ----challenge1-answer, eval=FALSE, echo=FALSE---------------------------
## 
## # We'd expect a *brighter* value for the forest in band 2 (green) than in
## # band 1 (red) because the leaves on trees of most often appear "green" -
## # healthy leaves reflect MORE green light compared to red light
## 

## ----intro-to-raster-stacks----------------------------------------------

# Use stack function to read in all bands
RGB_stack_HARV <- 
  stack("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# view attributes of stack object
RGB_stack_HARV


## ----plot-raster-layers--------------------------------------------------
# view raster attributes
RGB_stack_HARV@layers

# view attributes for one band
RGB_stack_HARV[[1]]

# view histogram of all 3 bands
hist(RGB_stack_HARV,
     maxpixels=ncell(RGB_stack_HARV))

# plot all three bands separately
plot(RGB_stack_HARV, 
     col=grayscale_colors)

# revert to a single plot layout 
par(mfrow=c(1,1)) 

# plot band 2 
plot(RGB_stack_HARV[[2]], 
     main="Band 2\n NEON Harvard Forest Field Site",
     col=grayscale_colors)


## ----plot-rgb-image------------------------------------------------------

# Create an RGB image from the raster stack
plotRGB(RGB_stack_HARV, 
        r = 1, g = 2, b = 3)


## ----image-stretch-------------------------------------------------------

# what does stretch do?
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "lin")

plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "hist")


## ----challenge-code-NoData, echo=FALSE, results="hide"-------------------
# 1.
# view attributes
GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

# 2 Yes it has NoData values as they are assigned as -9999 
# 3 3 bands

# 4
# reading in file
HARV_NA<- 
  stack("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

# 5
plotRGB(HARV_NA, 
        r = 1, g = 2, b = 3)

#6 The black edges are not plotted. 
#7 Both have NoData values, however, in RGB_stack the NoData value is not
# defined in the tiff tags, thus R renders them as black as the reflectance
# values are 0. The black edges in the other file are defined as -9999 and R
# renders them as NA.
GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")


## ----raster-bricks-------------------------------------------------------

# view size of the RGB_stack object that contains our 3 band image
object.size(RGB_stack_HARV)

# convert stack to a brick
RGB_brick_HARV <- brick(RGB_stack_HARV)

# view size of the brick
object.size(RGB_brick_HARV)


## ----plot-brick----------------------------------------------------------
# plot brick
plotRGB(RGB_brick_HARV)


## ----challenge-code-calling-methods, include=TRUE, results="hide", echo=FALSE----
# 1
# methods for calling a stack
methods(class=class(RGB_stack_HARV))
# 143 methods!

# 2
# methods for calling a band (1) with a stack
methods(class=class(RGB_stack_HARV[1]))

#3 There are far more thing one could or wants to ask of a full stack than of 
# a single band.  

