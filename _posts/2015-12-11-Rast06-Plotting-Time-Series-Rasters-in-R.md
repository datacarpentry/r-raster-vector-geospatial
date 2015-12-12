---
layout: post
title: "Lesson 06: Plot Raster Time Series Data in R Using RasterVis and
Levelplot"
date:   2015-10-23
authors: [Leah Wasser, Kristina Riemer, Zack Bryn, Jason Williams, Jeff Hollister, 
Mike Smorul]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal, rasterVis]
dateCreated:  2014-11-26
lastModified: 2015-12-11
category: time-series-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson covers how to improve plotting output using the
`rasterVis` package in R. Specifically it covers using `levelplot()` and adding
meaningful custom names to bands within a RasterStack."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Plot-Raster-Times-Series-Data-In-R/
comments: false
---

{% include _toc.html %}

##About
This lesson covers how to improve plotting output using the
`rasterVis` package in R. Specifically it covers using `levelplot()` and adding
meaningful custom names to bands within a RasterStack. 

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this activity, you will:

* Be able to assign custom names to bands in a RasterStack for prettier plotting.
* Understand advanced plotting of rasters using the `rasterVis` package and
`levelplot`.

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
* **rasterVis:** `install.packages("rasterVis")`

####Data to Download

Download the raster files for the Harvard Forest dataset:

<a href="http://files.figshare.com/2434040/Landsat_NDVI.zip" class="btn btn-success"> DOWNLOAD Sample Landsat NDVI Data</a> 

This data is from ....


####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a
refresher on setting the working directory, please view the [Setting A Working Directory In R]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") 
lesson prior to beginning this lesson.

###Raster Lesson Series 
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
* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank"> Read more about the `raster` package in R.</a>
* The `rasterVis` library can be used to create nicer plots of raster time
series data! <a href="https://cran.r-project.org/web/packages/rasterVis/rasterVis.pdf"
target="_blank">Learn more about the rasterVis package</a>.

</div>

##Getting Started 
In this lesson, we are working with the same set of rasters used in the
[Raster Time Series Data in R ]({{ site.baseurl}} /R/Raster-Times-Series-Data-In-R/) 
lesson. This data is derived from the Landsat satellite and stored in GeoTIFF
format. Each raster covers the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>.  
If you do not yet have this RasterStack, please create it now. 


    library(raster)
    library(rgdal)
    library(rasterVis)
    
    # Create list of NDVI file paths
    NDVI_path <- "Landsat_NDVI/HARV/2011/ndvi"  #assign path to object = cleaner code
    all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")
    
    # Create a time series raster stack
    NDVI_stack <- stack(all_NDVI)

#Plot Raster Time Series Data
We could used the `plot` function to plot our raster time series data.


    #view a histogram of all of the rasters
    #nc specifies number of columns
    plot(NDVI_stack, 
         zlim = c(1500, 10000), 
         nc = 4)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/plot-time-series-1.png) 

Note: The metadata for this NDVI data have a scale factor: 10,000. A scale
factor is commonly used in larger datasets to remove decimals. {: .notice2}

However, we are left with plots using the file name for titles, no indication
of units, and overall non-customized plots.  To address these deficiencies we
could instead plot using `levelplot` from the `rasterVis` package. 

* <a href="http://oscarperpinan.github.io/rastervis/" target="_blank">More on the rasterVis library</a>

The syntax is similar to `plot()`.


    #create a `levelplot` plot
    levelplot(NDVI_stack,
              main="Landsat NDVI\nHarvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/levelplot-time-series-1.png) 

At least we now have an overall title describing the tiles.  We can customize
this plot further to make it look even nicer.  

##Adjust the Color Ramp
Let's start by adjusting the color ramp used to render the rasters. First, we
can change the red color ramp to a green one that is more suited to our NDVI
data.

We can do that using the `colorRampPalette` function in combination with 
`colorBrewer`. 


    #use colorbrewer which loads with the rasterVis package to generate
    #a color ramp of yellow to green
    cols <- colorRampPalette(brewer.pal(9,"YlGn"))
    #create a level plot - plot
    levelplot(NDVI_stack,
              main="Landsat NDVI better colors \nHarvard Forest",
              col.regions=cols)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/change-color-ramp-1.png) 

For all of the `brewer.pal` ramp names see the <a href="http://www.datavis.ca/sasmac/brewerpal.html" target="_blank"> brewerpal page</a>.

Cynthia Brewer, the creater of ColorBrewer, offers an online tool to help choose suitable color ramps, or to create your own. <a href="http://colorbrewer2.org/" target="_blank">ColorBrewer 2.0; Color Advise for Cartography </a>

The yellow to green color ramp make more sense given the data we are working
with and make our plot more visually pleasing. However, the labels for each 
raster tile are a bit clunky. 

##Refine Plot & Tile Labels
Let's make the label for each plot represents the Julian day that data was
collected on. The current names come from the bands or layers in the
`RasterStack` and first part each name is the Julian day. 

To create a better label we can remove the "x" and replace it with "day".
We can remove "_HARV_ndvi_crop" from each label and replace it with nothing. To
create these replacements we will use the `gsub` function in `R`.  

The syntax is `gsub("StringToReplace","TextToReplaceIt", Robject)`. 


    #view names for each raster layer
    names(NDVI_stack)

    ##  [1] "X005_HARV_ndvi_crop" "X037_HARV_ndvi_crop" "X085_HARV_ndvi_crop"
    ##  [4] "X133_HARV_ndvi_crop" "X181_HARV_ndvi_crop" "X197_HARV_ndvi_crop"
    ##  [7] "X213_HARV_ndvi_crop" "X229_HARV_ndvi_crop" "X245_HARV_ndvi_crop"
    ## [10] "X261_HARV_ndvi_crop" "X277_HARV_ndvi_crop" "X293_HARV_ndvi_crop"
    ## [13] "X309_HARV_ndvi_crop"

    #use gsub to use the names of the layers to create a list of new names
    #that we'll use for the plot 
    rasterNames  <- gsub("X","Day", names(NDVI_stack))
    
    #view Names
    rasterNames

    ##  [1] "Day005_HARV_ndvi_crop" "Day037_HARV_ndvi_crop"
    ##  [3] "Day085_HARV_ndvi_crop" "Day133_HARV_ndvi_crop"
    ##  [5] "Day181_HARV_ndvi_crop" "Day197_HARV_ndvi_crop"
    ##  [7] "Day213_HARV_ndvi_crop" "Day229_HARV_ndvi_crop"
    ##  [9] "Day245_HARV_ndvi_crop" "Day261_HARV_ndvi_crop"
    ## [11] "Day277_HARV_ndvi_crop" "Day293_HARV_ndvi_crop"
    ## [13] "Day309_HARV_ndvi_crop"

    #replace the second part of the string with year
    rasterNames  <- gsub("_HARV_ndvi_crop","",rasterNames)
    
    #view names for each raster layer
    rasterNames

    ##  [1] "Day005" "Day037" "Day085" "Day133" "Day181" "Day197" "Day213"
    ##  [8] "Day229" "Day245" "Day261" "Day277" "Day293" "Day309"

Bonus: Instead of substituting "x" and "_HARV_ndvi_crop" seperately, we could
have used use the vertical bar character ( | ) to replace more than one element.
For example "X|_HARV" tells `R` to replace all instances of both "X" and "_HARV"
in the string.  Example code to remove "x" an "_HARV...":
`gsub("X|_HARV_ndvi_crop"," |  ","rasterNames")`  {: .notice2}

Once the names for each band have been reassigned, we can render our plot with
the new labels. 


    #use level plot to create a nice plot with one legend and a 4x4 layout.
    levelplot(NDVI_stack,
              layout=c(4, 4), #create a 4x4 layout for the data
              col.regions=cols, #add a color ramp
              main="Landsat NDVI - Julian Days \nHarvard Forest 2014",
              names.attr=rasterNames)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/create-levelplot-1.png) 

We can adjust the columns of our plot too using `layout=c(cols,rows)'. Below
we adjust the layout to be a matrix of 4 columns and 4 rows.


    #use level plot to create a nice plot with one legend and a 4x4 layout.
    levelplot(NDVI_stack,
              layout=c(5, 3), #create a 5x3 layout for the data
              col.regions=cols, #add a color ramp
              main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
              names.attr=rasterNames)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/adjust-layout-1.png) 

#Challenge: Divergent Color Ramps 
When we used `gsub` to modify the tile labels we just used Day.  However, it
would be nice to be more descriptive and use the full "JulianDay_" so that it is
clear what is being denoted.  

Create a plot with this change and use a divergent brown to green color ramp to
represent the data.  Does having a divergent color ramp respresent the data
better than a sequential color ramp (like "YlGn")?  Can you think of other data
sets where a divergent color ramp may be best? 

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/challenge-code-levelplot-divergent-1.png) 
