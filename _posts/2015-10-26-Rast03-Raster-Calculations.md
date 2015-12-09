---
layout: post
title: "Lesson 03: Raster Calculations in R"
date:   2015-10-26
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym, Leah Wasser]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-11-23
category: spatio-temporal-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson covers how to use the overlay function in R to perform
efficient raster calculations. It also explains the basic principles of writing
functions in R."
code1: Raster-Calculations-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Raster-Calculations-In-R
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

Download the raster files for the Harvard Forest dataset:

<a href="http://files.figshare.com/2434040/NEON_RemoteSensing.zip" class="btn btn-success"> DOWNLOAD Sample NEON Airborne Observation Platform Raster Data</a> 

The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard</a> and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin</a> field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the 
<a href="http://www.neoninc.org/data-resources/get-data/airborne-data" target="_blank"> NEON 
website.</a>

####Recommended Pre-Lesson Reading

<a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

####Raster Lesson Series 
This lesson is a part of a series of raster data in R lessons:

* [Lesson 00 - Intro to Raster Data in R]({{ site.baseurl}}/R/Introduction-to-Raster-Data-In-R/)
* [Lesson 01 - Plot Raster Data in R]({{ site.baseurl}}/R/Plot-Rasters-In-R/)
* [Lesson 02 - Reproject Raster Data in R]({{ site.baseurl}}/R/Reproject-Raster-In-R/)
* [Lesson 03 - Raster Calculations in R]({{ site.baseurl}}/R/Raster-Calculations-In-R/)
* [Lesson 04 - Work With Multi-Band Rasters - Images in R]({{ site.baseurl}}/R/Multi-Band-Rasters-In-R/)
* [Lesson 05 - Raster Time Series Data in R]({{ site.baseurl}}/R/Raster-Times-Series-Data-In-R/)
* [Lesson 06 - Plot Raster Time Series Data in R Using RasterVis and LevelPlot]({{ site.baseurl}}/R/Plot-Raster-Times-Series-Data-In-R/)
* [Lesson 07- Extract NDVI Summary Values from a Raster Time Series]({{ site.baseurl}}/R/Extract-NDVI-From-Rasters-In-R/)
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
    <figcaption>A canopy height model represents the difference between the digital 
    surface model and a digital terrain model. It represents the actual height 
    of the trees with the influence of elevation, removed.</figcaption>
</figure>

> * <a href="http://neondataskills.org/remote-sensing/2_LiDAR-Data-Concepts_Activity2/" target="_blank">More on LiDAR CHM, DTM and DSM here.</a>

We can calculate the difference between two rasters in two different ways:

1. by directly subtracting the two rasters in `R` using raster math

or if our rasters are large and/or the calculations we are performing are complex:

2. using the `overlay()` function.

First, we'll learn the intuitive first step of subtracting layers to create and
plot a CHM.  In the geospatial world we often call this *raster math*.



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

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/load-libraries-1.png) 

    plot(DSM_HARV,
         main="Digital Surface Model (Elevation)\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/load-libraries-2.png) 

Once the data are loaded, we can perform mathametical operations on them.
For instance, we can subtract the DTM from the DSM to create a Canopy Height
Model.


    # Raster math example
    CHM_HARV <- DSM_HARV - DTM_HARV 
    
    #plot the output CHM
    plot(CHM_HARV,
         main="NEON Canopy Height Model - Subtracted\n Harvard Forest") 

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/raster-math-1.png) 


# Canopy Height Model Values

Let's have a quick look at the range of values in our newly created Canopy
Height Model (CHM).


    hist(CHM_HARV,
         col="springgreen4",
         main="Histogram of NEON Canopy Height Model\nHarvard Forest",
         ylab="Tree Height (m)",
         xlab="Number of Pixels")

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/create-hist-1.png) 


Notice that the range of values for the output `CHM` is between 0 and 30 meters.
Does this make sense for trees in Harvard Forest?


****
#Challenge: Exploring Raster Values in CHM
As we learned in previous lessons, it's often a good idea to explore the range 
of values in a raster dataset just like we might explore a dataset that we 
collected in the field.  

1. What is the min and maximum value for the Harvard Forest Canopy 
Height Model (`CHM_HARV`) that we just created?
2. What are two ways you can check this range of data in `CHM_HARV`? 
3. What is the distribution of the pixel values in the CHM? Plot a histogram with 
6 bins instead of the default.
4. Bonus challenge: Change the color of the histogram you created 
in question 3. 
5. Plot the `CHM_HARV` raster using the breaks that make sense for the data. You 
mayb consider 3-4 breakpoints. Generate a set of colors that suites the data. Add
a title to the plot and turn off the axes.
****  
  
Next, we will perform the same calculations using a more efficient aproach - the
`overlay()` function.  


    ## [1] 0

    ## [1] 38.16998

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-code-CHM-HARV-1.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-code-CHM-HARV-2.png) 

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-plot-1.png) 



#Efficient Raster Calculations: Overlay Function
Basic raster math like we just did, is an appropriate approach to a calculation 
if

1. The rasters we are using are small in size.
2. The calculations we are performing are simple.

Raster math is intuitive and easy to code, however it is less a efficient approach 
as computation becomes more complex or as file sizes become large. The `overlay()`
function is more efficient when

1. The rasters we are using are larger in size. 
2. The rasters are stored as individual files. 
3. The computations performed are complex. 

The `overlay()` function takes two or more rasters and applies a function to
them using efficient processing methods. The syntax is

`outputRaster <- overlay(raster1, raster2, fun=functionName)`

NOTE: If the rasters are stacked and stored as `RasterStack` or `RasterBrick`
objects in R, then we should use `calc()`. `overlay()` will not work on
stacked rasters. 
{: .notice}

Let's perform the same difference between the Digital Surface Model (DSM) and the 
Digital Terrain Model (DTM) using the `overlay()` function.  


    CHM_ov_HARV<- overlay(DSM_HARV,
                          DTM_HARV,
                          fun=function(r1, r2){return(r1-r2)})
    
    plot(CHM_ov_HARV,
         main="NEON Canopy Height Model - Overlay Subtract\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/raster-overlay-1.png) 

> Bonus: A function consists of a define set of tasks performed on a input object. 
Functions are particularly usefule for tasks that need to be repeated over and over
in your code. A simplified syntax for a function in R is:
>
> `functionName <- function(variable1, variable2){WhatYouWantDone, WhatToReturn}`


#Writing Raster Files

Now that we've created a new raster, let's export the data as a `geotiff`  using
the `writeRaster` function. 

When we write this raster object to a GeoTIFF file we'll name it 
`chm_HARV.tiff` this way we know that it is a canopy height model of Harvard 
Forest. `writeRaster` will by default write the output file to your working directory
unless you specify a full file path.


    #export CHM object to new GeotIFF
    writeRaster(CHM_ov_HARV,"chm_HARV.tiff",
                format="GTiff",  #specify output format - geotiff
                overwrite=TRUE, #CAUTION if this is true, it will overwrite an existing file
                NAflag=-9999) #set no data value to -9999

In the code we specify that the format will be GTiff. Overwrite is true so that
it replaces any other file with this name. This is a useful setting so that you
can make a change to the object and then update the file by re-runing the code.
However, be careful to never accidentally re-use a name for a file that already 
exists. We are setting the NA value to -9999, the National Ecological Observatory
Network's (NEON) standard `NoData` value. 

****

> # Challenge: Explore the <a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >NEON San Joaquin (SJER) Field Site </a>

> As ecologists we may want to explore the phenology of two different sites.  The 
> <a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >NEON San Joaquin Experimental Range (SJER) field site </a> located in Southern California is very different ecosystem and climate compared to the 
>  <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >NEON Harvard Forest Field Site</a> in 
> Massachusetts.  

> Import the San Joaquin DSM and DTM raster files and create a Canopy Height Model.
> Then compare the two sites. BE sure to name your R objects and outputs carefully,
> as follows: objectType_SJER (e.g. `DSM_SJER`). This will help you keep track of 
> data from different sites!
>
> 1. Import the DSM and DTM from the SJER directory. Don't forget to examine the
data for CRS, bad values, etc. 
> 2. Create a CHM from the two raster layers and check to make sure the data are 
what you expect. 
> 3. Plot the CHM from SJER. 
> 4. Export as a GeoTIFF.
> 5. What do you notice about tree heights at the two sites?  
> Hint: plotting SJER and HARV data side-by-side would be an effective way to see the data at the same time.
>
>Compare your results with your neighbors. Do they look the same?

****


    ## class       : RasterLayer 
    ## dimensions  : 2178, 2005, 4366890  (nrow, ncol, ncell)
    ## resolution  : 1, 1  (x, y)
    ## extent      : 255693, 257698, 4109511, 4111689  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/SJER/DTM/SJER_dtmCrop.tif 
    ## names       : SJER_dtmCrop 
    ## values      : 338.93, 496.31  (min, max)

    ## class       : RasterLayer 
    ## dimensions  : 2178, 2005, 4366890  (nrow, ncol, ncell)
    ## resolution  : 1, 1  (x, y)
    ## extent      : 255693, 257698, 4109511, 4111689  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/SJER/DSM/SJER_dsmCrop.tif 
    ## names       : SJER_dsmCrop 
    ## values      : 338.96, 510.35  (min, max)

![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-code-SJER-CHM-1.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-code-SJER-CHM-2.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-code-SJER-CHM-3.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-code-SJER-CHM-4.png) ![ ]({{ site.baseurl }}/images/rfigs/03-Raster-Calculations/challenge-code-SJER-CHM-5.png) 
