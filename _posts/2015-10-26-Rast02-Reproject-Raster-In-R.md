---
layout: post
title: "Lesson 02: When Rasters Don't Line Up - Reproject Raster Data in R"
date:   2015-10-27
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym, Leah Wasser]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2015-10-23
lastModified: 2015-12-17
category: spatio-temporal-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson explains how to reproject a raster in `R` using the
`projectRaster()` function in the raster package."
code1: SR02-Reproject-Raster-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Reproject-Raster-In-R
comments: false
---

{% include _toc.html %}

##About

Sometimes we encounter raster datasets that do not "line up" when plotted or 
analyzed. Rasters that don't line up are most often in different Coordinate Reference
Systems (`CRS`).

This lesson explains how to deal with rasters in different, known `CRS`s. It will
walk though reprojecting rasters in `R` using the `projectRaster` function in
the `raster` library.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will:

* Be able to reproject a raster in R

###Challenge Code
Throughout the lesson we have Challenges that reinforce learned skills. Possible
solutions to the challenges are not posted on this page, however, the code for 
each challenge is in the `R` code that can be downloaded for this lesson (see 
footer on this page).

**To complete this lesson:** you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

####Data to Download

<a href="https://ndownloader.figshare.com/files/3579867" class="btn btn-success"> Download NEON Airborne Observation Platform Raster Data Teaching Subset</a> 

The LiDAR and imagery data used to create this raster teaching data subset were
collected over the NEON <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard Forest</a>
and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin Experimental Range</a>
field sites and processed at
<a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the 
<a href="http://www.neoninc.org/data-resources/get-data/airborne-data" target="_blank"> NEON Airborne Data Request Page on the NEON Website.</a>

**Set Working Directory:** This lessons assumes that you have set your working 
directory to the location of the downloaded and unzipped data subset. [An overview
of setting the working directory in `R` can be found here.]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") 
lesson prior to beginning this lesson.

**Challenge Code:** NEON Data lesson often contain challenges that reinforce 
learned skills. If available, the code for challenge solutions is found in a 
downloadable `R` script available on the footer of each lesson page.

###Additional Resources

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in `R`.</a>

</div>

#Raster Projection in R

In the [Plot Raster Data in R]({{ site.baseurl}}/R/Plot-Rasters-In-R/) 
lesson, we learned how to layer a raster file on top of a hillshade for a nice
looking basemap. In this lesson, all of our data were in the same `CRS`. What happens when things don't line up?

We will use the `raster` and `rgdal` packages in this lesson.  


    #load raster package
    library(raster)
    library(rgdal)

Let's create an map of the Harvard Forest Digital Terrain Model 
(`DTM_HARV`) draped or layered on top of the hillshade (`DTM_hill_HARV`).


    #import DTM
    DTM_HARV <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmcrop.tif")
    #import DTM hillshade
    DTM_hill_HARV <- raster("NEON_RemoteSensing/HARV/DTM/HARV_DTMhill_WGS84.tif")
    
    #plot hillshade using a grayscale color ramp 
    plot(DTM_hill_HARV,
        col=grey(1:100/100),
        legend=FALSE,
        main="DTM Hillshade\n NEON Harvard Forest")
    
    #overlay the DTM on top of the hillshade
    plot(DTM_HARV,
         col=terrain.colors(10),
         alpha=0.4,
         add=TRUE,
         legend=FALSE)

![ ]({{ site.baseurl }}/images/rfigs/02-Reproject-Raster-In-R/import-DTM-hillshade-1.png) 

Our results are curious - the Digital Terrain Model (`DTM_HARV`) did not plot on
top of our hillshade. The hillshade plotted just fine on it's own. Let's try to 
plot the DTM on it's own to make sure there are data there.

<i class="fa fa-star"></i> **Data Tip:** For boolean R elements such as `add=TRUE`
you can use `T` and `F` in place of `TRUE` and `FALSE`.
{: .notice}


    #Plot DTM 
    plot(DTM_HARV,
         col=terrain.colors(10),
         alpha=1,
         legend=F,
         main="Digital Terrain Model\n NEON Harvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/02-Reproject-Raster-In-R/plot-DTM-1.png) 

Our DTM seems to contain data and plots just fine. Let's next check the Coordinate 
Reference System (`CRS`) and compare it to our hillshade.


    #view crs for DTM
    crs(DTM_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #view crs for hillshade
    crs(DTM_hill_HARV)

    ## CRS arguments:
    ##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0

Aha! `DTM_HARV` is in the UTM projection. `DTM_hill_HARV` is in `Geographic WGS84` -
which is represented by latitude and longitude values. Because the two rasters 
are in different CRSs, they don't line up when plotted in `R`. We need to 
*reproject* `DTM_HARV` into the `UTM CRS`. Alternatively, we could 
reproject the hillshade into WGS84. 

#Reproject Rasters
We can use the `projectRaster` function to reproject a raster into a new `CRS`.
Keep in mind that reprojection only works when you first have a *defined* `CRS`
for the raster object that you want to reproject. It cannot be used if *no*
`CRS` is defined. Lucky for us, the `DTM_hill_HARV` has a defined `CRS`. 

To use the `projectRaster` function, we need to define two things:

1. the object we want to reproject and 
2. the CRS that we want to reproject it to. 

The syntax is `projectRaster(RasterObject,crs=CRSToReprojectTo)`

We want the `CRS` of our hillshade to match the `DTM_HARV` raster. We can thus assign
the `CRS` of our `DTM_HARV` to our hillshade within the `projectRaster` function 
as follows: `crs=crs(DTM_HARV)`.


    #reproject to UTM
    DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                           crs=crs(DTM_HARV))
    
    #compare attributes of DTM_hill_UTMZ18N to DTM_hill
    crs(DTM_hill_UTMZ18N_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    crs(DTM_hill_HARV)

    ## CRS arguments:
    ##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0

    #compare attributes of DTM_hill_UTMZ18N to DTM_hill
    extent(DTM_hill_UTMZ18N_HARV)

    ## class       : Extent 
    ## xmin        : 731397.3 
    ## xmax        : 733205.3 
    ## ymin        : 4712403 
    ## ymax        : 4713907

    extent(DTM_hill_HARV)

    ## class       : Extent 
    ## xmin        : -72.18192 
    ## xmax        : -72.16061 
    ## ymin        : 42.52941 
    ## ymax        : 42.54234

Notice in the output above that the `CRS` of `DTM_hill_UTMZ18N_HARV` is now UTM, meters. 
However, values in the extent of `DTM_hillUTMZ18N_HARV` are different from 
`DTM_hill_HARV`.

Why do you think this is?  

<i class="fa fa-star"></i> **Data Tip:** When we reproject a raster, we 
move it from one "grid" to another. Thus, we are modifying the data! Keep this 
in mind as we work with raster data. 
{: .notice}


##Dealing with Raster Resolution

Let's next have a look at the resolution of our reprojected hillshade.  


    #compare resolution
    res(DTM_hill_UTMZ18N_HARV)

    ## [1] 1.000 0.998

The output resolution of `DTM_hill_UTMZ18N_HARV` is 1 x 0.998. Yet, we know that
the resolution for the data should be 1m x 1m. We can tell `R` to force our newly
reprojected raster to be 1m x 1m resolution by adding a line of code (`res=`).  


    #adjust the resolution 
    DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                      crs=crs(DTM_HARV),
                                      res=1)
    #view resolution
    res(DTM_hill_UTMZ18N_HARV)

    ## [1] 1 1


Let's plot our newly reprojected raster.


    #plot newly reprojected hillshade
    plot(DTM_hill_UTMZ18N_HARV,
        col=grey(1:100/100),
        legend=F,
        main="DTM with Hillshade\n NEON Harvard Forest Field Site")
    
    #overlay the DTM on top of the hillshade
    plot(DTM_HARV,
         col=rainbow(100),
         alpha=0.4,
         add=T,
         legend=F)

![ ]({{ site.baseurl }}/images/rfigs/02-Reproject-Raster-In-R/plot-projected-raster-1.png) 

We have now successfully draped the Digital Terrain Model on top of our
hillshade to produce a nice looking, textured map! 

<div id="challenge" markdown="1">
##Challenge: Reproject, then Plot a Digital Terrain Model 
Create a map of the 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin Experimental Range</a>
field site using the `SJER_DSMhill_WGS84.tif` and `SJER_dsmCrop.tif` files. 

Reproject the data as necessary to make things line up!
</div>

![ ]({{ site.baseurl }}/images/rfigs/02-Reproject-Raster-In-R/challenge-code-reprojection-1.png) 

If you completed the San Joaquin plotting challenge in the
[Plot Raster Data in R]({{ site.baseurl}}/R/Plot-Rasters-In-R/) 
lesson, how does the map you just created compare to that map? 


