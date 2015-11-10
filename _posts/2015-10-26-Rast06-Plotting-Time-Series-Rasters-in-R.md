---
layout: post
title: "Lesson 05: Raster Time Series Data in R"
date:   2015-10-24
authors: [Leah Wasser, Kristina Riemer, Zack Bryn, Jason Williams, Jeff Hollister, 
Mike Smorul]
contributors: [Test Human]
packagesLibraries: [raster, rgdal, rasterVis]
dateCreated:  2014-11-26
lastModified: 2015-11-10
category: time-series-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This lesson covers how to improve plotting output using the rasterVis
library in R. Specifically it covers using levelplot, and adding meaningful custom 
names to bands within a RasterStack."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Plot-Raster-Times-Series-Data-In-R/
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

* How to assign custom names to bands in a RasterStack for prettier plotting.
* Advanced plotting using `rasterVis` library and `levelplot`

###Things You'll Need To Complete This Lesson

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **rasterVis:** `install.packages("rasterVis")`

Note: the `rasterVis` library can be used to create nicer plots of raster time
series data! <a href="https://cran.r-project.org/web/packages/rasterVis/rasterVis.pdf"
target="_blank">Learn More about the rasterVis library</a>

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
    library(rasterVis)

#About the Time Series Data

In this lesson, we are working with the same set of rasters taht we used in 
[{{ site.baseurl}} /R/Raster-Times-Series-Data-In-R/ ](Lesson 05 - Time Series Rasters in R), 
that were derived from the Landsat satellite - in `GeoTiff` format. Each
raster covers the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>.


##Getting Started 

To begin, we will use the same raster stack that we used in the previous lesson.



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

    # Create a time series raster stack
    NDVI_stack <- stack(all_NDVI)

In the previous lesson, we used the `rasterVis` package and the `levelplot` function
to create a nicer looking plot of our raster time series.  


    #create a level plot - plot
    levelplot(NDVI_stack,
              main="Landsat NDVI\nHarvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/levelplot-time-series-1.png) 

We can customize that plot to make it look nicer too. Let's start by adjusting 
the color ramp used to render the rasters.

##Adjust the Color Ramp

Let's change the red color ramp to a green one that is more suited to our data.
We can do that using the `colorRampPalette` function in r in combination with 
`colorBrewer`. 


    #use color brewer which loads with rasterVis to generate
    #a color ramp of yellow to green
    cols <- colorRampPalette(brewer.pal(9,"YlGn"))
    #create a level plot - plot
    levelplot(NDVI_stack,
              main="Landsat NDVI better colors \nHarvard Forest",
              col.regions=cols)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/change-color-ramp-1.png) 

Now we have a nicer looking plot, with colors that make more sense given the 
data we are working with. But the labels for each raster are a bit clunky. 
Let's make sure each label represents the Julian day for the data. The names
come from the bands or layers in the `RasterStack`.

##Refining labels in our plot 

The first part of the name is the Julian Day. We might want to remove the "x" and 
replace it with Julian Day. We might want to remove the  the `_HARV_ndvi_crop` 
from each label and replace it with the YEAR. We can replace text with different 
text using the `gsub` function in R as follows: 

`gsub("stringToReplace","WhatYouWantToReplaceItWith",Robject` allows you to 
replace one or more patterns with new text. 

Note that we can use the `|` to replace more than one element. For example
`X|_HARV` tells R to replace all instances of both `X` and `_HARV` in the string.
Example: 
`gsub("X|_HARV_ndvi_crop","","X005_HARV_ndvi_crop")`
{ : .notice }



    #view names for each raster layer
    names(NDVI_stack)

    ##  [1] "X005_HARV_ndvi_crop" "X037_HARV_ndvi_crop" "X085_HARV_ndvi_crop"
    ##  [4] "X133_HARV_ndvi_crop" "X181_HARV_ndvi_crop" "X197_HARV_ndvi_crop"
    ##  [7] "X213_HARV_ndvi_crop" "X229_HARV_ndvi_crop" "X245_HARV_ndvi_crop"
    ## [10] "X261_HARV_ndvi_crop" "X277_HARV_ndvi_crop" "X293_HARV_ndvi_crop"
    ## [13] "X309_HARV_ndvi_crop"

    #use gsub to use the names of the layers to create a list of new names
    #that we'll use for the plot 
    rasterNames  <- gsub("X","",names(NDVI_stack))
    
    #view Names
    rasterNames

    ##  [1] "005_HARV_ndvi_crop" "037_HARV_ndvi_crop" "085_HARV_ndvi_crop"
    ##  [4] "133_HARV_ndvi_crop" "181_HARV_ndvi_crop" "197_HARV_ndvi_crop"
    ##  [7] "213_HARV_ndvi_crop" "229_HARV_ndvi_crop" "245_HARV_ndvi_crop"
    ## [10] "261_HARV_ndvi_crop" "277_HARV_ndvi_crop" "293_HARV_ndvi_crop"
    ## [13] "309_HARV_ndvi_crop"

    #replace the second part of the string
    rasterNames  <- gsub("_HARV_ndvi_crop","",rasterNames)
    
    #view names for each raster layer
    rasterNames

    ##  [1] "005" "037" "085" "133" "181" "197" "213" "229" "245" "261" "277"
    ## [12] "293" "309"

Once the names for each band have been reassigned, we can render our plot


    #use level plot to create a nice plot with one legend and a 4x4 layout.
    levelplot(NDVI_stack, #create a 4x4 layout for the data
              col.regions=cols, #add a color ramp
              main="Landsat NDVI - Julian Days \nHarvard Forest 2014")

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/create-level-plot-1.png) 

We can adjust the columns of our plot too using `layout=c(cols,rows)'. Below
we adjust the layout to be a matrix of 4 columns and 4 rows.


    #use level plot to create a nice plot with one legend and a 4x4 layout.
    levelplot(NDVI_stack,
              layout=c(5, 3), #create a 4x4 layout for the data
              col.regions=cols, #add a color ramp
              main="Landsat NDVI - Julian Days \nHarvard Forest 2014",
              names.attr=rasterNames)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/adjust-layout-1.png) 

CHALLENGE -- change the X in each layer name to `Julian_` to label each plot.
{ : .notice }




