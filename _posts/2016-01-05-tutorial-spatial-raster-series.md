---
layout: workshop
title: "Self-paced Tutorial: Working with Spatial Raster Time Series Data Series"
estimatedTime: 3.0 Hours
packagesLibraries: [rgdal, sp, raster, rasterVis, ggplot2]
date:   2015-1-05 20:00:00
dateCreated:   2015-10-15 17:00:00
lastModified: 2015-01-05 13:00:00
authors: [Kristina Riemer, Zack Brym, Jason Williams, Jeff Hollister,  Mike Smorul, Leah Wasser, Megan A. Jones]
categories: [self-paced-tutorial]
tags: []
mainTag: raster-ts-wrksp
description: "This self-paced tutorial explain how to work with spatial data in
 a raster format in R.  The data set used consists of raster files from NEON's
 Aerial Operations Platform and Landsat data collected over the NEON
 Harvard Forest and San Joaquin Experimental Range field sites. The data skills
 taught are applicable to all types of raster data.  The tutorial consists of
 eight sequential lessons." 
code1: 
workshopName: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: tutorial/spatial-raster-series
comments: false
---

This self-paced tutorial explain how to work with spatial data in
 a raster format in R.  The data set used consists of raster files from NEON's
 Aerial Operations Platform and Landsat data collected over the NEON
 Harvard Forest and San Joaquin Experimental Range field sites. The data skills
 taught are applicable to all types of raster data.  The tutorial consists of
 eight sequential lessons.


<div id="objectives" markdown="1">

#Goals / Objectives
After completing this lesson, you will:

 * OVERALL GOALS or list for each lesson? 


##Things You’ll Need To Complete This Lesson

###Setup RStudio
To complete the tutorial series you will need an updated version of R and,
 preferably, RStudio installed on your computer.
 <a href = "http://cran.r-project.org/">R</a> is a programming language
 that specializes in statistical computing. It is a powerful tool for
 exploratory data analysis. To interact with R, we strongly recommend 
<a href="http://www.rstudio.com/">RStudio</a>, an interactive development 
environment (IDE). 


###Install R Packages
You can chose to install packages with each lesson or you can download all 
of the necessary R Packages now. 

* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`
* **raster:** `install.packages("raster")`
* **ggplot2:** `install.packages("ggplot2")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

<\div>


