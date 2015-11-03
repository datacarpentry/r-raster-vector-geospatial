---
layout: post
title: "Time Series Raster"
date:   2015-1-26 20:49:52
authors: "Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym"
dateCreated:  2014-11-26 20:49:52
lastModified: 2015-07-23 14:28:52
category: time-series-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This post explains the fundamental principles, functions and metadata that you need to work with raster data in R."
code1: 
image:
  feature: lidar_GrandMesa.png
  credit: LiDAR data collected over Grand Mesa, Colorado - National Ecological Observatory Network (NEON)
  creditlink: http://www.neoninc.org
permalink: /R/Raster-Data-In-R/
code1: /R/2015-07-22-Introduction-to-Raster-Data-In-R.R
comments: true

---

<section id="table-of-contents" class="toc">
  <header>
    <h3>Contents</h3>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

##About
This activity will walk you through using time series raster data. 

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives">

<h3>Goals / Objectives</h3>
After completing this activity, you will know:
<ol>
<li>What time series raster format is.</li>
<li>How to read in time series raster.</li>
<li>How to plot and explore time series raster data.</li>
</ol>

<h3>Things You'll Need To Complete This Lesson</h3>

<h3>R Libraries to Install:</h3>
<ul>
<li><strong>raster:</strong> <code> install.packages("raster")</code></li>
<li><strong>rgdal:</strong> <code> install.packages("rgdal")</code></li>

</ul>
<h4>Tools To Install</h4>

Please be sure you have the most current version of `R` and preferably
R studio to write your code.


<h4>Data to Download</h4>

Download the workshop data:
<ul>
<li><a href="http://figshare.com/articles/NEON_AOP_Hyperspectral_Teaching_Dataset_SJER_and_Harvard_forest/1580086" class="btn btn-success"> DOWNLOAD Sample NEON LiDAR data in Raster Format & Vegetation Sampling Data</a></li>
</ul>

<p>The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the Harvard and San Joaquin field sites 
and processed at <a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the NEON website.</p>   

<h4>Recommended Pre-Lesson Reading</h4>
<ul>
<li>
<a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>
</li>
</ul>
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
