---
layout: post
title: "Lesson 03: Raster Calculations - Overlay & Raster Math in R"
date:   2015-10-26
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym, Leah Wasser]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-11-16
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
When dealing with spatial data, we often want to perform calculaions on rasters 
or combine multiple rasters to create a new output raster.This lesson will cover 
some of the most common functions to modify rasters including `overlay`, `calc` and raster math.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will:

* Be able to to perform a subtraction (difference) between two rasters using 
raster math.
* Know how to perform a more efficient subtraction (difference) between two 
rasters using the raster `overlay()` function in R.

###Things You'll Need To Complete This Lesson

Please be sure you have the most current version of `R` and, preferably,
R studio to write your code.

####R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

####Data to Download

Download the workshop data:

* <a href="http://files.figshare.com/2387965/NEON_RemoteSensing.zip" class="btn btn-success"> DOWNLOAD Sample NEON Raster Data Derived from LiDAR over Harvard
Forest and SJER Field Sites</a>

The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the Harvard and San Joaquin field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the NEON website. 

####Recommended Pre-Lesson Reading

<a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

</div>

#Manipulating Rasters in R
We often want to overlay two or more rasters on top 
of each other, and perform calculations to create a new output raster. If 
interested in measuring the heights of trees, then what we really want is the 
*difference* between the Digital Surface Model (DSM, tops of trees) and the 
Digital Terrain Model (DTM, ground level) .This data product is often referred
to as a Canopy Height Model (CHM) and represents the actual height of trees, 
buildings, etc above the ground.

We can calculate this difference in two different ways:

1) by directly subtracting the two rasters in `R` using raster math

or if our rasters are large

2) using the `overlay()` function to more efficiently calculate the difference.

First, we'll learn the intuitive first step of subtracting layers to create and
plot a CHM.  In the geospatial world we often call this *raster math*.

If you completed the <a href="/R/Introduction-to-Raster-Data-In-R/" target="_blank">
About Raster Data </a> and the <a R/Reproject-Raster-In-R.R/" target="_blank">
Reproject Rasters in R </a> lessons,  you've already loaded and viewed 
`HARV_dtmCrop.tif` and `HARV_dsmCrop.tif` and can skip this code chunk.  If you 
have not, let's load and check out our raster files. 


    #load raster package
    library(raster)
    
    #view info about the dtm & dsm raster data
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

    GDALinfo("NEON_RemoteSensing/HARV/DTM/HARV_dsmCrop.tif")

    ## Error in .local(.Object, ...): `NEON_RemoteSensing/HARV/DTM/HARV_dsmCrop.tif' does not exist in the file system,
    ## and is not recognised as a supported dataset name.

    #load the DTM & DSM rasters
    DTM_HARV <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
    DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")
    #create a quick plot of each to see what we're dealing with
    plot(DTM_HARV,
         main="Digital Terrain Model (Elevation)\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/load-libraries-1.png) 

    plot(DSM_HARV,
         main="Digital Surface Model (Elevation)\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/load-libraries-2.png) 

Once the data are loaded, we can use mathametical operations on them.
For instance, we can subtract the DTM from the DSM to create a Canopy Height
Model.


    # Raster math example
    CHM_HARV <- DSM_HARV - DTM_HARV 
    
    #view the output CHM
    plot(CHM_HARV,
         main="NEON Canopy Height Model - Subtracted\n Harvard Forest") 

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/raster-math-1.png) 
Notice the legend on the right.  We are now looking at the height of the canopy 
instead of the elevation hence the smaller numbers.  

#Challenge: Exploring Raster Values in CHM
As we learned in previous lessons, it's often a good idea to explore the range 
of values in a raster dataset just like we might explore a dataset that we 
collected in the field.  

1. What range of values do you expect to see for the Harvard Forest Canopy 
Height Model (`CHM_HARV`) that we just created? 
2. What are two ways you can check this range of data in `CHM_HARV`? 
3. Plot your data in such a way that you can see the range of data values in 
CHM.
4. Bonus challenge: Change the color of and add a title to the plot you created 
in question 3. 


    ## [1] 0

    ## [1] 38.16998

    ## Error in hist(CHMv, maxpixels = ncell(CHM_HARV)): error in evaluating the argument 'x' in selecting a method for function 'hist': Error: object 'CHMv' not found

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/challenge-code-CHM-HARV-1.png) 

#Efficient Raster Calculations: Overlay Function
Basic raster math like we just did, is an appropriate aporoach to a calculation 
if

1. The rasters we are using are small in size.
2. The calculations we are performing are simple.

Raster math is intuitive and easy to code, however it is less efficient as 
computation becomes more complex or as file sizes become larger. The `overlay()`
function is more efficient when

1. The rasters we are using are larger in size. 
2. The rasters are stored as individual files. 
3. The computations needed are complex. 

The `overlay()` function takes two or more rasters and applies a function to
them using efficient processing methods. The syntax is

`outputRaster <- overlay(raster1, raster2, fun=functionName)`

> NOTE: If the rasters are stacked and stored as `RasterStack` or `RasterBrick`
> objects in R, then we should use `calc()`. `overlay()` will not work on
> stacked rasters. 


Let's repeat our simple raster math computation using `overlay()`.  


    CHM_ov_HARV<- overlay(DSM_HARV,DTM_HARV,fun=function(r1, r2){return(r1-r2)})
    
    plot(CHM_ov_HARV,
         main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/raster-overlay-1.png) 

> Bonus: When doing the overlay we used a function. A function represents a set
of tasks that need to be repeated over and over. Functions are very useful in
many different contexts. A simplified syntax for a function in R is:

> `functionName <- function(variable1, variable2){WhatYouWantDone, WhatToReturn}`

> In our case what we want does is what we want returned so we don't have to 
specify it twice. 

#Writing Raster Files
So now we've learned two different ways to do raster calculations.  This gives 
us an output raster object (`CHM_ov_HARV`), we can use the `writeRaster` 
function to export the object as a new GeoTIFF. 

When we write this raster object to a GeoTIFF file we'll name it 
`chm_ov_HARV.tiff` this way we know that it is a canopy height model of Harvard 
Forest created using overlay.  Any files you write will be saved in whichever 
file is the current working directory. 


    #export CHM object to new GeotIFF
    writeRaster(CHM_ov_HARV,"chm_ov_HARV.tiff",
                format="GTiff", 
                overwrite=TRUE, 
                NAflag=-9999)

In the code we specify that the format will be GTiff. Overwrite is true so that
it replaces any other file with this name.  This is a useful setting so that you
can make a change to the object and then update the file by re-runing the code.
However, be careful to never accidentally re-use a name for a file that already 
exists. We are setting the NA value to -9999, a standard NoData value. 

#Challenge: Explore the NEON San Joaquin (SJER) Field Site 
As ecologists we may want to explore the phenology of two different sites.  The 
San Joaquin valley in California is rather different from the Harvard Forest in 
Massachusetts and could make a good comparison.  

LiDAR and imagery data used to create the rasters were collected at the San 
Joaquin NEON field sites the same as for the Harvard Forest NEON field sites. 

Your challenge is to import the San Joaquin raster files so that we can compare 
to two sites. So that we can use object/file names in future lessons names 
should follow the format of objectType_SJER (e.g. `DSM_SJER`).

1. Import the DSM and DTM from the SJER directory. Don't forget to examine the
data for CRS, bad values, etc. 
2. Create a CHM from the two raster layers and check to make sure the data are 
what you expect. 
3. Plot the CHM from SJER. 
4. Export as a GeoTIFF.
5. What do you notice about tree heights at the two sites?  Hint: plotting SJER and HARV data 
side-by-side would be an effective way to see the data at the same time.


    ## An object of class ".SingleLayerData"
    ## Slot "values":
    ## logical(0)
    ## 
    ## Slot "offset":
    ## [1] 0
    ## 
    ## Slot "gain":
    ## [1] 1
    ## 
    ## Slot "inmemory":
    ## [1] FALSE
    ## 
    ## Slot "fromdisk":
    ## [1] TRUE
    ## 
    ## Slot "isfactor":
    ## [1] FALSE
    ## 
    ## Slot "attributes":
    ## list()
    ## 
    ## Slot "haveminmax":
    ## [1] TRUE
    ## 
    ## Slot "min":
    ## [1] 338.93
    ## 
    ## Slot "max":
    ## [1] 496.31
    ## 
    ## Slot "band":
    ## [1] 1
    ## 
    ## Slot "unit":
    ## [1] ""
    ## 
    ## Slot "names":
    ## [1] "SJER_dtmCrop"

    ## An object of class ".SingleLayerData"
    ## Slot "values":
    ## logical(0)
    ## 
    ## Slot "offset":
    ## [1] 0
    ## 
    ## Slot "gain":
    ## [1] 1
    ## 
    ## Slot "inmemory":
    ## [1] FALSE
    ## 
    ## Slot "fromdisk":
    ## [1] TRUE
    ## 
    ## Slot "isfactor":
    ## [1] FALSE
    ## 
    ## Slot "attributes":
    ## list()
    ## 
    ## Slot "haveminmax":
    ## [1] TRUE
    ## 
    ## Slot "min":
    ## [1] 338.96
    ## 
    ## Slot "max":
    ## [1] 510.35
    ## 
    ## Slot "band":
    ## [1] 1
    ## 
    ## Slot "unit":
    ## [1] ""
    ## 
    ## Slot "names":
    ## [1] "SJER_dsmCrop"

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/challenge-code-SJER-CHM-1.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/challenge-code-SJER-CHM-2.png) 

    ## Error in .local(x, y, ...): object 'subtRasters' not found

    ## Error in hist(CHM_ov_SJER, main = "NEON Canopy Height Model - Histogram\n SJER"): error in evaluating the argument 'x' in selecting a method for function 'hist': Error: object 'CHM_ov_SJER' not found

    ## Error in plot(CHM_ov_SJER, main = "NEON Canopy Height Model - Overlay Subtract\n SJER"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'CHM_ov_SJER' not found

    ## Error in writeRaster(CHM_ov_SJER, "chm_ov_SJER.tiff", format = "GTiff", : error in evaluating the argument 'x' in selecting a method for function 'writeRaster': Error: object 'CHM_ov_SJER' not found

    ## Error in hist(CHM_ov_SJER, main = "NEON Canopy Height Model - Histogram\n SJER"): error in evaluating the argument 'x' in selecting a method for function 'hist': Error: object 'CHM_ov_SJER' not found

![ ]({{ site.baseurl }}/images/rfigs/03-Modify-Raster/challenge-code-SJER-CHM-3.png) 
