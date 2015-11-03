---
layout: post
title: "Modify Raster"
date:   2015-10-23 12:00:0
authors: "Jason Williams, Jeff Hollister, Kristina Riemer, Mike Smorul, Zack Brym"
dateCreated:  2015-10-23 12:00:00
lastModified: 2015-10-23 12:00:00
category: spatio-temporal-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This post explains functions that modify raster data in R."
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
This activity will walk you through ways to modify raster data in R.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives">

<h3>Goals / Objectives</h3>
After completing this activity, you will know:
<ol>
<li>How to compute raster math.</li>
<li>How to crop rasters.</li>
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
# CHALLENGE: repeat objectives 1 & 2 for a different .tif file
DTM <- raster("~/Documents/Graduate_School/Workshops/GST_hackathon/1_WorkshopData/NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
plot(DTM)

# Raster math example
CHM <- DSM - DTM #This section could be automatable later on
plot(CHM) #Ask participants what they think this might look like ahead of time
hist(CHM, col = "purple")

# Crop raster, first method
plot(CHM)
cropbox <- drawExtent()
manual_crop <- crop(CHM, cropbox)
plot(manual_crop)

# Crop raster, second method
coords <- c(xmin(CHM) + ncol(CHM) * 0.1, xmax(CHM) - ncol(CHM) * 0.1, 
            ymin(CHM), ymax(CHM))
coord_crop = crop(CHM, coords)
plot(coord_crop) #Compare with CHM raster, should have different x-axis ranges

# Challenge: play with resolution (i.e., pixel numbers)

# TODO: reprojection of a single-band raster, ask others? 
# TODO: summarizing multiple pixels into one value
# TODO: do raster math on single raster
```
