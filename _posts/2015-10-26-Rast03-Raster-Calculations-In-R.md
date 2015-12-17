---
layout: post
title: "Lesson 03: Raster Calculations in R"
date:   2015-10-26
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym, Leah Wasser]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-12-17
category: spatio-temporal-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson covers how to use the `overlay` function in R to
perform efficient raster calculations. It also explains the basic principles of
writing functions in R."
code1: SR03-Raster-Calculations-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Raster-Calculations-In-R
comments: false
---

{% include _toc.html %}

##About
We often want to combine values of and perform calculations on rasters to create 
a new output raster. This lesson will cover three commonly used R functions 
including: `overlay`,`calc` and raster math.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will:

* Be able to to perform a subtraction (difference) between two rasters using 
raster math.
* Know how to perform a more efficient subtraction (difference) between two 
rasters using the raster `overlay()` function in R.

**To complete this lesson:** you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

####R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

####Data to Download

<a href="https://ndownloader.figshare.com/files/3579867" class="btn btn-success"> Download NEON Airborne Observation Platform Raster Data Teaching Subset</a> 

The LiDAR and imagery data used to create this raster teaching data subset were
collected over the NEON <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard Forest</a>
and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin Experimental Range</a>
field sites and processed at
<a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the 
<a href="http://www.neoninc.org/data-resources/get-data/airborne-data" target="_blank"> NEON Airborne Data Request Page on the NEON Website.</a>

**Set Working Directory:** This lessons assumes that you have set your working 
directory to the location of the downloaded and unzipped data subset. [An overview
of setting the working directory in `R` can be found here.]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") 
lesson prior to beginning this lesson.

**Challenge Code:** NEON Data lesson often contain challenges that reinforce 
learned skills. If available, the code for challenge solutions is found in a 
downloadable `R` script available on the footer of each lesson page.

###Additional Resources
<a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in `R`.</a>

</div>

#Raster Calculations in R
We often want to perform calculations on two or more rasters to create a new 
output raster. For example, if we are interested in mapping the heights of trees
across an entire field site, we might want to calculate the *difference* between
the Digital Surface Model (DSM, tops of trees) and the 
Digital Terrain Model (DTM, ground level). The resulting dataset is referred to 
as a Canopy Height Model (CHM) and represents the actual height of trees, 
buildings, etc with the influence of ground elevation removed.

<figure>
    <a href="{{ site.baseurl }}/images/raster_timeseries/lidarTree-height.png">
    <img src="{{ site.baseurl }}/images/raster_timeseries/lidarTree-height.png"></a>
    <figcaption> A canopy height model represents the difference between the
    digital surface model and a digital terrain model. It represents the actual
    height of the trees with the influence of elevation removed. Image source:
    NEON, Inc.</figcaption>
</figure>

<i class="fa fa-star"></i> **More Info:** More on LiDAR CHM, DTM and DSM in this NEON Data Skills overview: <a href="http://neondataskills.org/remote-sensing/2_LiDAR-Data-Concepts_Activity2/" target="_blank"> What is a CHM, DSM and DTM? About Gridded, Raster LiDAR Data</a>. 
{: .notice}

###Load the Data 
We will need the `raster` library to import and perform raster calculations. We
will use the DTM (`NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif`) and DSM 
(`NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif`) from the NEON Harvard Forest 
Field site.


    #load raster package
    library(raster)
    
    #view info about the dtm & dsm raster data that we will work with.
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

    GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

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
    ## file        NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif 
    ## apparent band summary:
    ##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
    ## 1 Float64           TRUE       -9999          1       1697
    ## apparent band statistics:
    ##     Bmin   Bmax    Bmean      Bsd
    ## 1 305.07 416.07 359.8531 17.83169
    ## Metadata:
    ## AREA_OR_POINT=Area

As seen from the `geoTiff` tags, both rasters have:

* the same `CRS`, 
* the same `resolution` 
* defined minimum and maximum values.

Let's load the data. 


    #load the DTM & DSM rasters
    DTM_HARV <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
    DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")
    
    #create a quick plot of each to see what we're dealing with
    plot(DTM_HARV,
         main="Digital Terrain Model (Elevation)\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/load-plot-data-1.png) 

    plot(DSM_HARV,
         main="Digital Surface Model (Elevation)\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/load-plot-data-2.png) 

##Two Ways to Perform Raster Calculations

We can calculate the difference between two rasters in two different ways:

1. by directly subtracting the two rasters in `R` using raster math

or for more efficient processing - particularly if our rasters are large and/or
the calculations we are performing are complex:

2. using the `overlay()` function.

##Raster Math & Canopy Height Models
We can perform raster calculations by simply subtracting (or adding,
multiplying, etc) two rasters. In the geospatial world, we call this
*raster math*.

Let's subtract the DTM from the DSM to create a Canopy Height Model.


    # Raster math example
    CHM_HARV <- DSM_HARV - DTM_HARV 
    
    #plot the output CHM
    plot(CHM_HARV,
         main="Canopy Height Model - Raster Math Subtract\n NEON Harvard Forest",
         axes=FALSE) 

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/raster-math-1.png) 

Let's have a look at the distribution of values in our newly created
Canopy Height Model (CHM).


    #histogram of CHM_HARV
    hist(CHM_HARV,
         col="springgreen4",
         main="Histogram of NEON Canopy Height Model\nNEON Harvard Forest Field Site",
         ylab="Number of Pixels",
         xlab="Tree Height (m) ")

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/create-hist-1.png) 

Notice that the range of values for the output CHM is between 0 and 30 meters.
Does this make sense for trees in Harvard Forest?

<div id="challenge" markdown="1">
#Challenge: Explore CHM Raster Values
It's often a good idea to explore the range of values in a raster dataset just
like we might explore a dataset that we collected in the field.  

1. What is the min and maximum value for the Harvard Forest Canopy 
Height Model (`CHM_HARV`) that we just created?
2. What are two ways you can check this range of data in `CHM_HARV`? 
3. What is the distribution of all the pixel values in the CHM? 
4. Plot a histogram with 6 bins instead of the default and change the color of
the histogram. 
5. Plot the `CHM_HARV` raster using breaks that make sense for the data. Include
a appropriate color palette for the data, plot title and no axes ticks / labels. 

</div>

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-CHM-HARV-1.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-CHM-HARV-2.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-CHM-HARV-3.png) 


#Efficient Raster Calculations: Overlay Function
Raster math, like we just did, is an appropriate approach to raster calculations
if:

1. The rasters we are using are small in size.
2. The calculations we are performing are simple.

However, raster math is a less efficient
approach as computation becomes more complex or as file sizes become large. 
The `overlay()` function is more efficient when:

1. The rasters we are using are larger in size. 
2. The rasters are stored as individual files. 
3. The computations performed are complex. 

The `overlay()` function takes two or more rasters and applies a function to
them using efficient processing methods. The syntax is

`outputRaster <- overlay(raster1, raster2, fun=functionName)`

<i class="fa fa-star"></i> **Data Tip:** If the rasters are stacked and stored 
as `RasterStack` or `RasterBrick` objects in `R`, then we should use `calc()`. 
`overlay()` will not work on stacked rasters. 
{: .notice}

Let's perform the same subtraction calculation that we calculated above using 
raster math, using the `overlay()` function.  


    CHM_ov_HARV<- overlay(DSM_HARV,
                          DTM_HARV,
                          fun=function(r1, r2){return(r1-r2)})
    
    plot(CHM_ov_HARV,
         main="Canopy Height Model - Overlay Subtract\n NEON Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/raster-overlay-1.png) 

How do the plots of the CHM created with manual raster math and the `overlay()`
function compare?  

<i class="fa fa-star"></i> **Data Tip:** A function consists of a define set of 
tasks performed on a input object. Functions are particularly useful for tasks that
need to be repeated over and over in the code. A simplified syntax for a
function in R is: `functionName <- function(variable1, variable2){WhatYouWantDone, WhatToReturn}`
{: .notice }

#Export a Geotiff
Now that we've created a new raster, let's export the data as a `geotiff` using
the `writeRaster` function. 

When we write this raster object to a `GeoTIF`F file we'll name it 
`chm_HARV.tiff`. This name allows us to quickly remember both what the data contains
(CHM data) and for where (HARVard Forest). The `writeRaster()` function by 
default writes the output file to your working directory unless you specify a 
ull file path.


    #export CHM object to new GeotIFF
    writeRaster(CHM_ov_HARV, "chm_HARV.tiff",
                format="GTiff",  #specify output format - geotiff
                overwrite=TRUE, #CAUTION if this is true, it will overwrite an existing file
                NAflag=-9999) #set no data value to -9999

##writeRaster Options
The options that we used above include:

* **format:** specify that the format will be `GTiff` or `geoTiff`. 
* **Overwrite:** If TRUE, R will overwrite an existing file in the specified directory
if it exists, with the same name. USE THIS SETTING with CAUTION!
* **NAflag:** set the `geotiff` tag for `NoData` to -9999, the National Ecological
Observatory Network's (NEON) standard `NoData` value. 

<div id="challenge" markdown="1">
# Challenge: Explore the NEON San Joaquin Experimental Range Field Site

Data are often more interesting and powerful when we compare them across various 
locations. Let's compare some data collected over Harvard Forest to data collected
in Southern California. The 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >NEON San Joaquin Experimental Range (SJER) field site </a> 
located in Southern California has a very different ecosystem and climate than the
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >NEON Harvard Forest Field Site</a> in Massachusetts.  

Import the SJER DSM and DTM raster files and create a Canopy Height Model.
Then compare the two sites. Be sure to name your `R` objects and outputs carefully,
as follows: objectType_SJER (e.g. `DSM_SJER`). This will help you keep track of  
data from different sites!

1. Import the DSM and DTM from the SJER directory (If you didn't aready import
them in the [Plot Raster Data in R]({{ site.baseurl}}/R/Plot-Rasters-In-R/)
lesson.) Don't forget to examine the data for `CRS`, bad values, etc. 
 2. Create a `CHM` from the two raster layers and check to make sure the data are 
what you expect. 
3. Plot the `CHM` from SJER. 
4. Export the SJER CHM as a `GeoTIFF`.
5. Compare the vegetation structure of the Harvard Forest and San Joaquin 
Experiemental Range.
Hint: plotting SJER and HARV data side-by-side is an effective way to compare both
datasets!

</div>

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-SJER-CHM-1.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-SJER-CHM-2.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-SJER-CHM-3.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-SJER-CHM-4.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations-In-R/challenge-code-SJER-CHM-5.png) 

What do these two histograms tell us about the vegetation structure at Harvard 
and SJER?
