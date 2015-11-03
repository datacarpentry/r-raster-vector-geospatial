## ----elevation-map-------------------------------------------------------
# code output here - DEM rendered on the screen
# dem hillshade

## ----classified-elevation-map--------------------------------------------
# code output here - DEM classified and rendered on the screen
# CHM classified low, med tall


## ----load-libraris-------------------------------------------------------
library(raster)
library(rgdal)


## ----open-raster---------------------------------------------------------
# Load raster into r
DSM <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# Look at raster structure
DSM 


## ----view-resolution-units-----------------------------------------------
#view resolution units
DSM@data@unit


## ----view-raster-CRS-----------------------------------------------------

#view raster crs - in Proj 4 format
crs(DSM)


## ------------------------------------------------------------------------
DSM <- setMinMax(DSM) #This step might be unnecessary

#view min value
DSM@data@min

#view max value
DSM@data@max


## ----no-data-values------------------------------------------------------
#view raster no data value
NAvalue(DSM)


## ----view-raster-histogram-----------------------------------------------

#view raster no data value
hist(DSM)


