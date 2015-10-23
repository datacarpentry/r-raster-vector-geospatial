### Objective 1: opening and understanding structure of single-band raster

library(raster)
library(rgdal)

# Opening raster
DSM <- raster("~/Documents/Graduate_School/Workshops/GST_hackathon/1_WorkshopData/NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

# Looking at raster structure
DSM #Identify this as a type of metadata, what else might you need that's not included here? 
DSM <- setMinMax(DSM) #This step might be unnecessary
DSM_min <- cellStats(DSM, min)
DSM_max <- cellStats(DSM, max)
#Add no data values to geotiff, then add section looking for -9999 values and
#changing to NaN (or equivalent); there would be a challenge here, because the
#-9999 should show up as the min value


### Objective 2: plotting single-band raster

# Plot raster file and change some parameters
plot(DSM) #Necessary to explicitly differentiate between base plot and raster plot?
pixels <- ncol(DSM) * nrow(DSM)
hist(DSM, col = "blue", maxpixels = pixels)
myCol <- terrain.colors(10)
plot(DSM, breaks = c(320, 340, 360, 380, 400), col = myCol, maxpixels = pixels) #optional argument
plot(DSM, zlim = c(340, 400)) #optional argument
#image v. plot
# TODO: challenge

### Objective 3: changing single-band raster

# CHALLENGE: repeat objectives 1 & 2 for a different .tif file
DTM <- raster("~/Documents/Graduate_School/Workshops/GST_hackathon/1_WorkshopData/NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
plot(DTM)

# Raster math example
CHM <- DSM - DTM #This section could be automatable later on
plot(CHM) #Ask participants what they think this might look like ahead of time
hist(CHM, col = "purple")

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


### Objective 4: working with multi-band RGB rasters
# File: HARV_RBG_ortho
# Tutorial: Spatio-temporal
# Functions: stack, plotRGB
# Challenge: calculate NDVI

### Objective 5: working with multi-band time series rasters
# File: HARV/2011/NDVI
# Tutorial: Spatio-temporal
# Functions: plot (raster library)
