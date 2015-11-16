## ----demonstrate-RGB-Image, echo=FALSE-----------------------------------
# Use stack function to read in all bands
RGB_stack_HARV <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

names(RGB_stack_HARV) <- c("Red Band","Green Band","Blue Band")

grayscale_colors <- gray.colors(100, 
                                start = 0.0, 
                                end = 1.0, 
                                gamma = 2.2, 
                                alpha = NULL)

# Create an RGB image from the raster stack
plot(RGB_stack_HARV, col=grayscale_colors)


## ----plot-RGB-now, echo=FALSE, message=FALSE-----------------------------
# Create an RGB image from the raster stack

original_par <-par() #original par
par(col.axis="white",col.lab="white",tck=0)
plotRGB(RGB_stack_HARV, r = 1, g = 2, b = 3,
        axes=TRUE, 
        main="3 Band Color Composite Image")
box(col="white")
par(original_par) # go back to original par


## ----read-single-band----------------------------------------------------
 
# Read in multi-band raster with raster function. 
#Default is the first band only.
RGB_band1_HARV <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

#create a grayscale color palette to use for the image.
grayscale_colors <- gray.colors(100,            #how many different color levels 
                                start = 0.0,    #how black (0) to go
                                end = 1.0,      #how white (1) to go
                                gamma = 2.2,    #correction between how a digital
                                #camera sees the world and how human eyes see it
                                alpha = NULL)   #Null=colors are not transparent

#Plot band 1
plot(RGB_band1_HARV, 
     col=grayscale_colors, 
     main="NEON RGB Imagery - Band 1\nHarvard Forest") 

#view attributes: Check out dimension, CRS, resolution, values attributes, and 
#band.
RGB_band1_HARV

## ----min-max-image-------------------------------------------------------
#view min value
minValue(RGB_band1_HARV)

#view max value
maxValue(RGB_band1_HARV)

## ----read-specific-band--------------------------------------------------
# Can specify which band you want to read in
RGB_band2_HARV <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif", 
                    band = 2)

#plot band 2
plot(RGB_band2_HARV,
     col=grayscale_colors,   #we already created this palatte & can use it again
     main="NEON RGB Imagery - Band 2\nHarvard Forest")

#view attributes of band 2 
RGB_band2_HARV


## ----intro-to-raster-stacks----------------------------------------------

# Use stack function to read in all bands
RGB_stack_HARV <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")

#view attributes of stack object
RGB_stack_HARV


## ----plot-raster-layers--------------------------------------------------

#view raster attributes
RGB_stack_HARV@layers

#view attributes for one band
RGB_stack_HARV[[1]]

#view histogram of all 3 bands
hist(RGB_stack_HARV)

#plot one band
plot(RGB_stack_HARV[[1]], 
     main="RGB_stack Band 1", 
     col=grayscale_colors)

#plot all three bands separately
plot(RGB_stack_HARV, 
     col=grayscale_colors)

par(mfrow=c(1,1)) # go back 1 plot at time, not 2x2.

## ----plot-rgb-image------------------------------------------------------

# Create an RGB image from the raster stack
plotRGB(RGB_stack_HARV, 
        r = 1, g = 2, b = 3)

#what does stretch do?
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "lin")

## ----challenge-code-NoData, echo=FALSE-----------------------------------
#1.
#view attributes
GDALinfo("NEON_RemoteSensing/HARV/HARV_Ortho_wNA.tif")

#2 Yes it has NoData values as they are assigned as -9999 
#3 3 bands

#4
#reading in file
HARV_NA<- stack("NEON_RemoteSensing/HARV/HARV_Ortho_wNA.tif")

#5
plotRGB(HARV_NA, 
        r = 1, g = 2, b = 3)

#6 The black edges are not plotted. 
#7 Both have NoData values, however, in RGB_stack they are a number that R #doesn't recognize as a NoData value and therefore doesn't conver it to NA. 
GDALinfo("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")


## ----raster-bricks-------------------------------------------------------

#view size of the RGB_stack object that contains our 3 band image
object.size(RGB_stack_HARV)

#convert stack to a brick
RGB_brick_HARV <- brick(RGB_stack_HARV)

#view size of the brick
object.size(RGB_brick_HARV)

## ----plot-brick----------------------------------------------------------
#plot brick
plotRGB(RGB_brick_HARV)


## ----challenge-code-calling-methods, echo=FALSE--------------------------
#1
#methods for calling a stack
methods(class=class(RGB_stack_HARV))
# 143 methods!

#2
#methods for calling a band (1) with a stack
methods(class=class(RGB_stack_HARV[1]))

#3 There are far more thing one could or wants to ask of a full stack than of 
#a single band.  

