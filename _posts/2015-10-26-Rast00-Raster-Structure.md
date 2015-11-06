---
layout: post
title: "Lesson 00: About Raster Data"
date:   2015-10-29
authors: [Kristina Riemer, Zack Brym, Jason Williams, Jeff Hollister,  Mike Smorul, Leah Wasser]
dateCreated:  2015-10-23
lastModified: 2015-11-06
category:  
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This post explains the fundamental principles, functions and metadata that you need to work with raster data in R."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Introduction-to-Raster-Data-In-R
comments: false
---

{% include _toc.html %}

##About
In this lesson, we will learn 

1. What raster data are and 
2. How to open and explore raster data and properties in `R`.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will know:

* What a raster dataset is and its fundamental attributes.
* How to explore raster attributes in `R`
* How to import rasters into `R` using the `raster` library.
* How to quickly plot a raster file in `R`

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
headquarters. The entire dataset can be accessed by request from the 
<a href="http://www.neoninc.org/data-resources/get-data" target="_blank"> NEON 
website.</a>

####Recommended Pre-Lesson Reading

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

</div>

#About Raster Data
Raster or "gridded" data are saved on a regular grid which is rendered
on a map as pixels. Each pixel contains a value that represents an area on the Earth's 
surface.

<a href="{{ site.baseurl }}/GIS-Spatial-Data/Working-With-Rasters/"> More on 
rasters here</a>. 

![COLINS IMAGE HERE ]({{ site.baseurl }}/images/raster_concept.png)

#Types of data stored as rasters

Raster data can be continuous or categorical. Continuous rasters can have a 
range of quantitative values. Some examples of continuous rasters include:

1. Precipitation maps
2. Maps of tree height derived from lidar data
3. Elevation values for a region. 

A map of elevation for Harvard Forest, derived from the NEON AOP lidar sensor
is below.

![ ]({{ site.baseurl }}/images/rfigs/00-Raster-Structure/elevation-map-1.png) 

Some rasters contain categorical data. Thus each pixel represents a class such as
a landcover class ("forest") rathen than a continual value such as temperature.
Some examples of classified maps include:

1. landcover / landuse maps
2. tree height maps classified short, medium, tall trees
3. elevation maps classified low, medium and high elevation

![ ]({{ site.baseurl }}/images/rfigs/00-Raster-Structure/classified-elevation-map-1.png) 


#What is a geotiff??
Raster data can come in many different formats. In this lesson, we will use the 
`geotiff` format which has the extension `.tif`. A `.tif` file can store metadata
or attributes about the file in embedded tags. For instance, your camera might store
a tag that describes the make and model of the camera if it saves a tiff. Or
it might save the date the image was taken. A geotiff is a standard `.tif`  
image format with addition spatial (georeferenceing) information embedded in the file
as a tag. These tags can include 

1. A Coordinate Reference System (CRS)
2. Spatial Extent
3. NoData Values 

We will talk about all of these metadata tags below.

More about tiffs

* <a href="https://en.wikipedia.org/wiki/GeoTIFF" target="_blank"> Geotiff on Wikipedia</a>
* <a href="https://trac.osgeo.org/geotiff/" target="_blank"> OSGEO Tiff documentation</a>
{: notice }

##About

In this lesson we will learn how to open a raster in `R`. We will also learn about 
the key metadata associated with rasters! We will use the `raster` and `rgdal`
libraries.



    library(raster)
    library(rgdal)

##View Raster Attributes

As mentioned above, a Geotiff contains a set of embedded tags that contain metadata
about the file. We can view those tags before we open the data in `R` using the
`GDALinfo` function. Notice a few things in the output.

1. A projection is described as a string - this format is called `proj4`
   `+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs `
2. We can se a `NoDataValue` (-9999)
3. We can tell how many `bands` the file contains (1)
4. We can view the x and y `resolution` of the data (1)
5. We can see the min and max values of the data `Bmin` and `Bmax`

This is great - we haven't yet opened the file but we already know some things
about it.

What else do you see in the attributes of our raster? Take note as we will 
explore these metadata later in the lesson.


    # view attributes before opening file
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


##Open up a raster in R

We can use the `raster` function to open a raster in R. NOTE: make sure that your 
working directory is set to the location where the NEON_RemoteSensing directory is 
located on your computer! You can use the `setwd()` to set this.


** it might be worth creating a supplementary lesson on working directories in r**


    # Load raster into r
    DSM <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")
    
    # Look at raster structure
    DSM 

    ## class       : RasterLayer 
    ## dimensions  : 1367, 1697, 2319799  (nrow, ncol, ncell)
    ## resolution  : 1, 1  (x, y)
    ## extent      : 731453, 733150, 4712471, 4713838  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/lwasser/Documents/data/1_DataPortal_Workshop/1_WorkshopData/NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif 
    ## names       : HARV_dsmCrop 
    ## values      : 305.07, 416.07  (min, max)

    #quickly plot the raster
    #note \n firces a line break in the title!
    plot(DSM, main="NEON Digital Surface Model\nHarvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/00-Raster-Structure/open-raster-1.png) 

There are several key metadata components that we need to examine when we work with 
rasters. We can see most of this information when we type the name of the raster
and hit return in R studio as we did above. Let's example the metadata more closely.

## Resolution

A raster will have horizontal (x and y) resolution. This resolution
represents the area on the ground that each pixel covers. We will need to know the
units used to calculate resolution as well. In the case of the NEON rasters, the units
are in meters. We can find this using two methods: we can look at the `CRS` string
which we will example in just a bit.

#NOTE: the units aren't in this geotiff. That is ok because we can find the units 
in the `CRS`


    #view resolution units
    crs(DSM)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

## Coordinate Reference System

The `Coordinate Reference System` or `CRS` is another important raster attribute.
The `CRS` tells R where the raster is located in geographic space. It also tells 
R what method should be used to "flatten" the raster. <<SOME LINK TO MORE ABOUT CRS>>

The CRS in this case is in a `PROJ 4` format. This means that the projection information
is strung together as a series of text elements, each of which begins with a `+`
sign. 

We'll focus on the first few components of the CRS in this lesson.

* `+proj=utm` The projection of this dataset is UTM 
* `+zone=18` If you read more about UTM, you will learn that the UTM projection 
divides up the world into zones. this data happens to be in zone 18 (Massachusettes).
* `+datum=WGS84` The datum tells us how the center point was defined to flatten the data
more on that HERE <<ADD LINK>>
* `+units=m` This is the horizontal units that the data are in. Here we see the units 
are meters. This means that if the data are 1x1 resolution, that each pixel represents
a 1 x 1 meter area on the ground.

![UTM Coordinate system](http://upload.wikimedia.org/wikipedia/en/thumb/5/57/Utm-zones.svg/720px-Utm-zones.svg.png)


#Calculate the Min and Max values for the raster

Sometimes the raster statistics including the min and max values have already been
calculated for us. Other times they have not. If they are not calculated you can
for R to calculate them using the `setMinMax` function. Once they are calculated 
you can then call them using the same `@data` syntax that we used above to look
at the units.


    #This step is unnecessary if the min max values are already calculated and 
    #stored in the tags for the raster.
    #our raster already has these values calculated!
    #DSM <- setMinMax(DSM) 
    
    #view min value
    minValue(DSM)

    ## [1] 305.07

    #view max value
    maxValue(DSM)

    ## [1] 416.07

##No Data Values in Rasters

There are two types of "bad" data values to be aware of when working with raster
data.

1. **NoData values:** These are values where no data were collected. The shape of
a raster, by default is always square or rectangular. Thus, if we have a dataset 
that has a shape that isn't square or rectangular, some pixels will have no data.
This often happens when the data were collected by an airplane which only flew some
of a particular region

###BELOW: raster data with black edges that are actually no data values
The camera did not collect data in these areas

![ ]({{ site.baseurl }}/images/rfigs/00-Raster-Structure/demonstrate-no-data-blaco-1.png) 

###BELOW: raster data with black edges assigned to no data. 

Note that R doesn't render the black edges now that `NA` values are assigned.

![ ]({{ site.baseurl }}/images/rfigs/00-Raster-Structure/demonstrate-no-data-1.png) 


If we are lucky, our geotiff file has a tag that tells us what the NoDATA value is.
If we are less lucky, we can find that information in the raster's `metadata`. 
If a NoDataValue was stored in the `geotiff` tag, when R opens up the raster,
it will assign each instance of that value to `NA` (no data in r world). Values
of `NA` will be ignored by R.

#Add no data values to geotiff, then add section looking for -9999 values and
#changing to NaN (or equivalent); there would be a challenge here, because the
#-9999 should show up as the min value


    #view raster no data value using GDAL info.
    #for our raster, all cells with a value of -9999 will assigned by R to NA
    #when we import the data
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

## Bad data values

Bad data values are different from NoData values. Sometimes a raster's metadata
will tell us a value range of values for the raster. Sometimes, we need to use
some practial scientific insight as we examine the data - just as we would for field
data. 

We can explore the range of values contained within our raster using the `hist`
function which produces a histogram.



    #view histogram of data
    hist(DSM)

    ## Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...):
    ## 4% of the raster cells were used. 100000 values used.

![ ]({{ site.baseurl }}/images/rfigs/00-Raster-Structure/view-raster-histogram-1.png) 

    #oops - the histogram has a default number of pixels that it renders
    #grab the number of pixels in the raster
    ncell(DSM)

    ## [1] 2319799

    #create histogram with all pixel values in the raster
    hist(DSM, maxpixels=ncell(DSM))

![ ]({{ site.baseurl }}/images/rfigs/00-Raster-Structure/view-raster-histogram-2.png) 

##Raster Bands

It is important to note that rasters can be either single or multi-band. If you 
remember, GDALinfo told us the `DSM` raster that we are working with only has
one band. 

By default the `raster` function only imports the first band in a raster so we can
use it for our `DSM`. We will explore multi-band rasters in a [later lesson 4??]()

#COLIN
![Image on what bands are...]()


#Challenge

???
