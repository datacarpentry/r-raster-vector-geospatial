---
layout: post
title: "Lesson 07: Extract NDVI Summary Values from a Raster Time Series"
date:   2015-10-22
authors: [Leah Wasser, Kristina Riemer, Zack Bryn, Jason Williams, Jeff Hollister, 
Mike Smorul]
contributors: [Test Human]
packagesLibraries: [raster, rgdal]
dateCreated:  2014-11-26
lastModified: 2015-11-23
category: time-series-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson will explore a way to extract NDVI index values from a
raster time series in R and plot them using GGPLOT. Methods learned in this lesson could be applied to any 
raster time series"
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Extract-NDVI-From-Rasters-In-R/
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

* How to extract summary pixel values from a raster.
* 

###Things You'll Need To Complete This Lesson

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`


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


    library(raster)
    library(rgdal)
    library(ggplot2)

#About the Time Series Data

In this lesson, we are working with the same set of rasters that we used in 
[{{ site.baseurl}} /R/Raster-Times-Series-Data-In-R/ ](Lesson 05 - Time Series Rasters in R), 
that were derived from the Landsat satellite - in `GeoTiff` format. Each
raster covers the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>.


##Getting Started 

To begin, we will use the same raster stack that we used in the previous lesson.



    # Create list of NDVI file paths
    NDVI_path_HARV <- "Landsat_NDVI/HARV/2011/ndvi"
    all_NDVI_HARV <- list.files(NDVI_path_HARV, full.names = TRUE, pattern = ".tif$")
    
    #view list - note that the full path (relative to our working directory)
    #is included
    all_NDVI_HARV

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
    NDVI_stack_HARV <- stack(all_NDVI_HARV)

Once we have created a raster stack, we can efficiently work with our time series.

#Calculate Average NDVI

Our output goal is a dataframe that contains a single, mean NDVI value for each
raster in our time series. We can calculate the mean for each raster using the
`cellStats` function. This produces a numeric array of values.


    #calculate mean NDVI for each raster
    avg_NDVI_HARV <- cellStats(NDVI_stack_HARV,mean)
    
    #convert output to data.frame
    avg_NDVI_HARV <- as.data.frame(avg_NDVI_HARV)
    
    #We can do the above two steps with one line of code
    avg_NDVI_HARV <- as.data.frame(cellStats(NDVI_stack_HARV,mean))
    
    avg_NDVI_HARV

    ##                     cellStats(NDVI_stack_HARV, mean)
    ## X005_HARV_ndvi_crop                          3651.50
    ## X037_HARV_ndvi_crop                          2426.45
    ## X085_HARV_ndvi_crop                          2513.90
    ## X133_HARV_ndvi_crop                          5993.00
    ## X181_HARV_ndvi_crop                          8787.25
    ## X197_HARV_ndvi_crop                          8932.50
    ## X213_HARV_ndvi_crop                          8783.95
    ## X229_HARV_ndvi_crop                          8815.05
    ## X245_HARV_ndvi_crop                          8501.20
    ## X261_HARV_ndvi_crop                          7963.60
    ## X277_HARV_ndvi_crop                           330.50
    ## X293_HARV_ndvi_crop                           568.95
    ## X309_HARV_ndvi_crop                          5411.30

Let's explore our output `data.frame`. Each row has a name corresponding with the
raster name in our stack


    #view row names for data frame
    row.names(avg_NDVI_HARV)

    ##  [1] "X005_HARV_ndvi_crop" "X037_HARV_ndvi_crop" "X085_HARV_ndvi_crop"
    ##  [4] "X133_HARV_ndvi_crop" "X181_HARV_ndvi_crop" "X197_HARV_ndvi_crop"
    ##  [7] "X213_HARV_ndvi_crop" "X229_HARV_ndvi_crop" "X245_HARV_ndvi_crop"
    ## [10] "X261_HARV_ndvi_crop" "X277_HARV_ndvi_crop" "X293_HARV_ndvi_crop"
    ## [13] "X309_HARV_ndvi_crop"

    #view the first value in the data.frame
    avg_NDVI_HARV[1,1]

    ## [1] 3651.5

    #view column names
    names(avg_NDVI_HARV)

    ## [1] "cellStats(NDVI_stack_HARV, mean)"

    #rename the NDVI column
    names(avg_NDVI_HARV) <- "meanNDVI"
    
    #view cleaned column names
    names(avg_NDVI_HARV)

    ## [1] "meanNDVI"

We are only working with one site now, however we might want to compare several
sites worth of data. To allow us to do this, let's add a column to our `data.frame`
called "site". We can populate this with the site name.


    #add a site column to our data
    avg_NDVI_HARV$site <- "HARV"



#Extract Julian Day from row.names

We'd like to produce a plot where Julian Days is on the X axis and NDVI is on the 
Y axis. To do this, we'll need a column that is populated with Julian Day values
for each NDVI value. We can do this using several approaches. For this lesson, 
e will use `gsub` to replace the `X` and the `_HARV_ndvi_crop`.


    #note the use of | is equivalent to "or". this allows us to search for more than
    #one pattern in our text strings
    julianDays <- gsub(pattern = "X|_HARV_ndvi_crop", #the pattern to find 
                x = row.names(avg_NDVI_HARV), #the object containing the strings
                replacement = "") #what to replace each instance of the pattern with
    
    #make sure output looks ok
    head(julianDays)

    ## [1] "005" "037" "085" "133" "181" "197"

    #add julianDay values as a column in the dataframe
    avg_NDVI_HARV$julianDay <- julianDays
    
    #what class is the new column
    class(avg_NDVI_HARV$julianDay)

    ## [1] "character"

    #convert julian days into a time class
    #avg_NDVI_HARV$julianDay <- as.POSIXlt(avg_NDVI_HARV$julianDay, format="%j")
    
    #the code above does weird things. for one i think jday is 0 based indexing
    #but also it seems to want a year and defaults to 2015. i am not sure how to force 
    #it to 2011 which is when the data were collected
    #being lazy and useing int for the time being.
    avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)
    
    # Parse that character vector
    #strptime(date_info, "%Y %j")

#Scale Data
The last thing that we need to do it so scale our data. Valid NDVI values range 
between 0-1. The metadata included a `ScaleFactor`. NDVI data are scaled by a 
factor of 10,000. A scale factor is commonly used in larger datasets. Storing decimal
places actually consumes more space and creates larger file sizes compared to 
storing integer values.


    #scale data by 10,000
    avg_NDVI_HARV$meanNDVI <- avg_NDVI_HARV$meanNDVI / 10000
    #view output
    head(avg_NDVI_HARV)

    ##                     meanNDVI site julianDay
    ## X005_HARV_ndvi_crop 0.365150 HARV         5
    ## X037_HARV_ndvi_crop 0.242645 HARV        37
    ## X085_HARV_ndvi_crop 0.251390 HARV        85
    ## X133_HARV_ndvi_crop 0.599300 HARV       133
    ## X181_HARV_ndvi_crop 0.878725 HARV       181
    ## X197_HARV_ndvi_crop 0.893250 HARV       197

#Plot NDVI Using GGPLOT

We now have a clean `data.frame` with properly scaled NDVI and julian days.
Let's plot our data.


    #plot NDVI
    ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI)) +
      geom_point(size=4,colour = "blue") + 
      ggtitle("NDVI for HARV 2011\nLandsat Derived") +
      xlab("Julian Days") + ylab("Mean NDVI") +
      theme(text = element_text(size=20))

![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/plot-data-1.png) 

> ##Challenges
>
> 1. Customize your final ggplot output. Change the color of the data points
> 2. Calculate average NDVI for all rasters in the Landsat_NDVI/SJER/2013/ndvi
> directory. Then create a plot that renders BOTH sites as a comparison.



![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/challenge-answers-1.png) 

