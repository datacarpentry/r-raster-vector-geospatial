---
layout: post
title: "Lesson 04: Work With Multi-Band Rasters - Image Data in R"
date:   2015-10-25
authors: [Kristina Riemer, Mike Smorul, Zack Brym, Jason Williams, Jeff Hollister, Leah Wasser]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-12-14
category: spatio-temporal-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson explores how to import and plot a multi-band raster in
R. It also covers how to plot a three-band color image using the `plotRGB()`
function in R"
code1: SR04-Multi-Band-Rasters-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: R/Multi-Band-Rasters-In-R
comments: false
---

{% include _toc.html %}


##About
This lesson explores how to import and plot a multi-band raster in
R. It also covers how to plot a three-band color image using the `plotRGB()`
function in R"

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this activity, you will:

* Know how to identify a single vs. a multi-band raster file.
* Be able to import multi-band rasters into `R` using the `raster` package.
* Be able to plot multi-band color image rasters in `R` using `plotRGB()`.
* Understand what a NoData value is in a raster.

###Challenge Code
Throughout the lesson we have Challenges that reinforce learned skills. Possible
solutions to the challenges are not posted on this page, however, the code for 
each challenge is in the `R` code that can be downloaded for this lesson (see 
footer on this page).

###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and, preferably,
RStudio to write your code.

####R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

####Data to Download
Download the raster files teaching dataset:

<a href="https://ndownloader.figshare.com/files/3579867" class="btn btn-success"> Download NEON Airborne Observation Platform Raster Data Teaching Subset</a> 

The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard</a>
and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin</a>
field sites and processed at
<a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the 
<a href="http://www.neoninc.org/data-resources/get-data/airborne-data" target="_blank"> NEON airborne data website.</a>

####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a
refresher on setting the working directory, please view the [Setting A Working Directory In R]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") 
lesson prior to beginning this lesson.

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

###Sources of Additional Information
<a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>
</div>

#About Raster Bands in R 
As discussed in the [Intro to Raster Data Lesson]( {{ base.url }} }}NEON-R-Spatial-Raster/R/Introduction-to-Raster-Data-In-R), 
a raster can contain 1 or more bands.

<figure>
    <a href="{{ site.baseurl }}/images/raster_timeseries/single_multi_raster.png">
    <img src="{{ site.baseurl }}/images/raster_timeseries/single_multi_raster.png"></a>
    <figcaption>A raster dataset can contain one or more bands. We can use the
    raster function to import one single band from a single OR multi-band
    raster.  Image Source: NEON, Inc.</figcaption>
</figure>

To work with multi-band rasters in R, we need to change how we import and plot
our data in several ways. 

* To import multi band raster data we will use the `stack()` function.
* If our multi-band data are imagery that we wish to composite, we can use
`plotRGB()` (instead of `plot`) to plot a 3 band raster image.

#About Multi-Band Imagery
A raster dataset can store multiple bands. One type of multi-band raster dataset
that is familiar to many of us is a color image. A basic color image consists of
three bands: red, green, and blue. The pixel brightness for each band, when 
composited creates the colors that we see in an image. 

<figure>
    <a href="{{ site.baseurl }}/images/raster_timeseries/RGBSTack_1.png">
    <img src="{{ site.baseurl }}/images/raster_timeseries/RGBSTack_1.png"></a>
    <figcaption>A color image consists of 3 bands - red, green and blue. When
    rendered together in a GIS, or even a tool like Photoshop or any other
    image software, they create a color image. Image Source: NEON,Inc.  
    </figcaption>
</figure>

We can plot each band of a multi-band image individually. 

Note: In many GIS applications, a single band would render as a single image in 
grayscale. We will therefore use a grayscale palette to render individual
bands. {: .notice2}

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/demonstrate-RGB-Image-1.png) 

Or we can composite all three bands together to make a color image.

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/plot-RGB-now-1.png) 

In a multi-band dataset, the rasters will always have the same extent,
CRS and resolution.  



Want to learn more? The video below, covers the basics of what a multi-band 
images are:

<iframe width="560" height="315" src="https://www.youtube.com/embed/3iaFzafWJQE" frameborder="0" allowfullscreen></iframe>

#Other Types of Multi-band Raster Data

Multi-band raster data might also contain:

1. Time series: same variable, over the same area, over time. Check out 
[Raster Time Series Data in R ]({{ site.baseurl}}/R/Raster-Times-Series-Data-In-R/) to learn more about time series stacks.
2. Multi-hyperspectral imagery: rasters that have 4 or more (even 400+) bands 
image data! Check out the 
<a href="http://neondataskills.org/HDF5/Imaging-Spectroscopy-HDF5-In-R/" target="_blank">
NEON Data Skills Imaging Spectroscopy HDF6 in R lesson.</a>

#Getting Started with Multi-Band Data in R
To work with multi-band raster data we will use the `raster` and `rgdal`
libraries.


    library(raster)
    library(rgdal)

In this lesson, the multi-band data that we are working with is imagery
collected using the <a href="http://http://www.neoninc.org/science-design/collection-methods/airborne-remote-sensing" target="_blank">NEON Airborne Observation Platform</a> high resolution camera over
the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>. 
Each RGB images is a 3-band raster. However the same steps would apply to 
working with a multi-spectral image with 4 or more bands - like 
Landsat.

If we read a `rasterStack` into R using the `raster` function, it defaults to 
reading in just the first band. We can plot this band using the plot function. 


    # Read in multi-band raster with raster function. 
    #Default is the first band only.
    RGB_band1_HARV <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")
    
    #create a grayscale color palette to use for the image.
    grayscale_colors <- gray.colors(100,            #how many different color levels 
                                    start = 0.0,    #how black (0) to go
                                    end = 1.0,      #how white (1) to go
                                    gamma = 2.2,    #correction between how a digital
                                    #camera sees the world and how human eyes see it
                                    alpha = NULL)   #Null=colors are not transparent
    
    #Plot band 1
    plot(RGB_band1_HARV, 
         col=grayscale_colors, 
         main="NEON RGB Imagery - Band 1-Red\nHarvard Forest") 

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/read-single-band-1.png) 

    #view attributes: Check out dimension, CRS, resolution, values attributes, and 
    #band.
    RGB_band1_HARV

    ## class       : RasterLayer 
    ## band        : 1  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/mjones01/Documents/data/Spatio_TemporalWorkshop/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho 
    ## values      : 0, 255  (min, max)

Notice that when we look at the attributes of RGB_Band1, we see :

`band: 1  (of  3  bands)`

This is `R` telling us that this particular raster object has more bands
associated with it!

NOTE: The number of bands associated with a raster object can also be
determined using the `nbands` slot. Syntax is `ObjectName@file@nbands`, or
specifically for our file: `RGB_band1@file@nbands`.{ : .notice2 }

##Raster Data Values for Images
Take careful note of the min and max values of our raster - What do you see?


    #view min value
    minValue(RGB_band1_HARV)

    ## [1] 0

    #view max value
    maxValue(RGB_band1_HARV)

    ## [1] 255

In this raster image, we see values between 0 and 255. These values 
represent degrees of brightness associated with the band color being viewed. In 
the case of a RGB image (red, green and blue), band 1 is the red band. Thus when
we plot that band, larger numbers (towards 255) represent pixels with more red 
in them. Smaller numbers (towards 0) represent pixels with less red in them. To 
plot an RGB image, we mix red + green + blue values into one single color.

##Import A Specific Band
We can use the raster function to import specific bands in our raster object by
specifying which band we want with `band=N` where N is the number of the band
that we want to work with. If we want to import the green band we would use 
`band=2`.


    # Can specify which band we want to read in
    RGB_band2_HARV <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif", 
                        band = 2)
    
    #plot band 2
    plot(RGB_band2_HARV,
         col=grayscale_colors,   #we already created this palatte & can use it again
         main="NEON RGB Imagery - Band 2- Green\nHarvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/read-specific-band-1.png) 

    #view attributes of band 2 
    RGB_band2_HARV

    ## class       : RasterLayer 
    ## band        : 2  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/mjones01/Documents/data/Spatio_TemporalWorkshop/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho 
    ## values      : 0, 255  (min, max)

Notice that band 2 is band 2 of 3 bands `band: 2  (of  3  bands)`.  


#Challenge: Making Sense of Single Band Images
If you compare the plots of band 1 (red) and band 2 (green) you can see subtle 
differences in the image. The forest appears paler in band 2 (green). Why?  



##Raster Stacks in R
Next, we will explore working with all 3 bands using a *Raster Stack* so that we
can use the 3-band image composite it to create a final color plot in `R`. 

To bring in all bands of a multi-band raster, we use the`stack()` function.


    # Use stack function to read in all bands
    RGB_stack_HARV <- stack("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif")
    
    #view attributes of stack object
    RGB_stack_HARV

    ## class       : RasterStack 
    ## dimensions  : 2317, 3073, 7120141, 3  (nrow, ncol, ncell, nlayers)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## names       : HARV_RGB_Ortho.1, HARV_RGB_Ortho.2, HARV_RGB_Ortho.3 
    ## min values  :                0,                0,                0 
    ## max values  :              255,              255,              255

To further explore the rasters, we can use `RGB_stack_HARV@layers` to get a 
band-by-band view of the attributes of all bands in the raster object in `R` or 
specify which band we want to see attributes for.  We can also use the `plot()` 
and `hist()` functions on the `RasterStack` to view each band in the stack.


    #view raster attributes
    RGB_stack_HARV@layers

    ## [[1]]
    ## class       : RasterLayer 
    ## band        : 1  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/mjones01/Documents/data/Spatio_TemporalWorkshop/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
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
    ## data source : /Users/mjones01/Documents/data/Spatio_TemporalWorkshop/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
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
    ## data source : /Users/mjones01/Documents/data/Spatio_TemporalWorkshop/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho.3 
    ## values      : 0, 255  (min, max)

    #view attributes for one band
    RGB_stack_HARV[[1]]

    ## class       : RasterLayer 
    ## band        : 1  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/mjones01/Documents/data/Spatio_TemporalWorkshop/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho.1 
    ## values      : 0, 255  (min, max)

    #view histogram of all 3 bands
    hist(RGB_stack_HARV,
         maxpixels=ncell(RGB_stack_HARV))
    
    
    #plot all three bands separately
    plot(RGB_stack_HARV, 
         col=grayscale_colors)

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/plot-raster-layers-1.png) ![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/plot-raster-layers-2.png) 

    # revert to a single plot layout 
    par(mfrow=c(1,1)) 


#Create A Three Band Image
To render a final 3 band, color image in `R`, we use `plotRGB()`.

This function allows us to also:

1. Determine what order we want to plot the bands.  RGB assumes that the bands 
are 1=red, 2=green, and 3=blue.  However, bands may not be in that order or bands
may be of data that is outside the visible human range yet we want to plot them 
in RGB so that we can visualize it. 

2. Adjust the `stretch` of the image to make it brighter or darker. Adjusting 
the stretch can help us adjust the contrast in our image.

Let's plot our image.


    # Create an RGB image from the raster stack
    plotRGB(RGB_stack_HARV, 
            r = 1, g = 2, b = 3)

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/plot-rgb-image-1.png) 

The image above looks pretty good. We can explore whether applying a stretch to
the image might improve clarity and contrast using  `stretch="lin"` or 
`stretch="hist"`.  

<figure>
    <a href="{{ site.baseurl }}/images/raster_timeseries/imageStretch_dark.jpg">
    <img src="{{ site.baseurl }}/images/raster_timeseries/imageStretch_dark.jpg"></a>
    <figcaption>When the range of pixel brightness values is closer to 0, a darker
    image is rendered by default. We can stretch the values to extend to the full 
    0-255 range of potential values to increase the visual contrast of the image.
    </figcaption>
</figure>

<figure>
    <a href="{{ site.baseurl }}/images/raster_timeseries/imageStretch_light.jpg">
    <img src="{{ site.baseurl }}/images/raster_timeseries/imageStretch_light.jpg"></a>
    <figcaption>When the range of pixel brightness values is closer to 255, a lighter
    image is rendered by default. We can stretch the values to extend to the full 
    0-255 range of potential values to increase the visual contrast of the image.
    </figcaption>
</figure>



    #what does stretch do?
    plotRGB(RGB_stack_HARV,
            r = 1, g = 2, b = 3, 
            scale=800,
            stretch = "lin")

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/image-stretch-1.png) 

    plotRGB(RGB_stack_HARV,
            r = 1, g = 2, b = 3, 
            scale=800,
            stretch = "hist")

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/image-stretch-2.png) 


In this case, the stretch doesn't improve the clarity of our image significantly.
However sometimes it can be useful if the image contrast is low when first plotted.


##Challenge - NoData Values
To explore what happens with NoData values when using `RasterStack` and `plotRGB`
we will explore the `HARV_Ortho_wNA.tif` GeoTIFF in the `NEON_RemoteSensing/HARV`
directory.

1. View the files attributes. Are there `NoData` values assigned for this file? 
2. If so, what is the `NoData` Value? 
3. How many bands does it have?
4. Open the multi-band raster file in `R`. 
5. Plot the object as a true color image. 
6. What happened to the black edges in the data?
7. What does this tell us about the difference in the data structure between  
`HARV_Ortho_wNA.tif` and `HARV_RGB_Ortho.tif` (`R` object RGB_stack). How can you
check?

Answer the questions above using the functions we have covered so far in this
lesson.

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/challenge-code-NoData-1.png) 

Bonus: So far we've created a RasterStack from multiple bands in one GeoTIFF, 
however, we can also create a RasterStack by combining single bands from 
multiple files. We will cover this in [Lesson 05 - Raster Time Series Data in R]({{ site.baseurl }}/R/Raster-Times-Series-Data-In-R/).  

##RasterStack vs RasterBrick in R

Both `RasterStack` and `RasterBrick` are `R` objects with multiple bands. The bands 
in a `RasterStack` are stored anywhere on the computer. A 
`RasterBrick` contains all of the objects stored within the actual R object. In 
most cases, we can work with a `RasterBrick` in the same way we might work
with a `RasterStack`. However a `RasterBrick` is often more efficient and faster
to process - which is important when working with larger files.

<a href="http://www.inside-r.org/packages/cran/raster/docs/brick" target="_blank">More on Raster Bricks</a>

We can turn a `RasterStack` into a `RasterBrick` in `R` by using
`brick(StackName)`. Let's use the `object.size()` function to compare `stack` 
and `brick` `R` objects.


    #view size of the RGB_stack object that contains our 3 band image
    object.size(RGB_stack_HARV)

    ## 40528 bytes

    #convert stack to a brick
    RGB_brick_HARV <- brick(RGB_stack_HARV)
    
    #view size of the brick
    object.size(RGB_brick_HARV)

    ## 170896080 bytes

All the bands are stored within the `RasterBrick` object. Thus the object size
is much larger for a `RasterBrick` than for a `RasterStack`. 

PlotRGB can still be used for plotting bricks.


    #plot brick
    plotRGB(RGB_brick_HARV)

![ ]({{ site.baseurl }}/images/rfigs/SR04-Multi-Band-Rasters-In-R/plot-brick-1.png) 


#Challenge: What Methods Can Be Used on an Object?
We can view various methods available to call on an `R` object with 
`methods(class=class(objectNameHere))`. Use this to figure out:

1. What methods can be used to call on the `RGB_stack_HARV` object? 
2. What methods are available for a single band within `RGB_stack_HARV`? 
3. Why do you think there is a difference? 



