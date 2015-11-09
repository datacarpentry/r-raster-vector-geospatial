## ----load-libraries------------------------------------------------------

#load raster package
library(raster)

## ----import-DTM-hillshade------------------------------------------------
#import DTM
DTM <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmcrop.tif")
#import DTM hillshade
DTM_hill <- raster("NEON_RemoteSensing/HARV/DTM/HARV_DTMhill_WGS84.tif")

#NOTE: this should use color brewer for consistency across lessons
#	Plot hillshade using a grayscale color ramp 
plot(DTM_hill,
    col=grey(1:100/100),
    legend=F,
    main="NEON Hillshade - DTM\n Harvard Forest")

#overlay the DSM on top of the hillshade
plot(DTM,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)


## ----explore-crs---------------------------------------------------------

#view crs for DTM
crs(DTM)

#view crs for hillshade
crs(DTM_hill)


## ----reproject-raster----------------------------------------------------

#reproject to WGS84
DTM_hill_UTMZ18N <- projectRaster(DTM_hill, crs=crs(DTM))

DTM_hill_UTMZ18N
#note: in this case we know that the resolution fo the data should be 1 m. We can 
#assign that in the reprojection as well
DTM_hill_UTMZ18N <- projectRaster(DTM_hill, 
                                  crs=crs(DTM),
                                  res=1)
DTM_hill_UTMZ18N


## ----plot-projected-raster-----------------------------------------------

#plot newly reprojected hillshade
plot(DTM_hill_UTMZ18N,
    col=grey(1:100/100),
    legend=F,
    main="NEON Hillshade - DTM\n Harvard Forest")

#overlay the DSM on top of the hillshade
plot(DTM,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)

