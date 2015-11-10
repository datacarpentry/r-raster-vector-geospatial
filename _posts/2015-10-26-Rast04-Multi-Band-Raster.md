---
layout: post
title: "Lesson 04: Work With Multi-Band Rasters - Images in R"
date:   2015-10-25
authors: [Kristina Riemer, Mike Smorul, Zack Brym, Jason Williams, Jeff Hollister, Leah Wasser]
contributors: [Test Human]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-11-10
category: spatio-temporal-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This lesson explores how to import and plot a multi-band raster in R.
It also covers how to plot a 3 band color image plotRGB command in R"
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Multi-Band-Rasters-In-R
comments: false
---

{% include _toc.html %}


##About
This lesson will explore how to work with multi-band raster data in R.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this activity, you will know:

* How a raster file stores multiple bands.
* How to import multi-band rasters into `R` using the `raster` library.
* How to plot multi-band rasters in `R`.

###Things You'll Need To Complete This Lesson

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`


####Tools To Install

Please be sure you have the most current version of `R` and preferably
R studio to write your code.


####Data to Download

* <a href="http://files.figshare.com/2387965/NEON_RemoteSensing.zip" class="btn btn-success"> DOWNLOAD Sample NEON Raster Data for Harvard Forest & SJER</a>

The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the Harvard and San Joaquin field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the NEON website.  

####Recommended Pre-Lesson Reading

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

</div>

#About Raster Bands

As discussed in the [Intro to Raster Data Lesson 00]( {{ base.url }} }}/R/Introduction-to-Raster-Data-In-R), a raster can contain 1 or more bands. To 
work with multi-band rasters, we need to adjust how we import and plot our data. 

* To import multi band raster data we will use the `stack` function.
* If our multi-band data are imagery that we wish to composit, we can use `plotRGB` 
to plot a 3 band image raster.

#About Multi Band Imagery
A raster dataset can store multiple bands. One multi-band raster dataset that is  familiar to many of us is an image. A basic color image consists of three bands:
red, green and blue. The pixel brightness for each band, when composited creates
the colors that we see in an image.

####we can plot each band of an 3 band image individually

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/demonstrate-RGB-Image-1.png) 

####Or we can composite all three bands together to make a color image.

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-RGB-now-1.png) 

    ## Warning in par(original_par): graphical parameter "cin" cannot be set

    ## Warning in par(original_par): graphical parameter "cra" cannot be set

    ## Warning in par(original_par): graphical parameter "csi" cannot be set

    ## Warning in par(original_par): graphical parameter "cxy" cannot be set

    ## Warning in par(original_par): graphical parameter "din" cannot be set

    ## Warning in par(original_par): graphical parameter "page" cannot be set

#Other Types of Multi-band Raster data

Multi-band raster data might also contain:

1. Time series - of the same variable, over the same area over time.
2. Multi-hyperspectral imagery - that might have 4 or more bands up to 400+ bands 
of image data!

NOTE: In a multi-band dataset, the rasters will always have the same `extent`,
`CRS` and `resolution`.
{: .notice }

In this lesson, the multi-band data that we are working with is imagery
collected using the NEON Airborne Observation Platform high resolution camera over
the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>. 


#Getting Started with Multi-Band data
If we read a raster stack into R using the `raster` function, it defaults to 
reading in one (the first) band. We can plot this band using the plot function.

In a typical GIS application, a single band would render a single image 
band using a grayscale color palette. We will thus use a grayscale palette to render
individual bands below.
{: .notice }


    # Read in multi-band raster with raster function, the default is the first band
    RGB_band1 <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")
    
    #create a grayscale color palette to use for the image
    grayscale_colors <- gray.colors(100, 
                                    start = 0.0, 
                                    end = 1.0, 
                                    gamma = 2.2, 
                                    alpha = NULL)
    
    #Point out dimension, CRS, and values attributes, but esp. band
    plot(RGB_band1, 
         col=grayscale_colors(100), 
         main="NEON RGB Imagery - Band 1\nHarvard Forest") 

    ## Error in .asRaster(x, col, breaks, zrange, colNA, alpha = alpha): could not find function "grayscale_colors"

    #view attributes
    RGB_band1

    ## class       : RasterLayer 
    ## band        : 1  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho 
    ## values      : 0, 255  (min, max)

Note that when we look at the attributes of RGB_Band1, we see :

`band: 1  (of  3  bands)`

This is R telling us that this particular raster object has more bands associated with it!

##Raster Data Values - Images

Take careful note of the min and max values of our raster min and max values:


    #view min value
    minValue(RGB_band1)

    ## [1] 0

    #view max value
    maxValue(RGB_band1)

    ## [1] 255

What do you notice about the min and max values? Image data is different from other
raster data in that to produce an image, you will have color values between 0 and 255.
These values represent degrees of brightness associated with the band color being
viewed. In the case of a RGB image (red, green and blue), band 1 is the red band. 
Thus when you plot that band, larger numbers (towards 255) represent pixels with 
more `red` in them. Smaller numbers (towards 0) represent pixels with `less red`
in them. To plot an RGB image, we mix red + green + blue into one single 
color!


#Challenge
The number of bands associated with a raster object can be determined using the 
`nbands` slot as follows `RGB_band1@file@nbands`. How many bands does our original 
raster contain? 
{: .notice }

##Import Specific Bands
We can use the raster function to import specific bands in our raster object too.
TO do that, we add `band=2` (or whatever band number we wish to import).


    # Can specify which band you want to read in
    RGB_band2 <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif", 
                        band = 2)
    
    #plot band 2
    plot(RGB_band2,
         col=grayscale_colors, 
         main="NEON RGB Imagery - Band 2\nHarvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-single-band-1.png) 

    #view attributes of band 2 
    RGB_band2

    ## class       : RasterLayer 
    ## band        : 2  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho 
    ## values      : 0, 255  (min, max)

Notice that band 2 is band 2 of 3 bands.

`band        : 2  (of  3  bands)`

#Raster Stacks in R

We have now explored several bands in a 3 band raster. Our data is a color image 
which means it has atleast 3 bands. Let's bring in all of the bands and composite 
it to create a final color RGB plot. To bring in all bands of a raster, we will use
the `stack` function.


    # Use stack function to read in all bands
    RGB_stack <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")
    
    #view attributes of stack object
    RGB_stack 

    ## class       : RasterStack 
    ## dimensions  : 2317, 3073, 7120141, 3  (nrow, ncol, ncell, nlayers)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## names       : HARV_RGB_Ortho.1, HARV_RGB_Ortho.2, HARV_RGB_Ortho.3 
    ## min values  :                0,                0,                0 
    ## max values  :              255,              255,              255

    #What is the CRS of the raster stack
    crs(RGB_stack)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #What is the extent of the raster stack
    extent(RGB_stack)

    ## class       : Extent 
    ## xmin        : 731998.5 
    ## xmax        : 732766.8 
    ## ymin        : 4712956 
    ## ymax        : 4713536

We can use `RGB_stack@layers` to view the attributes of each band in the raster
object in r. We can also use the `plot` and `hist` functions on the raster stack
to plot and view histograms of each band in the stack.


    #view raster attributes
    RGB_stack@layers

    ## [[1]]
    ## class       : RasterLayer 
    ## band        : 1  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho.1 
    ## values      : 0, 255  (min, max)
    ## 
    ## 
    ## [[2]]
    ## class       : RasterLayer 
    ## band        : 2  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho.2 
    ## values      : 0, 255  (min, max)
    ## 
    ## 
    ## [[3]]
    ## class       : RasterLayer 
    ## band        : 3  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho.3 
    ## values      : 0, 255  (min, max)

    #view attributes for one layer
    RGB_stack[[1]]

    ## class       : RasterLayer 
    ## band        : 1  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho.1 
    ## values      : 0, 255  (min, max)

    #plot one band
    plot(RGB_stack[[1]], 
         main="band one", 
         col=grayscale_colors)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-raster-layers-1.png) 

    #plot all three bands
    plot(RGB_stack, 
         col=grayscale_colors)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-raster-layers-2.png) 

#Plot A Three Band Image

We can use `plotRGB` to compositive a 3 band color raster stack into a final 
color image. This function allows us to also

1. Determine what order we want to plot the bands (We could create a color infrared
image using this function if we had an infrared band to work with)  
2. Adjust the stretch of the image to make it brighter / darker

The plotRGB function composits three bands together into one producing an image
that is similar to an image that a camera takes. 


    # Create an RGB image from the raster stack
    plotRGB(RGB_stack, 
            r = 1, g = 2, b = 3)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-rgb-image-1.png) 

    #what does stretch do?
    plotRGB(RGB_stack,
            r = 1, g = 2, b = 3, 
            scale=800,
            stretch = "Lin")

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-rgb-image-2.png) 

##Challenge - NoData Values
View the attributes of the `HARV_Ortho_wNA.tif` file located in the `NEON_RemoteSensing/HARV` 
directory using `GDALinfo()`. Are there NoData values assigned for this file? 
If so, what is the NoData Value? Open the file in R as a 3 band `RasterStack`. 
Then plot it using the `plotRGB` function. What happened to the black edges in 
the data?
{: .notice }


##Raster Brick vs Raster Stack in R
You can turn a `RasterStack` into a `RasterBrick` in `R`. A `RasterStack` is an
`R` object with multiple layers. However those layers can be stored anywhere on your computer. A `RasterBrick` contains all of the objects stored within the actual
R object. In most cases, you can work with a RasterBrick in the same way you 
might work with a stack. However a `RasterBrick` is often more efficient / faster 
to process.

<a href="http://www.inside-r.org/packages/cran/raster/docs/brick" target="_blank">More on Raster Bricks</a>

Let's use the `object.size()` function to compare a stack vs brick R object.


    #view size of the RGB_stack object that contains our 3 band image
    object.size(RGB_stack)

    ## 40528 bytes

    #convert stack to a brick
    RGB_brick <- brick(RGB_stack)
    
    #view size of the brick
    object.size(RGB_brick)

    ## 170896080 bytes

    #plot brick
    plot(RGB_brick,
         col=grayscale_colors)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/raster-bricks-1.png) 


#Challenge

You can view various methods available to call on an R object with 
`methods(class=class(objectNameHere))`. Use this to figure out what methods you
can call on the `RGB_stack` object. What methods are available for a single 
`RasterLayer`? 
{: .notice }
