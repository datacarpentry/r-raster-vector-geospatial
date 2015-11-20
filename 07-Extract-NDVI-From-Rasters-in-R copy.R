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

# Create a time series raster stack
NDVI_stack <- stack(all_NDVI)


## ------------------------------------------------------------------------

#create data frame, calculate NDVI
ndvi.df.HARV <- as.data.frame(matrix(-999, ncol = 2, nrow = length(all_NDVI)))

colnames(ndvi.df.HARV) <- c("julianDays", "meanNDVI")

i <- 0

for (aRaster in all_NDVI){
  i=i+1
  #open raster
  oneRaster <- raster(aRaster)
  
  #calculate the mean of each
  ndvi.df.HARV$meanNDVI[i] <- cellStats(oneRaster,mean) 
  
  #grab julian days
  ndvi.df.HARV$julianDays[i] <- substr(aRaster,nchar(aRaster)-21,nchar(aRaster)-19)
}

ndvi.df.HARV$yr <- as.integer(2011)
ndvi.df.HARV$site <- "SJER"

#plot NDVI
ggplot(ndvi.df.HARV, aes(julianDays, meanNDVI)) +
  geom_point(size=4,colour = "blue") + 
  ggtitle("NDVI for HARV 2011\nLandsat Derived") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))



