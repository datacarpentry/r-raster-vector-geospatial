---
layout: post
title: "Lesson 06: Plot Raster Time Series Data in R Using RasterVis and
Levelplot"
date: 2015-10-23
authors: [Leah Wasser, Kristina Riemer, Zack Bryn, Jason Williams, Jeff Hollister, 
Mike Smorul]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal, rasterVis]
dateCreated:  2014-11-26
lastModified: 2015-12-21
category: time-series-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson covers how to improve plotting output using the
rasterVis package in R. Specifically it covers using levelplot() and adding
meaningful custom names to bands within a RasterStack."
code1: SR06-Plotting-Time-Series-Rasters-in-R.R
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

**To complete this lesson:** you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

####R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **rasterVis:** `install.packages("rasterVis")`

####Data to Download

<a href=" https://ndownloader.figshare.com/files/3579867" class="btn btn-success"> Download Landsat derived NDVI raster files</a> 

The imagery data used to create this raster teaching data subset were collected
over the National Ecological Observatory Network's
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard Forest</a>
and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin Experimental Range</a>
field sites.  
The imagery was created by the U.S. Geological Survey (USGS) using a 
<a href="http://eros.usgs.gov/#/Find_Data/Products_and_Data_Available/MSS" target="_blank" >  multispectral scanner</a>
on a <a href="http://landsat.usgs.gov" target="_blank" > Landsat Satellite </a>.
The data files are Geographic Tagged Image-File Format (GeoTIFF). 

**Set Working Directory:** This lessons assumes that you have set your working 
directory to the location of the downloaded and unzipped data subset. [An overview
of setting the working directory in `R` can be found here.]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") 
lesson prior to beginning this lesson.

**Challenge Code:** NEON Data lesson often contain challenges that reinforce 
learned skills. If available, the code for challenge solutions is found in a 
downloadable `R` script available on the footer of each lesson page.

###Additional Resources
* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank"> Read more about the `raster` package in `R`.</a>
* The `rasterVis` library can be used to create nicer plots of raster time
series data! <a href="https://cran.r-project.org/web/packages/rasterVis/rasterVis.pdf"
target="_blank">Learn more about the `rasterVis` package</a>.

</div>

##Getting Started 
In this lesson, we are working with the same set of rasters used in the
[Raster Time Series Data in R ]({{ site.baseurl}} /R/Raster-Times-Series-Data-In-R/) 
lesson. This data is derived from the Landsat satellite and stored in `GeoTIFF`
format. Each raster covers the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">NEON Harvard Forest field site</a>.  
If you have not already created the RasterStack, created in the lesson above,
please create it now. 


    library(raster)
    library(rgdal)
    library(rasterVis)
    
    # Create list of NDVI file paths
    all_NDVI_HARV <- list.files("Landsat_NDVI/HARV/2011/ndvi", full.names = TRUE, pattern = ".tif$")
    
    # Create a time series raster stack
    NDVI_HARV_stack <- stack(all_NDVI_HARV)
    
    #apply scale factor
    NDVI_HARV_stack <- NDVI_HARV_stack/10000

#Plot Raster Time Series Data
We can use the `plot` function to plot our raster time series data.


    #view a histogram of all of the rasters
    #nc specifies number of columns
    plot(NDVI_HARV_stack, 
         zlim = c(.15, 1), 
         nc = 4)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/plot-time-series-1.png) 

<i class="fa fa-star"></i> **Data Tip:** The range of values for NDVI is 0-1. 
However, the data stored in our raster ranges from 0 - 10,000. If we view the 
metadata for the original .tif files, we will see a scale factor of 10,000 is defined.
Multiplying values with decimal places by a factor of 10, allows the data to be 
stored ub integer format (no decimals) rather than a floating point format 
(containing decimals). This keeps the file size smaller. 
{: .notice }

Our plot is nice however, it's missing some key elements including, easily readable
titles. It also contains a legend that is repeated for each image. We
can use `levelplot` from the `rasterVis` package to make our plot prettier! 

* <a href="http://oscarperpinan.github.io/rastervis/" target="_blank">More on the 
rasterVis library</a>

The syntax for the `levelplot` function is similar to that for the `plot`
function. We use main="" to add a title to the entire plot series.


    #create a `levelplot` plot
    levelplot(NDVI_HARV_stack,
              main="Landsat NDVI\nNEON Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/levelplot-time-series-1.png) 


##Adjust the Color Ramp
Next, let's adjust the color ramp used to render the rasters. First, we
can change the red color ramp to a green one that is more visually suited to our 
NDVI (greenness) data using the `colorRampPalette` function in combination with 
`colorBrewer`. 


    #use colorbrewer which loads with the rasterVis package to generate
    #a color ramp of yellow to green
    cols <- colorRampPalette(brewer.pal(9,"YlGn"))
    #create a level plot - plot
    levelplot(NDVI_HARV_stack,
              main="Landsat NDVI\n Improved Colors \nNEON Harvard Forest Field Site",
              col.regions=cols)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/change-color-ramp-1.png) 

The yellow to green color ramp visually represents NDVI well given it's a
measure of greenness. Someone looking at the plot can quickly understand that
pixels that are more green, have a higher NDVI value. 

For all of the `brewer.pal` ramp names see the 
<a href="http://www.datavis.ca/sasmac/brewerpal.html" target="_blank"> brewerpal page.</a>.

<i class="fa fa-star"></i> **Data Tip:** Cynthia Brewer, the creater of 
ColorBrewer, offers an online tool to help choose suitable color ramps, or to 
create your own. <a href="http://colorbrewer2.org/" target="_blank">ColorBrewer 
2.0; Color Advise for Cartography </a>  
{: .notice }

##Refine Plot & Tile Labels
Next, let's label each raster in our plot with the Julian day that the raster represents.
The current names come from the band (layer names) stored in the
`RasterStack` and first part each name is the Julian day. 

To create a more meaningful label we can remove the "x" and replace it with
"day" using the `gsub` function in `R`. The syntax is as follows: `gsub("StringToReplace","TextToReplaceIt", Robject)`. 

First let's remove "_HARV_ndvi_crop" from each label. 


    #view names for each raster layer
    names(NDVI_HARV_stack)

    ##  [1] "X005_HARV_ndvi_crop" "X037_HARV_ndvi_crop" "X085_HARV_ndvi_crop"
    ##  [4] "X133_HARV_ndvi_crop" "X181_HARV_ndvi_crop" "X197_HARV_ndvi_crop"
    ##  [7] "X213_HARV_ndvi_crop" "X229_HARV_ndvi_crop" "X245_HARV_ndvi_crop"
    ## [10] "X261_HARV_ndvi_crop" "X277_HARV_ndvi_crop" "X293_HARV_ndvi_crop"
    ## [13] "X309_HARV_ndvi_crop"

    #use gsub to modify label names.
    #that we'll use for the plot 
    rasterNames  <- gsub("X","Day", names(NDVI_HARV_stack))
    
    #view Names
    rasterNames

    ##  [1] "Day005_HARV_ndvi_crop" "Day037_HARV_ndvi_crop"
    ##  [3] "Day085_HARV_ndvi_crop" "Day133_HARV_ndvi_crop"
    ##  [5] "Day181_HARV_ndvi_crop" "Day197_HARV_ndvi_crop"
    ##  [7] "Day213_HARV_ndvi_crop" "Day229_HARV_ndvi_crop"
    ##  [9] "Day245_HARV_ndvi_crop" "Day261_HARV_ndvi_crop"
    ## [11] "Day277_HARV_ndvi_crop" "Day293_HARV_ndvi_crop"
    ## [13] "Day309_HARV_ndvi_crop"

    #Remove HARV_ndvi_crop from the second part of the string 
    rasterNames  <- gsub("_HARV_ndvi_crop","",rasterNames)
    
    #view names for each raster layer
    rasterNames

    ##  [1] "Day005" "Day037" "Day085" "Day133" "Day181" "Day197" "Day213"
    ##  [8] "Day229" "Day245" "Day261" "Day277" "Day293" "Day309"

<i class="fa fa-star"></i> **Data Tip:** Instead of substituting "x" and "_HARV_ndvi_crop" separately, we could
have used use the vertical bar character ( | ) to replace more than one element.
For example "X|_HARV" tells `R` to replace all instances of both "X" and "_HARV"
in the string.  Example code to remove "x" an "_HARV...":
`gsub("X|_HARV_ndvi_crop"," |  ","rasterNames")`  
{: .notice }

Once the names for each band have been reassigned, we can render our plot with
the new labels using `names.attr=rasterNames`. 


    #use level plot to create a nice plot with one legend and a 4x4 layout.
    levelplot(NDVI_HARV_stack,
              layout=c(4, 4), #create a 4x4 layout for the data
              col.regions=cols, #add a color ramp
              main="Landsat NDVI - Julian Days \nHarvard Forest 2014",
              names.attr=rasterNames)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/create-levelplot-1.png) 

We can adjust the columns of our plot too using `layout=c(cols,rows)'. Below
we adjust the layout to be a matrix of 5 columns and 3 rows.


    #use level plot to create a nice plot with one legend and a 4x4 layout.
    levelplot(NDVI_HARV_stack,
              layout=c(5, 3), #create a 5x3 layout for the data
              col.regions=cols, #add a color ramp
              main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
              names.attr=rasterNames)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/adjust-layout-axes-1.png) 


Finally, let's remove the axis ticks from the plot.

    #use level plot to create a nice plot with one legend and a 4x4 layout.
    levelplot(NDVI_HARV_stack,
              layout=c(5, 3), #create a 5x3 layout for the data
              col.regions=cols, #add a color ramp
              main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
              names.attr=rasterNames,
              axes=FALSE)

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/adjust-layout-1.png) 

<div id="challenge" markdown="1">
#Challenge: Divergent Color Ramps 
When we used `gsub` to modify the tile labels we replaced the beginning of each 
tile title with "Day". A more descriptive name could be "Julian Day".

Create a plot and label each tile "Julian Day" with the julian day value following.
Change the colorramp to a divergent brown to green color ramp to
represent the data. Hint: 
Use the <a href="http://www.datavis.ca/sasmac/brewerpal.html" target="_blank"> 
brewerpal page</a> to help you choose a color ramp. 

**Questions:**
Does having a divergent color ramp respresent the data
better than a sequential color ramp (like "YlGn")? Can you think of other data
sets where a divergent color ramp may be best? 
</div>

![ ]({{ site.baseurl }}/images/rfigs/06-Plotting-Time-Series-Rasters-in-R/challenge-code-levelplot-divergent-1.png) 
