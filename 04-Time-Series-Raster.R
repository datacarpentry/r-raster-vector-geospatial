## ----load-libraries------------------------------------------------------

library(raster)
library(rgdal)


## ----import-ndvi-rasters-------------------------------------------------

# Create list of NDVI file paths
NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"
all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")

#view list - note that the full path (relative to our working directory)
#is included
all_NDVI


## ----create-timeSeries-raster-stack--------------------------------------
# Create a time series raster stack
NDVI_stack <- stack(all_NDVI)

#view crs of rasters
crs(NDVI_stack)

#view extent of rasters in stack
extent(NDVI_stack)

## ----plot-time-series----------------------------------------------------

#view a histogram of all of the rasters
plot(NDVI_stack, zlim = c(1500, 10000), nc = 4)


hist(NDVI_stack, xlim = c(1500, 10000))

# TODO: Challenge: two of the times have weird values because of clouds, have them figure that out


#http://oscarperpinan.github.io/rastervis/

