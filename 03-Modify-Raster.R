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

#plot the output CHM
plot(CHM_HARV,
     main="NEON Canopy Height Model - Subtracted\n Harvard Forest") 


## ----create-hist---------------------------------------------------------
hist(CHM_HARV,
     col="springgreen4",
     main="Histogram of NEON Canopy Height Model\nHarvard Forest",
     ylab="Tree Height (m)",
     xlab="Number of Pixels")


## ----challenge-code-CHM-HARV, echo=FALSE---------------------------------
#1) Depends on types of trees.  0m to <50m?
#2) Looks at histogram or min/max values. 
minValue(CHM_HARV)
maxValue(CHM_HARV)
#3) 
hist(CHM_HARV, 
     maxpixels=ncell(CHM_HARV),
     col="springgreen4")

#4)
hist(CHM_HARV, 
     col = "springgreen4",
     main = "Histogram of NEON Canopy Height Model\n Harvard Forest",
     maxpixels=ncell(CHM),
     breaks=6)




## ----challenge-plot, echo=FALSE------------------------------------------

#5)
myCol=terrain.colors(4)
plot(CHM_HARV,
     breaks=c(0,10,20,30),
     col=myCol,
     axes=F,
     main="NEONCanopy Height Model w Breaks\nHarvard Forest")


## ----raster-overlay------------------------------------------------------
CHM_ov_HARV<- overlay(DSM_HARV,
                      DTM_HARV,
                      fun=function(r1, r2){return(r1-r2)})

plot(CHM_ov_HARV,
     main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")

## ----write-raster--------------------------------------------------------
#export CHM object to new GeotIFF
writeRaster(CHM_ov_HARV,"chm_HARV.tiff",
            format="GTiff",  #specify output format - geotiff
            overwrite=TRUE, #CAUTION if this is true, it will overwrite an existing file
            NAflag=-9999) #set no data value to -9999


## ----challenge-code-SJER-CHM, echo=FALSE---------------------------------
#1.
#load the DTM
DTM_SJER <- raster("NEON_RemoteSensing/SJER/DTM/SJER_dtmCrop.tif")
#load the DSM
DSM_SJER <- raster("NEON_RemoteSensing/SJER/DSM/SJER_dsmCrop.tif")

#check CRS, units, etc
DTM_SJER
DSM_SJER

#check values
hist(DTM_SJER, 
     maxpixels=ncell(DTM_SJER),
     main="NEON Digital Terrain Model - Histogram\n SJER",
     col="slategrey",
     ylab="Number of Pixels",
     xlab="Elevation (m)")
hist(DSM_SJER, 
     maxpixels=ncell(DSM_SJER),
     main="NEON Digital Surface Model - Histogram\n SJER",
     col="slategray2",
     ylab="Number of Pixels",
     xlab="Elevation (m)")

#2.
#use overlay to subtract the two rasters
CHM_SJER <- overlay(DSM_SJER,DTM_SJER,
                    fun=function(r1, r2){return(r1-r2)})

hist(CHM_SJER, 
     main="NEON Canopy Height Model - Histogram\n SJER",
     col="springgreen4",
     ylab="Number of Pixels",
     xlab="Elevation (m)")

#3
#plot the output
plot(CHM_SJER,
     main="NEON Canopy Height Model - Overlay Subtract\n SJER",
     axes=F)

#4 
#Write to object to file
writeRaster(CHM_SJER,"chm_ov_SJER.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

#4.  Tree heights are WAY shorter in SJER. 
#view histogram of HARV again. 
par(mfcol=c(2,1))
hist(CHM_HARV, 
     main="NEON Canopy Height Model - Histogram\n Harvard Forest",
     col="springgreen4",
      ylab="Number of Pixels",
     xlab="Elevation (m)")

hist(CHM_SJER, 
     main="NEON Canopy Height Model - Histogram\n San Joachin Experimental Range",
     col="slategrey", ylab="Number of Pixels",
     xlab="Elevation (m)")



