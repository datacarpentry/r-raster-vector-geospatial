## ----load-libraries------------------------------------------------------

#load raster package
library(raster)

# CHALLENGE: repeat objectives 1 & 2 for a different .tif file


#load the DTM
DTM <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")

#create a quick plot
plot(DTM,
     main="Digital Terrain Model (Elevation)\n Harvard Forest")

#If it isn't already loaded, load the DSM as well 
DSM <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")


## ----raster-math---------------------------------------------------------
# Raster math example

CHM <- DSM - DTM #This section could be automatable later on

#view the output CHM
plot(CHM,
     main="NEON Canopy Height Model - Subtracted\n Harvard Forest") 

#Ask participants what they think this might look like ahead of time
hist(CHM, col = "purple")

## ----raster-overlay------------------------------------------------------

#first, let's create a function
#this function will take two rasters (r1 and r2) and subtract them
subtRasters <- function(r1, r2){
return(r1-r2)
}

CHM_ov <- overlay(DSM,DTM,fun=subtRasters)

plot(CHM_ov,
     main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")


## ----write-raster--------------------------------------------------------

#export CHM object to new geotiff
writeRaster(CHM_ov,"chm_ov.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

#note we are setting the NA value to -9999 for consistency.

## ------------------------------------------------------------------------
# Crop raster, first method
plot(CHM)
cropbox <- drawExtent()
manual_crop <- crop(CHM, cropbox)
plot(manual_crop)

# Crop raster, second method
coords <- c(xmin(CHM) + ncol(CHM) * 0.1, xmax(CHM) - ncol(CHM) * 0.1, 
            ymin(CHM), ymax(CHM))
coord_crop = crop(CHM, coords)
plot(coord_crop) #Compare with CHM raster, should have different x-axis ranges

# Challenge: play with resolution (i.e., pixel numbers)

# TODO: reprojection of a single-band raster, ask others? 
# TODO: summarizing multiple pixels into one value
# TODO: do raster math on single raster

