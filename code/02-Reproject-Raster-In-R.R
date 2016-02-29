## ----load-libraries------------------------------------------------------
# load raster package
library(raster)
library(rgdal)

## ----import-DTM-hillshade------------------------------------------------
# import DTM
DTM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
# import DTM hillshade
DTM_hill_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")

# plot hillshade using a grayscale color ramp 
plot(DTM_hill_HARV,
    col=grey(1:100/100),
    legend=FALSE,
    main="DTM Hillshade\n NEON Harvard Forest Field Site")

# overlay the DTM on top of the hillshade
plot(DTM_HARV,
     col=terrain.colors(10),
     alpha=0.4,
     add=TRUE,
     legend=FALSE)


## ----plot-DTM------------------------------------------------------------
# Plot DTM 
plot(DTM_HARV,
     col=terrain.colors(10),
     alpha=1,
     legend=F,
     main="Digital Terrain Model\n NEON Harvard Forest Field Site")


## ----explore-crs---------------------------------------------------------
# view crs for DTM
crs(DTM_HARV)

# view crs for hillshade
crs(DTM_hill_HARV)

## ----reproject-raster----------------------------------------------------

# reproject to UTM
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                       crs=crs(DTM_HARV))

# compare attributes of DTM_hill_UTMZ18N to DTM_hill
crs(DTM_hill_UTMZ18N_HARV)
crs(DTM_hill_HARV)

# compare attributes of DTM_hill_UTMZ18N to DTM_hill
extent(DTM_hill_UTMZ18N_HARV)
extent(DTM_hill_HARV)


## ----challenge-code-extent-crs, echo=FALSE-------------------------------
# The extent for DTM_hill_UTMZ18N_HARV is in UTMs so the extent is in meters. 
# The extent for DTM_hill_HARV is still in lat/long so the extent is expressed
# in decimal degrees.  

## ----view-resolution-----------------------------------------------------

# compare resolution
res(DTM_hill_UTMZ18N_HARV)


## ----reproject-assign-resolution-----------------------------------------
# adjust the resolution 
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                  crs=crs(DTM_HARV),
                                  res=1)
# view resolution
res(DTM_hill_UTMZ18N_HARV)


## ----plot-projected-raster-----------------------------------------------
# plot newly reprojected hillshade
plot(DTM_hill_UTMZ18N_HARV,
    col=grey(1:100/100),
    legend=F,
    main="DTM with Hillshade\n NEON Harvard Forest Field Site")

# overlay the DTM on top of the hillshade
plot(DTM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)

## ----challenge-code-reprojection, echo=FALSE-----------------------------

# import DTM
DSM_SJER <- raster("NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmcrop.tif")
# import DTM hillshade
DSM_hill_SJER_WGS <- 
  raster("NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")

# reproject raster 
DTM_hill_UTMZ18N_SJER <- projectRaster(DSM_hill_SJER_WGS, 
                                  crs=crs(DSM_SJER),
                                  res=1)
# plot hillshade using a grayscale color ramp 
plot(DTM_hill_UTMZ18N_SJER,
    col=grey(1:100/100),
    legend=F,
    main="DSM with Hillshade\n NEON SJER Field Site")

# overlay the DSM on top of the hillshade
plot(DSM_SJER,
     col=terrain.colors(10),
     alpha=0.4,
     add=T,
     legend=F)


## ----challenge-code-reprojection2, echo=FALSE----------------------------
# The maps look identical. Which is what they should be as the only difference
# is this one was reprojected from WGS84 to UTM prior to plotting.  

