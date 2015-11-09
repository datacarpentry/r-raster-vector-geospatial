---
layout: post
title: "Lesson 01: Plot Rasters in R"
date:   2015-10-28
authors: [Kristina Riemer, Jason Williams, Jeff Hollister, Mike Smorul, 
Zack Brym, Leah Wasser]
dateCreated:  2015-10-23
lastModified: 2015-11-09
category: spatio-temporal-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This post explains the simple plotting function in the `raster` package."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Plot-Rasters-In-R.R
comments: false
---

{% include _toc.html %}

##About
This post explains the simple plotting function in the `raster` package.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will know:

* what a raster band is
* how to plot a single band raster in R

###Things You'll Need To Complete This Lesson


###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

####Tools To Install

Please be sure you have the most current version of `R` and preferably
R studio to write your code.


####Data to Download

Download the workshop data:

* <a href="http://figshare.com/articles/NEON_AOP_Hyperspectral_Teaching_Dataset_SJER_and_Harvard_forest/1580086" class="btn btn-success"> DOWNLOAD Sample NEON LiDAR data in Raster Format & Vegetation Sampling Data</a>


The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the Harvard and San Joaquin field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the NEON website.

####Recommended Pre-Lesson Reading

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

</div>



    # Plot raster file and change some parameters
    plot(DSM) #Necessary to explicitly differentiate between base plot and raster plot?

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/pseudo-code-1.png) 

    pixels <- ncol(DSM) * nrow(DSM)
    hist(DSM, col = "blue", maxpixels = pixels)

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/pseudo-code-2.png) 

    myCol <- terrain.colors(10)
    plot(DSM, 
         breaks = c(320, 340, 360, 380, 400), 
         col = myCol,
         maxpixels = pixels) #optional argument

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/pseudo-code-3.png) 

    plot(DSM, 
         zlim = c(340, 400)) #optional argument

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/pseudo-code-4.png) 

    #`image` v. `plot`
    # TODO: challenge


##Plotting raster files
We should already be familiar with the DSM Harvard raster file because it has been
opened in the first raster lesson, Raster Structure. We will now plot this raster and the histogram of the raster values to get an idea of what the raster is like.  


    #Plot entire raster
    plot(DSM)

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/hist-raster-1.png) 

    #Plot distribution of raster values, get an error cause only plots subset
    hist(DSM)

    ## Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...):
    ## 4% of the raster cells were used. 100000 values used.

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/hist-raster-2.png) 

    pixels = ncol(DSM) * nrow(DSM)
    hist(DSM, maxpixels = pixels)

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/hist-raster-3.png) 

We can also use some arguments for the plot function to plot a subset of the raster values or choose which values correspond to which plot colors. 


    #Plot a subset of the pixel values, e.g., the bottom 50m of surface
    plot(DSM, zlim = c(305, 355))

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/breaks-zlim-1.png) 

    #Plot all pixel values using broader categories for values
    myCol = terrain.colors(4)
    
    plot(DSM, 
         breaks = c(305, 341, 377, 416), 
         col = myCol, 
         maxpixels = pixels)

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/breaks-zlim-2.png) 

Lastly, like most plots, we can add labels.


    #Add axes and title to raster plot
    plot(DSM, 
         xlab = "X Coordinates", 
         ylab = "Y Coordinates", 
         main = "Harvard Forest Digital Surface Model")

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/add-plot-title-1.png) 

##Challenge

Create a plot of the Harvard DSM that has a legend with six colors that are evenly divided amongst the range of pixel values. 


#Overlaying rasters

Sometimes you want to overlay a raster on another raster and use a transparency 
to give it texture. The most common approach to this is to use a `HILLSHADE` as the 
base raster layer. A hillshade is simply a raster that maps the shadows and texture
that you would see from above when viewing terrain. It gives data a nice "3 dimensional" 
appearance. You might then overlay another raster on top. Let's overlay the
DSM on top of a `hillshade` of the DSM.


    #import DSM hillshade
    hill <- raster("NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif")
    
    #	Plot hillshade using a grayscale color ramp 
    plot(hill,
        col=grey(1:100/100),
        legend=F,
        main="NEON Hillshade - DSM\n Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/01-Plot-Raster/overlaying-hillshade-1.png) 

Overlay the DSM raster on top of the hillshade.


    #overlay the DSM on top of the hillshade
    plot(DSM,
         col=rainbow(100),
         alpha=0.4,
         add=T,
         legend=F)

    ## Error in graphics::rasterImage(x, e[1], e[3], e[2], e[4], interpolate = interpolate): plot.new has not been called yet

