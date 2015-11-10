## ----load-libraries------------------------------------------------------

#load raster package
library(raster)

#view info about the dtm raster data
GDALinfo("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")

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

## ----view-histogram------------------------------------------------------

#Create histogram of CHM values
hist(CHM, 
     col = "purple",
     main = "Histogram of NEON Canopy Height Model\n Harvard Forest")


## ----create-function-----------------------------------------------------

#first, let's create a function
#this function will take two rasters (r1 and r2) and subtract them
subtRasters <- function(r1, r2){
return(r1-r2)
}


## ----raster-overlay------------------------------------------------------


CHM_ov_HARV <- overlay(DSM,DTM,fun=subtRasters)

plot(CHM_ov_HARV,
     main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")


## ----write-raster--------------------------------------------------------

#export CHM object to new geotiff
writeRaster(CHM_ov_HARV,"chm_ov_HARV.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

#note we are setting the NA value to -9999 for consistency.

## ----SJER-CHM, echo=FALSE------------------------------------------------

##load the DTM
DTM_SJER <- raster("NEON_RemoteSensing/SJER/DTM/SJER_dtmCrop.tif")
#load the DSM
DSM_SJER <- raster("NEON_RemoteSensing/SJER/DSM/SJER_dsmCrop.tif")

#use overlay to subtract the two rasters
CHM_ov_SJER <- overlay(DSM_SJER,DTM_SJER,fun=subtRasters)

#plot the output
plot(CHM_ov_SJER,
     main="NEON Canopy Height Model - Overlay Subtract\n SJER")


## ----histogram-compare, echo=FALSE---------------------------------------


#view histogram
hist(CHM_ov_SJER, 
     main="NEON Canopy Height Model - Histogram\n SJER")

#view histogram
hist(CHM_ov_HARV, 
     main="NEON Canopy Height Model - Histogram\n HARV")


## ----notes-chunk---------------------------------------------------------

 #Compare with CHM raster, should have different x-axis ranges

# Challenge: play with resolution (i.e., pixel numbers)

# TODO: reprojection of a single-band raster, ask others? 
# TODO: summarizing multiple pixels into one value
# TODO: do raster math on single raster

