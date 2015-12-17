## ----load-libraries-data-------------------------------------------------

library(raster)
library(rgdal)
library(rasterVis)

# Create list of NDVI file paths
NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"  #assign path to object = cleaner code
all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")

# Create a time series raster stack
NDVI_stack <- stack(all_NDVI)

## ----plot-time-series----------------------------------------------------
#view a histogram of all of the rasters
#nc specifies number of columns
plot(NDVI_stack, 
     zlim = c(1500, 10000), 
     nc = 4)


## ----levelplot-time-series-----------------------------------------------
#create a `levelplot` plot
levelplot(NDVI_stack,
          main="Landsat NDVI\nHarvard Forest")


## ----change-color-ramp---------------------------------------------------
#use colorbrewer which loads with the rasterVis package to generate
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
rasterNames  <- gsub("X","Day", names(NDVI_stack))

#view Names
rasterNames

#replace the second part of the string with year
rasterNames  <- gsub("_HARV_ndvi_crop","",rasterNames)

#view names for each raster layer
rasterNames

## ----create-levelplot----------------------------------------------------

#use level plot to create a nice plot with one legend and a 4x4 layout.
levelplot(NDVI_stack,
          layout=c(4, 4), #create a 4x4 layout for the data
          col.regions=cols, #add a color ramp
          main="Landsat NDVI - Julian Days \nHarvard Forest 2014",
          names.attr=rasterNames)


## ----adjust-layout-------------------------------------------------------
#use level plot to create a nice plot with one legend and a 4x4 layout.
levelplot(NDVI_stack,
          layout=c(5, 3), #create a 5x3 layout for the data
          col.regions=cols, #add a color ramp
          main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
          names.attr=rasterNames)

## ----challenge-code-levelplot-divergent, echo=FALSE----------------------
#change Day### to JulianDay_###
rasterNames  <- gsub("Day","JulianDay_",rasterNames)

#use level plot to create a nice plot with one legend and a 4x4 layout.
levelplot(NDVI_stack,
          layout=c(5, 3), #create a 5x3 layout for the data
          col.regions=colorRampPalette(brewer.pal(9,"BrBG")), #specify color 
          main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
          names.attr=rasterNames)

#The sequential is better than the divergent as it is more akin to the process
#of greening up, which starts off at one end and just keeps increasing. 


