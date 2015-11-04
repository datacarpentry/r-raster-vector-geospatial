---
layout: post
title: "Lesson 04: Raster Time Series Data in R"
date:   2015-1-25
authors: [Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym]
dateCreated:  2014-11-26
lastModified: 2015-07-23
category: time-series-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This post explains the fundamental principles, functions and metadata that you need to work with raster data in R."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Raster-Times-Series-Data-In-R/
comments: false
---

{% include _toc.html %}

##About
This activity will walk you through using time series raster data. 

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will know:

* What time series raster format is.
* How to read in time series raster.
* How to plot and explore time series raster data.

###Things You'll Need To Complete This Lesson

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`


####Tools To Install

Please be sure you have the most current version of `R` and preferably
R studio to write your code.


####Data to Download

* <a href="http://figshare.com/articles/NEON_AOP_Hyperspectral_Teaching_Dataset_SJER_and_Harvard_forest/1580086" class="btn btn-success"> DOWNLOAD Sample NEON LiDAR data in Raster Format & Vegetation Sampling Data</a>


The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the Harvard and San Joaquin field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the NEON website.  

####Recommended Pre-Lesson Reading


* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>

</div>

```
# Getting names of all NDVI files
NDVI_path <- "~/Documents/Graduate_School/Workshops/GST_hackathon/1_WorkshopData/Landsat_NDVI/HARV/2011/ndvi"
all_NDVI <- list.files(NDVI_path, full.names = TRUE, pattern = ".tif$")

# Opening those files and plotting them
NDVI_stack <- stack(all_NDVI)
plot(NDVI_stack, zlim = c(1500, 10000), nc = 3)
hist(NDVI_stack, xlim = c(1500, 10000))

# TODO: Challenge: two of the times have weird values because of clouds, have them figure that out
