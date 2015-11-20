---
layout: post
title: "Lesson 01: Plot Raster Data in R"
date:   2015-10-28
authors: [Kristina Riemer, Jason Williams, Jeff Hollister, Mike Smorul, 
Zack Brym, Leah Wasser]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-11-20
category: spatio-temporal-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson reviews how to plot a raster in R using the plot() 
command. It also covers how to overlay a raster on top of a hillshade for a 
eloquent map.
output."
code1: Plot-Rasters-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Plot-Rasters-In-R
comments: false
---

{% include _toc.html %}

##About
This lesson reviews how to use the `plot` function in `R` to plot raster data.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will:

* Be able how to plot a single band raster in R.
* Be able to layer a raster dataset on top of a hillshade to create an elegant 
basemap.

###Things You'll Need To Complete This Lesson
You will need the most current version of R, and preferably RStudio, loaded on
your computer to complete this lesson.

###R Libraries to Install:

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


##Plot Raster Data in R
In [Lesson 00 - Intro to Raster Data in R]({{ site.baseurl}}/R/Introduction-to-Raster-Data-In-R/) we explored the Digital Surface Model for Harvard Forest. In this lesson, we will
plot this raster. We will use the `hist` function as a tool to explore raster 
values and render it using `breaks` or bins that are meaningful in our data. We 
will continue to use the `raster` and `rgdal` libraries in this lesson.


    #if they are not already loaded
    library(rgdal)
    library(raster)
First, let's plot our Digital Surface Model object (`DSM_HARV`) using the `plot`
function. We add a title using `main=""`.


    #Plot raster object
    plot(DSM_HARV,
         main="NEON Digital Surface Model\nHarvard Forest Field Site")

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/hist-raster-1.png) 

# Plotting Data Using Breaks

Often we may want to view our data subsetted by a range of values rather than
using a continuous color ramp. This is comparable to a "classified" map in a tool
like ArcGIS or QGIS.

To begin we want use the histogram of our data to determine where the breaks in 
our data should go. When can use `breaks=` to tell `R` to use fewer or more breaks
or bins in our histogram. More on that below:

> R Bloggers Histogram Overview: <a href="http://www.r-bloggers.com/basics-of-histograms/" target="_blank">More 
on histograms in R</a>


    #Plot distribution of raster values 
    hist(DSM_HARV,
         breaks=2,
         main="Histogram Digital Surface Model\nHarvard Forest Field Site")

    ## Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...):
    ## 4% of the raster cells were used. 100000 values used.

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/create-histogram-2-breaks-1.png) 

Looking at our histogram, R has binned out the data as follows:

* 300-350m, 350-400m, 400-450m

We can use those bins to plot our raster data. We will use the `terrain.colors(3)`
`R` function to create a palette of 3 colors to use in our plot. We can use the 
`breaks` method to add breaks. Breaks requires a list of numbers formatted as 
follows:

`c(value1,value2,value3)`

You can include as many or as few breaks as you'd like but you need atleast 3 
breaks to create a plot of any value.


    #Create a color palette of 3 colors
    myCol = terrain.colors(3)
    
    #plot using breaks.
    plot(DSM_HARV, 
         breaks = c(300, 350, 400, 450), 
         col = myCol,
         main="NEON Digital Surface Model\nHarvard Forest Field Site")

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/plot-with-breaks-1.png) 

We can label the X and Y axis of our plot too. 


    #Add axes and title and subtitle to raster plot
    plot(DSM_HARV, 
         breaks = c(300, 350, 400, 450), 
         col = myCol,
         main="NEON Digital Surface Model", 
         xlab = "X Coordinates (m)", 
         ylab = "Y Coordinates (m)")

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/add-plot-title-1.png) 

We can also turn off the plot axes. 


    #or we can turn off the axis altogether
    plot(DSM_HARV, 
         breaks = c(300, 350, 400, 450), 
         col = myCol,
         main="NEON Digital Surface Model\nHarvard Forest Field Site", 
         axes=FALSE)

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/turn-off-axes-1.png) 

>##Challenge
>
>Create a plot of the Harvard DSM that has a legend with six colors that are 
>evenly divided amongst the range of pixel values. 



#Layering One Raster on Top of Another 

Sometimes we want to layer a raster on top of another raster and use a transparency
to give it texture. The most common approach to this is to use a `HILLSHADE` as
the base raster layer. A hillshade is simply a raster that maps the shadows and 
texture that you would see from above when viewing terrain. It gives the data a 
nice 3D appearance. 


    #import DSM hillshade
    hill_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif")
    
    #plot hillshade using a grayscale color ramp that looks like shadows.
    plot(hill_HARV,
        col=grey(1:100/100),  #create a color ramp of grey colors
        legend=F,
        main="NEON Hillshade - DSM\n Harvard Forest",
        axes=FALSE)

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/hillshade-1.png) 

Now that we have the hillshade we might then overlay another raster on top by
using `add=TRUE`. Let's overlay `DSM` on top of a `hillshade` of the DSM.


    #plot hillshade using a grayscale color ramp that looks like shadows.
    plot(hill_HARV,
        col=grey(1:100/100),  #create a color ramp of grey colors
        legend=F,
        main="NEON Hillshade - DSM\n Harvard Forest",
        axes=FALSE)
    
    #add the DSM on top of the hillshade
    plot(DSM_HARV,
         col=rainbow(100),
         alpha=0.4,
         add=T,
         legend=F)

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/overlay-hillshade-1.png) 

Note that here we used the color palete `rainbow()` instead of `terrain.color()`.

>##Challenge
>Use the files in the `NEON_RemoteSensing/SJER/` to create a map of the SJER DTM
>layered on top of the SJER DTM hillshade. Then create a map of the SJER DSM layered
>on top of the SJER DSM. Experiment with various <a href="https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/palettes.html" target="_blank">R color palettes</a>
>when you make your maps.

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/challenge-plots-1.png) ![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/challenge-plots-2.png) 

