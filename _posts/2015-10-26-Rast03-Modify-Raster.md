---
layout: post
title: "Lesson 03: Raster Calculations - Overlay & Raster Math in R"
date:   2015-10-26
authors: "Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym, Leah Wasser"
dateCreated:  2015-10-23
lastModified: 2015-11-09
category: spatio-temporal-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This lesson explains functions that modify raster data in R."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Modify-Rasters-In-R.R
comments: false
---

{% include _toc.html %}

##About
We often want to perform calculaions on rasters or combine multiple rasters to create
a new output raster.This lesson will cover some of the most common functions to 
modify rasters including `overlay`, `calc` and raster math.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will know:

* How to compute raster math.
* How to crop rasters.

###Things You'll Need To Complete This Lesson

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

####Tools To Install

Please be sure you have the most current version of `R` and preferably
R studio to write your code.


####Data to Download

Download the workshop data:

* <a href="http://files.figshare.com/2387965/NEON_RemoteSensing.zip" class="btn btn-success"> DOWNLOAD Sample NEON Raster Data Derived from LiDAR over Harvard
Forest and SJER Field Sites</a>

The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the Harvard and San Joaquin field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the NEON website. 

####Recommended Pre-Lesson Reading

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

</div>

#Manipulating Rasters in R

We often want to overlay two or more rasters on top of each other, and perform
calculations to create a new output raster. For example, we might have a lidar
`Digital Surface Model (DSM)` that tells us the elevation at the top of the earths surface.
This means that it is the elevation at the tops of trees, buildings and all other
objects on the earth. In comparison, a `Digital Terrain Model (DTM)` or `Digital Elevation
Model (DEM)` contains elevation data for the actual ground (with trees, buildings and 
other objects removed). 

In ecology, we are often interested in measuring the heights of trees and so the
raster that we really want is the `difference` between the `DSM` and the `DTM`.
This data product is often referred to as a `Canopy Height Model (CHM)` and represents
the actual height of trees, buildings etc above the ground.

We can calculate this difference by subtracting the two rasters in `R`. However
if our rasters get large, we can calculate the difference more efficiently using
the `overlay` function. 

First, let's create and plot a `CHM` by subtracting two rasters.


    #load raster package
    library(raster)
    
    # CHALLENGE: repeat objectives 1 & 2 for a different .tif file
    
    
    #load the DTM
    DTM <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
    
    #create a quick plot
    plot(DTM,
         main="Digital Terrain Model (Elevation)\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/load-libraries-1.png) 

    #If it isn't already loaded, load the DSM as well 
    DSM <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

Once the data are loaded, we can use mathametical operations on them.
For instance, we can subtract the DTM from the DSM to create a `Canopy Height
Model`.


    # Raster math example
    
    CHM <- DSM - DTM #This section could be automatable later on
    
    #view the output CHM
    plot(CHM,
         main="NEON Canopy Height Model - Subtracted\n Harvard Forest") 

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/raster-math-1.png) 

    #Ask participants what they think this might look like ahead of time
    hist(CHM, col = "purple")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/raster-math-2.png) 

#Raster Overlay

Raster math is an appropriate aporoach to this calculation if

1. The rasters we are using are small in size.
2. THe calculations we are performing are simple.

Raster math is easy to code up, however it is less efficient as computation becomes
more complex or as file sizes become larger. To deal with larger rasters that are
indivitual (ie not in a `RasterStack` or `RasterBrick`), we should use the `overlay` function. If our rasters are stacked, then we can use `calc`.

Let's have a look at how the `overlay` function works.

To the `overlay` function takes two or more rasters and applies a function to them.

`outputRaster <- overlay(raster1, raster2, function)`


    #first, let's create a function
    #this function will take two rasters (r1 and r2) and subtract them
    subtRasters <- function(r1, r2){
    return(r1-r2)
    }
    
    CHM_ov <- overlay(DSM,DTM,fun=subtRasters)
    
    plot(CHM_ov,
         main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/raster-overlay-1.png) 

So now, we've learned two different ways to subtract two rasters in R.
Once we have an output raster, we can use the `writeRaster` function to export
the object as a new geotiff. 


    #export CHM object to new geotiff
    writeRaster(CHM_ov,"chm_ov.tiff",
                format="GTiff", 
                overwrite=TRUE, 
                NAflag=-9999)
    
    #note we are setting the NA value to -9999 for consistency.

#Challenge
1. Import the DSM and DTM from the SJER directory. These data are also derived from
NEON lidar data but cover the San Joachin experimental range field site in 
Southern California. Create a CHM from the two raster layers. Export as a geotiff.

2. Once you are done with the above, plot a histogram of both CHM's. What do you notice
about tree heights across the two sites?

???


    # Crop raster, first method
    plot(CHM)
    cropbox <- drawExtent()

    ## Warning in max(loc[, "x"]): no non-missing arguments to max; returning -Inf

    ## Warning in min(loc[, "y"]): no non-missing arguments to min; returning Inf

    ## Warning in max(loc[, "y"]): no non-missing arguments to max; returning -Inf

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/unnamed-chunk-1-1.png) 

    manual_crop <- crop(CHM, cropbox)

    ## Error in validityMethod(object): invalid extent: xmin >= xmax

    plot(manual_crop)

    ## Error in plot(manual_crop): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'manual_crop' not found

    # Crop raster, second method
    coords <- c(xmin(CHM) + ncol(CHM) * 0.1, xmax(CHM) - ncol(CHM) * 0.1, 
                ymin(CHM), ymax(CHM))
    coord_crop = crop(CHM, coords)
    plot(coord_crop) #Compare with CHM raster, should have different x-axis ranges

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/unnamed-chunk-1-2.png) 

    # Challenge: play with resolution (i.e., pixel numbers)
    
    # TODO: reprojection of a single-band raster, ask others? 
    # TODO: summarizing multiple pixels into one value
    # TODO: do raster math on single raster

