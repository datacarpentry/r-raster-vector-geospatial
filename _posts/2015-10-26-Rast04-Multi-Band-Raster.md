---
layout: post
title: "Lesson 04: Work With Multi-Band Rasters - Images in R"
date:   2015-10-25
authors: [Kristina Riemer, Mike Smorul, Zack Brym, Jason Williams, Jeff Hollister, Leah Wasser]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-11-18
category: spatio-temporal-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This lesson explores how to import and plot a multi-band raster in
R. It also covers how to plot a three band color image plotRGB command in R"
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
After completing this activity, you will:

* Know how and why a raster file stores multiple bands.
* Be able to import multi-band rasters into `R` using the `raster` library.
* Be able to plot multi-band rasters in `R`.

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
</div>

#About Raster Bands

As discussed in the [Intro to Raster Data Lesson 00]( {{ base.url }} }}NEON-R-Spatial-Raster/R/Introduction-to-Raster-Data-In-R), a raster can
contain 1 or more bands. To work with multi-band rasters, we need to change how 
we import and plot our data in several ways. 

* To import multi band raster data we will use the `stack()` function.
* If our multi-band data are imagery that we wish to composite (spatial data
term essentially meaning, to view multiple bands together), we can use
`plotRGB()` to plot a 3 band image raster.

> Bonus: Bands? Layers?  While we stick to the term bands to describe the
> different components of a multi-spectral image, elsewhere you may also hear 
> the term layers to refer to the same thing. If you want a deeper understanding
> of how multi-band imagery is captured check out this video from <a 
href="https://www.youtube.com/watch?v=3iaFzafWJQE&noredirect=1" target="_blank">
> NEON #WorkWithData on Spectral Imaging.</a>

#About Multi Band Imagery
A raster dataset can store multiple bands. One multi-band raster dataset that is
familiar to many of us is an image. A basic color image consists of three bands:
red, green, and blue. The pixel brightness for each band, when composited
creates the colors that we see in an image. 

We can plot each band of a multi-band image individually. 

> Note: In many GIS applications, a single band would render as a single
> image band using a grayscale color palette. We will thus use a grayscale 
> palette to render individual bands.

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/demonstrate-RGB-Image-1.png) 

Or we can composite all three bands together to make a color image.

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-RGB-now-1.png) 

    ## Warning in par(original_par): graphical parameter "cin" cannot be set

    ## Warning in par(original_par): graphical parameter "cra" cannot be set

    ## Warning in par(original_par): graphical parameter "csi" cannot be set

    ## Warning in par(original_par): graphical parameter "cxy" cannot be set

    ## Warning in par(original_par): graphical parameter "din" cannot be set

    ## Warning in par(original_par): graphical parameter "page" cannot be set

#Other Types of Multi-band Raster Data

Multi-band raster data might also contain:

1. Time series: same variable, over the same area, over time.
2. Multi-hyperspectral imagery: that might have 4 or more bands up to 400+ bands 
of image data!

>NOTE: In a multi-band dataset, the rasters will always have the same extent,
>CRS and resolution.

In this lesson, the multi-band data that we are working with is imagery
collected using the <a href="http://http://www.neoninc.org/science-design/collection-methods/airborne-remote-sensing" target="_blank">NEON Airborne Observation Platform</a> high resolution camera over
the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>. 
These RGB images are 3-band rasters. Most of what we will do can be transferred 
to rasters with a different number of bands.

#Getting Started with Multi-Band Data
If we read a raster stack into R using the `raster` function, it defaults to 
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
         main="NEON RGB Imagery - Band 1\nHarvard Forest") 

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/read-single-band-1.png) 

    #view attributes: Check out dimension, CRS, resolution, values attributes, and 
    #band.
    RGB_band1_HARV

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

This is `R` telling us that this particular raster object has more bands
associated with it!

> Bonus: The number of bands associated with a raster object can also be
> determined using the `nbands` slot. Syntax is `ObjectName@file@nbands`, or
> specifically for our file: `RGB_band1@file@nbands`.

##Raster Data Values for Images
Take careful note of the min and max values of our raster:

    #view min value
    minValue(RGB_band1_HARV)

    ## [1] 0

    #view max value
    maxValue(RGB_band1_HARV)

    ## [1] 255

What do you notice about the min and max values? 

Image data is different from other raster data in that to produce an image, 
values between 0 and 255 are used. These values represent degrees of brightness 
associated with the band color being viewed. In the case of a RGB image (red, 
green and blue), band 1 is the red band. Thus when you plot that band, larger 
numbers (towards 255) represent pixels with more red in them. Smaller numbers 
(towards 0) represent pixels with less red in them. To plot an RGB image, we mix 
red + green + blue in varying brightnesses into one single color!

##Import A Specific Band
We can use the raster function to import specific bands in our raster object by
specifying which band we want with `band=N` where N is the number of the band
that you want.  If we want to import the green band we woudld use `band=2`.


    # Can specify which band you want to read in
    RGB_band2_HARV <- raster("NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif", 
                        band = 2)
    
    #plot band 2
    plot(RGB_band2_HARV,
         col=grayscale_colors,   #we already created this palatte & can use it again
         main="NEON RGB Imagery - Band 2\nHarvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/read-specific-band-1.png) 

    #view attributes of band 2 
    RGB_band2_HARV

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
`band: 2  (of  3  bands)`


#Challenge: Making sense of single band images
If you compare the plots of band 1 (red) and band 2 (green) you can see subtle 
differences in the image. The forest appears paler in band 2 (green). Why?  





We'd expect a *brighter* value for the forest in band 2 (green) than in 
band 1 (red) because most trees appear green. 

#Raster Stacks in R
We have now explored individual bands in a multi-band raster. Our data is a 
color image which means it has at least 3 bands (we already know it has exactly
3). Let's bring in all of the bands and composite it to create a final color RGB
plot. 

To bring in all bands of a multi-band raster, we need to use the`stack()` 
function.

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
and `hist()` functions on the raster stack to view each band in the stack.


    #view raster attributes
    RGB_stack_HARV@layers

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

    #view attributes for one band
    RGB_stack_HARV[[1]]

    ## class       : RasterLayer 
    ## band        : 1  (of  3  bands)
    ## dimensions  : 2317, 3073, 7120141  (nrow, ncol, ncell)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## names       : HARV_RGB_Ortho.1 
    ## values      : 0, 255  (min, max)

    #view histogram of all 3 bands
    hist(RGB_stack_HARV)

    ## Warning in .hist1(raster(x, y[i]), maxpixels = maxpixels, main =
    ## main[y[i]], : 1% of the raster cells were used. 100000 values used.

    ## Warning in .hist1(raster(x, y[i]), maxpixels = maxpixels, main =
    ## main[y[i]], : 1% of the raster cells were used. 100000 values used.

    ## Warning in .hist1(raster(x, y[i]), maxpixels = maxpixels, main =
    ## main[y[i]], : 1% of the raster cells were used. 100000 values used.

    #plot one band
    plot(RGB_stack_HARV[[1]], 
         main="RGB_stack Band 1", 
         col=grayscale_colors)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-raster-layers-1.png) 

    #plot all three bands separately
    plot(RGB_stack_HARV, 
         col=grayscale_colors)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-raster-layers-2.png) 

    par(mfrow=c(1,1)) # go back 1 plot at time, not 2x2.


#Create A Three Band Image
As you just saw we can't use `plot()` to combine all three bands and create a 
color image.  We can, however, use `plotRGB()` to composite a 3 band color
raster stack into a final color image. 

This function allows us to also

1. Determine what order we want to plot the bands.  RGB assumes that the bands 
are 1=red, 2=green, and 3=blue.  However, bands may not be in that order or bands
may be of data that is outside the visible human range yet we want to plot them 
in RGB so that we can visualize it. Images from infrared cameras do this with the
infrared band usually plotted as band 1, which appears red to us.  

2. Adjust the `stretch` of the image to make it brighter or darker. Stretch 
modifies the colors in the image which can increase contrast.



    # Create an RGB image from the raster stack
    plotRGB(RGB_stack_HARV, 
            r = 1, g = 2, b = 3)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-rgb-image-1.png) 

    #what does stretch do?
    plotRGB(RGB_stack_HARV,
            r = 1, g = 2, b = 3, 
            scale=800,
            stretch = "lin")

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-rgb-image-2.png) 

In the first image the forest was a nice bright green, however, seeing individual
features was a bit of the challenge.  In the second plot with `stretch="lin"`, 
the forest isn't as pretty green but individual features are easier to see. In 
the upper left corner an area of uniform green can now be differentiated into 
seperate trees or shrubs. 

>Bonus: Here we did a linear ("lin") stretch of the values. You can also stretch 
>the historgram of the values ("hist") to which may result in more contrast. 

##Challenge - NoData Values
To explore what happens with NoData values when using `RasterStack` and `plotRGB`
we will explore the `HARV_Ortho_wNA.tif` GeoTIFF in the `NEON_RemoteSensing/HARV`
directory.

1. View the files attributes. Are there NoData values assigned for this file? 
2. If so, what is the NoData Value? 
3. How many bands does it have?
4. Open the multi-band raster file in `R`. 
5. Plot the object as a true color image. 
6. What happened to the black edges in the data?
7. What does this tell us about the difference in the data structure between  
`HARV_Ortho_wNA.tif` and `HARV_RGB_Ortho.tif` (`R` object RGB_stack). How can you
check?


    ## rows        2317 
    ## columns     3073 
    ## bands       3 
    ## lower left origin.x        731998.5 
    ## lower left origin.y        4712956 
    ## res.x       0.25 
    ## res.y       0.25 
    ## ysign       -1 
    ## oblique.x   0 
    ## oblique.y   0 
    ## driver      GTiff 
    ## projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
    ## file        NEON_RemoteSensing/HARV/HARV_Ortho_wNA.tif 
    ## apparent band summary:
    ##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
    ## 1 Float64           TRUE       -9999          1       3073
    ## 2 Float64           TRUE       -9999          1       3073
    ## 3 Float64           TRUE       -9999          1       3073
    ## apparent band statistics:
    ##   Bmin Bmax     Bmean      Bsd
    ## 1    0  255 107.83651 30.01918
    ## 2    0  255 130.09595 32.00168
    ## 3    0  255  95.75979 16.57704
    ## Metadata:
    ## AREA_OR_POINT=Area

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/challenge-code-NoData-1.png) 

    ## rows        2317 
    ## columns     3073 
    ## bands       3 
    ## lower left origin.x        731998.5 
    ## lower left origin.y        4712956 
    ## res.x       0.25 
    ## res.y       0.25 
    ## ysign       -1 
    ## oblique.x   0 
    ## oblique.y   0 
    ## driver      GTiff 
    ## projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
    ## file        NEON_RemoteSensing/HARV/HARV_RGB_Ortho.tif 
    ## apparent band summary:
    ##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
    ## 1 Float64           TRUE   -1.7e+308          1       3073
    ## 2 Float64           TRUE   -1.7e+308          1       3073
    ## 3 Float64           TRUE   -1.7e+308          1       3073
    ## apparent band statistics:
    ##   Bmin Bmax Bmean Bsd
    ## 1    0  255   NaN NaN
    ## 2    0  255   NaN NaN
    ## 3    0  255   NaN NaN
    ## Metadata:
    ## AREA_OR_POINT=Area

> Bonus: So far we've created a RasterStack from multiple bands in one GeoTIFF, 
> however, you can also create a RasterStack by combining single bands from 
> multiple files. If you want to know more about how to do this, check out the 
> `Working with multiple rasters using Raster Stacks and Raster Bricks` section 
> of NEON's WorkWithData lesson <a href="http://neondataskills.org/R/Image-Raster-Data-In-R/" target="_blank" >Image Raster Data in R </a>.  

##RasterStack vs RasterBrick in R
Both `RasterStack` and `RasterBrick` are `R` objects with multiple bands. In 
`RasterStack` those bands can be stored anywhere on your computer. A 
`RasterBrick` contains all of the objects stored within the actual R object. In 
most cases, you can work with a `RasterBrick` in the same way you might work
with a `RasterStack`. However a `RasterBrick` is often more efficient and faster
to process.

<a href="http://www.inside-r.org/packages/cran/raster/docs/brick" target="_blank">More on Raster Bricks</a>

You can turn a `RasterStack` into a `RasterBrick` in `R` by using
`brick(StackName)`.  Let's use the `object.size()` function to compare `stack` 
and `brick` `R` objects.


    #view size of the RGB_stack object that contains our 3 band image
    object.size(RGB_stack_HARV)

    ## 40528 bytes

    #convert stack to a brick
    RGB_brick_HARV <- brick(RGB_stack_HARV)
    
    #view size of the brick
    object.size(RGB_brick_HARV)

    ## 170896080 bytes

Since all the bands are stored within the brick object the size is much bigger 
for a brick than for a stack.  

PlotRGB can still be used for plotting bricks.  

    #plot brick
    plotRGB(RGB_brick_HARV)

![ ]({{ site.baseurl }}/images/rfigs/04-Multi-Band-Raster/plot-brick-1.png) 


#Challenge: Methods for Calling on an Object
You can view various methods available to call on an `R` object with 
`methods(class=class(objectNameHere))`. Use this to figure out:

1) What methods can you use to call on the `RGB_stack_HARV` object? 
2) What methods are available for a single band within `RGB_stack_HARV`? 
3) Why do you think there is a difference? 


    ##   [1] !              !=             [              [[            
    ##   [5] [[<-           [<-            %in%           ==            
    ##   [9] $              $<-            addLayer       aggregate     
    ##  [13] all.equal      animate        approxNA       area          
    ##  [17] Arith          as.array       as.data.frame  as.logical    
    ##  [21] as.matrix      as.vector      bbox           boxplot       
    ##  [25] brick          bwplot         calc           cellStats     
    ##  [29] clamp          click          coerce         colSums       
    ##  [33] Compare        contourplot    coordinates    corLocal      
    ##  [37] cover          crop           crosstab       cut           
    ##  [41] cv             density        densityplot    dim           
    ##  [45] dim<-          disaggregate   dropLayer      extend        
    ##  [49] extent         extract        flip           freq          
    ##  [53] getValues      getValuesBlock getValuesFocal gplot         
    ##  [57] head           hexbinplot     hist           histogram     
    ##  [61] horizonplot    hovmoller      identifyRaster image         
    ##  [65] interpolate    intersect      is.factor      is.finite     
    ##  [69] is.infinite    is.na          is.nan         isLonLat      
    ##  [73] KML            labels         length         levelplot     
    ##  [77] levels         levels<-       log            Logic         
    ##  [81] mask           match          Math           Math2         
    ##  [85] maxValue       mean           merge          minValue      
    ##  [89] modal          mosaic         names          names<-       
    ##  [93] ncell          ncol           nlayers        nrow          
    ##  [97] origin         origin<-       overlay        pairs         
    ## [101] persp          plot           plotRGB        predict       
    ## [105] print          proj4string    proj4string<-  quantile      
    ## [109] raster         rasterize      readAll        readStart     
    ## [113] readStop       reclassify     res            resample      
    ## [117] rotate         rowSums        sampleRandom   sampleRegular 
    ## [121] scale          select         setMinMax      setValues     
    ## [125] shift          show           splom          spplot        
    ## [129] stack          stackSelect    streamplot     subs          
    ## [133] subset         Summary        summary        t             
    ## [137] tail           text           trim           unique        
    ## [141] unstack        values         values<-       vectorplot    
    ## [145] weighted.mean  which.max      which.min      writeRaster   
    ## [149] xmax           xmin           xres           xyplot        
    ## [153] ymax           ymin           yres           zonal         
    ## [157] zoom          
    ## see '?methods' for accessing help and source code

    ##  [1] [             [<-           anyDuplicated as.data.frame as.raster    
    ##  [6] barchart      boxplot       brick         cloud         coerce       
    ## [11] contourplot   coordinates   determinant   dotplot       duplicated   
    ## [16] edit          extent        extract       head          initialize   
    ## [21] isSymmetric   levelplot     Math          Math2         Ops          
    ## [26] parallel      parallelplot  raster        rasterize     relist       
    ## [31] splom         subset        summary       surfaceArea   tail         
    ## [36] trim          unique        weighted.mean wireframe     writeValues  
    ## see '?methods' for accessing help and source code

