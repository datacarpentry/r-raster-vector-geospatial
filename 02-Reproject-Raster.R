## ----load-libraries------------------------------------------------------

#load raster package
library(raster)

## ----import-DTM-hillshade------------------------------------------------
#import DTM
DTM_HARV <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmcrop.tif")
#import DTM hillshade
DTM_hill_HARV <- raster("NEON_RemoteSensing/HARV/DTM/HARV_DTMhill_WGS84.tif")

#	Plot hillshade using a grayscale color ramp 
plot(DTM_hill_HARV,
    col=grey(1:100/100),
    legend=F,
    main="NEON Hillshade - DTM\n Harvard Forest")

#overlay the DSM on top of the hillshade
plot(DTM_HARV,
     col=terrain.colors(10),
     alpha=0.4,
     add=T,
     legend=F)

## ----explore-crs---------------------------------------------------------
#view crs for DTM
crs(DTM_HARV)

#view crs for hillshade
crs(DTM_hill_HARV)

## ----reproject-raster----------------------------------------------------
#reproject to UTM
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, crs=crs(DTM_HARV))

#compare attributes of DTM_hill_UTMZ18N to DTM_hill
DTM_hill_UTMZ18N_HARV
DTM_hill_HARV

## ----reproject-assign-resolution-----------------------------------------
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                  crs=crs(DTM_HARV),
                                  res=1)

DTM_hill_UTMZ18N_HARV

## ----plot-projected-raster-----------------------------------------------

#plot newly reprojected hillshade
plot(DTM_hill_UTMZ18N_HARV,
    col=grey(1:100/100),
    legend=F,
    main="NEON Hillshade - DTM\n Harvard Forest")

#overlay the DTM on top of the hillshade
plot(DTM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)

