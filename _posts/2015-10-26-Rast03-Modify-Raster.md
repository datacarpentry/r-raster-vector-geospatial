---
layout: post
title: "Lesson 03: Raster Calculations - Overlay & Raster Math in R"
date:   2015-10-26
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym, Leah Wasser]
contributors: [Test Human]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-11-10
category: spatio-temporal-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This lesson covers how to use the overlay function in R to perform
efficient raster calculations. It also explains the basic principles of writing
functions in R."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Modify-Rasters-In-R
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

* How to perform a subtraction (difference) between two rasters using raster math.
* How to perform a more efficient subtraction (difference) between two rasters 
using the raster `Overlay` function in R.

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

First, let's create and plot a `CHM` by subtracting two rasters - we often call
this `raster math` in the geospatial world.


    #load raster package
    library(raster)
    
    #view info about the dtm raster data
    GDALinfo("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")

    ## rows        1367 
    ## columns     1697 
    ## bands       1 
    ## lower left origin.x        731453 
    ## lower left origin.y        4712471 
    ## res.x       1 
    ## res.y       1 
    ## ysign       -1 
    ## oblique.x   0 
    ## oblique.y   0 
    ## driver      GTiff 
    ## projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
    ## file        NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif 
    ## apparent band summary:
    ##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
    ## 1 Float64           TRUE       -9999          1       1697
    ## apparent band statistics:
    ##     Bmin   Bmax    Bmean      Bsd
    ## 1 304.56 389.82 344.8979 15.86147
    ## Metadata:
    ## AREA_OR_POINT=Area

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

#Exploring Raster Data Values

It's often a good idea to explore the range of values in a raster dataset just like
we might explore a dataset that we collected in the field. We can do this using
the `hist` function in `R`.

What range of values do you expect to see for the Harvard Forest `Canopy Height 
Model (CHM)` that we just created?



    #Create histogram of CHM values
    hist(CHM, 
         col = "purple",
         main = "Histogram of NEON Canopy Height Model\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/view-histogram-1.png) 

#Raster Overlay

Raster math is an appropriate aporoach to this calculation if

1. The rasters we are using are small in size.
2. The calculations we are performing are simple.

Raster math is easy to code up, however it is less efficient as computation becomes
more complex or as file sizes become larger. To deal with larger rasters that are
stored as individual files we should use the `overlay` function

NOTE: If our rasters are stacked and stored as `RasterStack` or `RasterBrick`
objects in R, then we can use `calc`.
{: .notice }

Let's have a look at how the `overlay` function works. The `overlay` function 
takes two or more rasters and applies a function to them using efficient processing
methods. The syntax looks like:

`outputRaster <- overlay(raster1, raster2, functionName )`

##Writing Functions in R

A function represents a set of tasks that need to be repeated over and over. 
The syntax for a function in R is as follows:

`functionName <- function(variable1, variable2){


}

LINK TO MORE ABOUT FUNCTIONS IN R 


    #first, let's create a function
    #this function will take two rasters (r1 and r2) and subtract them
    subtRasters <- function(r1, r2){
    return(r1-r2)
    }



    CHM_ov_HARV <- overlay(DSM,DTM,fun=subtRasters)
    
    plot(CHM_ov_HARV,
         main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/raster-overlay-1.png) 

So now, we've learned two different ways to subtract two rasters in R.
Once we have an output raster, we can use the `writeRaster` function to export
the object as a new geotiff. 


    #export CHM object to new geotiff
    writeRaster(CHM_ov_HARV,"chm_ov_HARV.tiff",
                format="GTiff", 
                overwrite=TRUE, 
                NAflag=-9999)
    
    #note we are setting the NA value to -9999 for consistency.

#Challenge 1
1. Import the DSM and DTM from the SJER directory. These data are also derived from
NEON lidar data but cover the San Joachin experimental range field site in 
Southern California. Create a CHM from the two raster layers. Export as a geotiff.
{: .notice }

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/SJER-CHM-1.png) 


2. Once you are done with the above, plot a histogram of both CHM's. What do you notice
about tree heights across the two sites?

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/histogram-compare-1.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/histogram-compare-2.png) 



     #Compare with CHM raster, should have different x-axis ranges
    
    # Challenge: play with resolution (i.e., pixel numbers)
    
    # TODO: reprojection of a single-band raster, ask others? 
    # TODO: summarizing multiple pixels into one value
    # TODO: do raster math on single raster

