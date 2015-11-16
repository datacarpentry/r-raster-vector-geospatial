## ----load-libraries------------------------------------------------------
#load raster package
library(raster)

#view info about the dtm & dsm raster data
GDALinfo("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
GDALinfo("NEON_RemoteSensing/HARV/DTM/HARV_dsmCrop.tif")
#load the DTM & DSM rasters
DTM_HARV <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")
#create a quick plot of each to see what we're dealing with
plot(DTM_HARV,
     main="Digital Terrain Model (Elevation)\n Harvard Forest")

plot(DSM_HARV,
     main="Digital Surface Model (Elevation)\n Harvard Forest")

## ----raster-math---------------------------------------------------------
# Raster math example
CHM_HARV <- DSM_HARV - DTM_HARV 

#view the output CHM
plot(CHM_HARV,
     main="NEON Canopy Height Model - Subtracted\n Harvard Forest") 

## ----challenge-code-CHM-HARV, echo=FALSE---------------------------------
#1) Depends on types of trees.  0m to <50m?
#2) Looks at histogram or min/max values. 
minValue(CHM_HARV)
maxValue(CHM_HARV)
#3) 
hist(CHMv, maxpixels=ncell(CHM_HARV))

#4)
hist(CHM_HARV, 
     col = "purple",
     main = "Histogram of NEON Canopy Height Model\n Harvard Forest",
     maxpixels=ncell(CHM))


## ----raster-overlay------------------------------------------------------
CHM_ov_HARV<- overlay(DSM_HARV,DTM_HARV,fun=function(r1, r2){return(r1-r2)})

plot(CHM_ov_HARV,
     main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")

## ----write-raster--------------------------------------------------------
#export CHM object to new GeotIFF
writeRaster(CHM_ov_HARV,"chm_ov_HARV.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

## ----challenge-code-SJER-CHM, echo=FALSE---------------------------------
#1.
#load the DTM
DTM_SJER <- raster("NEON_RemoteSensing/SJER/DTM/SJER_dtmCrop.tif")
#load the DSM
DSM_SJER <- raster("NEON_RemoteSensing/SJER/DSM/SJER_dsmCrop.tif")

#check CRS, units, etc
DTM_SJER@data
DSM_SJER@data

#check values
hist(DTM_SJER, maxpixels=ncell(DTM_SJER))
hist(DSM_SJER, maxpixels=ncell(DSM_SJER))

#2.
#use overlay to subtract the two rasters
CHM_ov_SJER <- overlay(DSM_SJER,DTM_SJER,fun=subtRasters)

hist(CHM_ov_SJER, 
     main="NEON Canopy Height Model - Histogram\n SJER")

#3
#plot the output
plot(CHM_ov_SJER,
     main="NEON Canopy Height Model - Overlay Subtract\n SJER")

#4 
#Write to object to file
writeRaster(CHM_ov_SJER,"chm_ov_SJER.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

#4.  Tree heights are WAY shorter in SJER. 
#view histogram of HARV again. 
par(mfcol=c(2,1))
hist(CHM_ov_HARV, 
     main="NEON Canopy Height Model - Histogram\n HARV")
hist(CHM_ov_SJER, 
     main="NEON Canopy Height Model - Histogram\n SJER")

