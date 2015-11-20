---
layout: post
title: "Lesson 05: Raster Time Series Data in R"
date:   2015-10-24
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym,
Leah Wasser]
contributors: [Test Human]
packagesLibraries: [raster, rgdal, rasterVis]
dateCreated:  2014-11-26
lastModified: 2015-11-20
category: time-series-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson covers how to work with a raster time series, using the
R RasterStack object. It also covers how practical assessment of data quality in
Remote Sensing derived imagery. Finally it covers pretty raster time series plotting 
using the RasterVis library."
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
* How to work with a set of time series rasters. How to efficiently import a set of 
rasters in a single directory.
* How to plot and explore time series raster data using the `plot` function.
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

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
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

In this lesson, we will use the `raster`, `rgdal` and `rasterVis` libraries.


    library(raster)
    library(rgdal)
    library(rasterVis)

#About the Time Series Data

In this lesson, we are working with a set of rasters, that were derived from the 
Landsat satellite - in `GeoTiff` format. Each
raster covers part of the  <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>.

##NDVI data
The first set of rasters, located in the `Landsat_NDVI\HARV\ndvi` is the Normalized
Difference Vegetation Index (NDVI). NDVI is a quantitative index of greeness ranging
from 0-1 where 0 is the least amount of greenness and 1 is maximum greenness following 
the index. NDVI is often used for a quantative measure of vegetation health, cover
and vegetation phenology (life cycle stage) over large areas. 
The NDVI data is a derived single band product saved as a `geotiff` for different
times of the year. 

* <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/measuring_vegetation_2.php" target="_blank">More on NDVI from NASA</a>

<figure>
 <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/Images/ndvi_example.jpg"><img src="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/Images/ndvi_example.jpg"></a>
    <figcaption>NDVI is calculated from the visible and near-infrared light reflected by vegetation. Healthy vegetation (left) absorbs most of the visible light that hits it, and reflects a large portion of the near-infrared light. Unhealthy or sparse vegetation (right) reflects more visible light and less near-infrared light. FIGURE AND CAPTION CREDIT: NASA </figcaption>
</figure>


##RGB data
While the NDVI data is a single band product, the RGB images represent 3 of the 
7 30m resolution bands available on Landsat. The RGB directory contains RGB
images (3 band) for each time period that NDVI is available.


##Understanding the metadata
?? we could teach this but Leah would need to rename the files to the original
names -- thoughts?

##Goals

In this lesson, we will

1. Import NDVI data derived from the Landsat Sensor in raster (`geotiff`) format
2. Plot one full year of NDVI raster time series data. 
3. Generate an average NDVI value for each time period throughout the year.

<figure>
    <a href="{{ site.baseurl }}/images/GreenessOverTime.png">
    <img src="{{ site.baseurl }}/images/GreenessOverTime.png"></a>
    <figcaption>A raster dataset can also contain a time series. In R, a stack of rasters 
    will be in the same extent, CRS and resolution.</figcaption>
</figure>

##Getting Started 

To begin, we will create a list of raster file names that can be used to
generate a `RasterStack`. We can use `list.files` to generate the list. We will 
tell R to only find files with a `.tif` extention using the syntax `pattern=".tif$"`.

If we specify `full.names=TRUE`, the full path for each file will be added to the 
list. We will be able to create a `RasterStack` directly from the list.

Note that the full path is relative to the working directory that was set.
{: .notice }


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

Now we have a list of all `geotiff` files in the `ndvi` directory for Harvard Forest.
Once we have this list, we can create a stack and begin to work with the
data. 

We can also explore the `geotiff` tags (the embedded metadata) to learn more about
key metadata about our data including `Coordinate Reference System (CRS)`, 
`extent` and raster `resolution`.


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

    #view the y resolution of our rasters
    yres(NDVI_stack)

    ## [1] 30

    #view the x resolution of our rasters
    xres(NDVI_stack)

    ## [1] 30

> ##Challenge
> 
> Before you go any further, answer the following questions about our `RasterStack`.
> 
> 1. What is the `CRS`?
> 2. What is the `resolution` of the data? And what `units` is that resolution in?

#Plotting Time Series Data

Once we have created our `RasterStack`, we can visualize our data. Remember 
from a previous lesson, that we can use the `plot` command to quickly plot a `RasterStack`.



    #view a histogram of all of the rasters
    #nc specifies number of columns
    plot(NDVI_stack, 
         zlim = c(1500, 10000), 
         nc = 4)

![ ]({{ site.baseurl }}/images/rfigs/05-Time-Series-Raster/plot-time-series-1.png) 


Note: we can make the `levelplot` even prettier by fixing the individual tile
names. We will cover this in 
[Lesson 06 - Plot Time Series Rasters in R ]({{ site.baseurl }}/R/Plot-Raster-Times-Series-Data-In-R/)
{ : .notice }

##Taking a Closer Look at Our Data

Let's take a close look at the plots of our data. Given what you might know 
about the seasons in Massachusettes (where Harvard Forest is located), do you 
notice anything that seems unusual about the patterns of greening and browning 
of the vegetation atthe site?

What is another way we can look at these data that is a bit more quantitative 
than viewing images? 


    #create histogram
    hist(NDVI_stack, 
         xlim = c(0, 10000))

![ ]({{ site.baseurl }}/images/rfigs/05-Time-Series-Raster/view-stack-histogram-1.png) 

It seems like things get green, but the data at Julian days 277 and 293 are 
unusual. It appears as if the vegetation got green in the spring, but then died
back and then got green again towards the end of the year. Is this right?

###Exploring Unusual Data Patterns
A plot of daily temperature for 2014 is below. There are no significant peaks
or dips in the temperature during the late summer / early fall time period that 
might cause the vegetation to brown and then quickly green again the following 
month. 

What is happening here? 

![ ]({{ site.baseurl }}/images/rfigs/05-Time-Series-Raster/view-temp-data-1.png) 

The temperature data suggests that the pattern of warming and cooling is fairly
consistent. Maybe we should look at the 3-band RGB imagery to see what that looks like, next. The RGB imagery are located in the `RGB` directory. 

#CHALLENGE

> Open up the RGB images from Julian dates 277 and 293. What do you see?


#View All Landsat RGB images for Harvard Forest 2011

![ ]({{ site.baseurl }}/images/rfigs/05-Time-Series-Raster/view-all-rgb-1.png) 

