## ----load-libraries------------------------------------------------------

library(raster)
library(rgdal)
library(rasterVis)


## ----import-ndvi-rasters-------------------------------------------------

# Create list of NDVI file paths
NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"
all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")

#view list - note that the full path (relative to our working directory)
#is included
all_NDVI

# Create a time series raster stack
NDVI_stack <- stack(all_NDVI)


## ----levelplot-time-series-----------------------------------------------

#create a level plot - plot
levelplot(NDVI_stack,
          main="Landsat NDVI\nHarvard Forest")


## ----change-color-ramp---------------------------------------------------

#use color brewer which loads with rasterVis to generate
#a color ramp of yellow to green
cols <- colorRampPalette(brewer.pal(9,"YlGn"))
#create a level plot - plot
levelplot(NDVI_stack,
          main="Landsat NDVI better colors \nHarvard Forest",
          col.regions=cols)



## ----clean-up-names------------------------------------------------------

#view names for each raster layer
names(NDVI_stack)

#use gsub to use the names of the layers to create a list of new names
#that we'll use for the plot 
rasterNames  <- gsub("X","",names(NDVI_stack))

#view Names
rasterNames

#replace the second part of the string
rasterNames  <- gsub("_HARV_ndvi_crop","",rasterNames)

#view names for each raster layer
rasterNames

## ----create-level-plot---------------------------------------------------

#use level plot to create a nice plot with one legend and a 4x4 layout.
levelplot(NDVI_stack, #create a 4x4 layout for the data
          col.regions=cols, #add a color ramp
          main="Landsat NDVI - Julian Days \nHarvard Forest 2014")


## ----adjust-layout-------------------------------------------------------
#use level plot to create a nice plot with one legend and a 4x4 layout.
levelplot(NDVI_stack,
          layout=c(5, 3), #create a 4x4 layout for the data
          col.regions=cols, #add a color ramp
          main="Landsat NDVI - Julian Days \nHarvard Forest 2014",
          names.attr=rasterNames)

