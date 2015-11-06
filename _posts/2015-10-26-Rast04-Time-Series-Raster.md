---
layout: post
title: "Lesson 04: Raster Time Series Data in R"
date:   2015-1-25
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym,
Leah Wasser]
dateCreated:  2014-11-26
lastModified: 2015-07-23
category: time-series-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This post explains the fundamental principles, functions and metadata that you need to work with raster data in R."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Raster-Times-Series-Data-In-R/
comments: false
---

{% include _toc.html %}

##About
This lesson will explore the functions and libraries needed to work with time series
rasters in `R`. 

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will know:

* What time series raster format is.
* How to work with a set of time series rasters.
* How to plot and explore time series raster data.

###Things You'll Need To Complete This Lesson

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`


####Tools To Install

Please be sure you have the most current version of `R` and preferably
R studio to write your code.


####Data to Download

* <a href="http://figshare.com/articles/NEON_AOP_Hyperspectral_Teaching_Dataset_SJER_and_Harvard_forest/1580086" class="btn btn-success"> DOWNLOAD Sample NEON LiDAR data in Raster Format & Vegetation Sampling Data</a>


The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the Harvard and San Joaquin field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the NEON website.  

####Recommended Pre-Lesson Reading


* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

</div>


    library(raster)
    library(rgdal)

#About the Time Series Data

In this lesson, we are working with a set of rasters, that were derived from the 
Landsat satellite - in `GeoTiff` format. Each
raster covers the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>.

The first set of rasters, located in the `Landsat_NDVI\HARV\ndvi` is the Normalized
Difference Vegetation Index (NDVI). NDVI is... more here

Both sets of rasters are available for the same time periods throughout the year
of 2013. 

##Understanding the metadata
?? we could teach this but Leah would need to rename the files to the original
names -- thoughts?

##Goals
In this lesson, we will
1. import the NDVI data
2. create a time series of NDVI throughout one year
3. generate an average NDVI value for each time period throughout the year.

To begin, we will import use a list of oraster file names to generate a `RasterStack`.
We can use `list.files` to generate the list. We will tell R to only find files 
with a `.tif` extention using the syntax `pattern=".tif$"`.

If we specify `full.names=TRUE`, we will be able to create a `RasterStack` directly
from the list.


    # Create list of NDVI file paths
    NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"
    all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")
    
    #view list - note that the full path (relative to our working directory)
    #is included
    all_NDVI

    ##  [1] "Landsat_NDVI/HARV/2011/ndvi/005_HARV_ndvi_crop.tif"
    ##  [2] "Landsat_NDVI/HARV/2011/ndvi/037_HARV_ndvi_crop.tif"
    ##  [3] "Landsat_NDVI/HARV/2011/ndvi/085_HARV_ndvi_crop.tif"
    ##  [4] "Landsat_NDVI/HARV/2011/ndvi/133_HARV_ndvi_crop.tif"
    ##  [5] "Landsat_NDVI/HARV/2011/ndvi/181_HARV_ndvi_crop.tif"
    ##  [6] "Landsat_NDVI/HARV/2011/ndvi/197_HARV_ndvi_crop.tif"
    ##  [7] "Landsat_NDVI/HARV/2011/ndvi/213_HARV_ndvi_crop.tif"
    ##  [8] "Landsat_NDVI/HARV/2011/ndvi/229_HARV_ndvi_crop.tif"
    ##  [9] "Landsat_NDVI/HARV/2011/ndvi/245_HARV_ndvi_crop.tif"
    ## [10] "Landsat_NDVI/HARV/2011/ndvi/261_HARV_ndvi_crop.tif"
    ## [11] "Landsat_NDVI/HARV/2011/ndvi/277_HARV_ndvi_crop.tif"
    ## [12] "Landsat_NDVI/HARV/2011/ndvi/293_HARV_ndvi_crop.tif"
    ## [13] "Landsat_NDVI/HARV/2011/ndvi/309_HARV_ndvi_crop.tif"

Once the files are read into R, we can create a stack and begin to work with the
data. Be sure to explore the embedded metadata!


    # Create a time series raster stack
    NDVI_stack <- stack(all_NDVI)
    
    #view crs of rasters
    crs(NDVI_stack)

    ## CRS arguments:
    ##  +proj=utm +zone=19 +ellps=WGS84 +units=m +no_defs

    #view extent of rasters in stack
    extent(NDVI_stack)

    ## class       : Extent 
    ## xmin        : 239415 
    ## xmax        : 239535 
    ## ymin        : 4714215 
    ## ymax        : 4714365

#Plotting Time Series Data


    #view a histogram of all of the rasters
    plot(NDVI_stack, zlim = c(1500, 10000), nc = 4)

![ ]({{ site.baseurl }}/images/rfigs/04-Time-Series-Raster/plot-time-series-1.png) 

    hist(NDVI_stack, xlim = c(1500, 10000))
    
    # TODO: Challenge: two of the times have weird values because of clouds, have them figure that out
    
    
    #http://oscarperpinan.github.io/rastervis/

![ ]({{ site.baseurl }}/images/rfigs/04-Time-Series-Raster/plot-time-series-2.png) 
