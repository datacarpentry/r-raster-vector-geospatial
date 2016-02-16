---
layout: tutorial-series-landing
title: 'Introduction to Working With Vector Data in R - A Self-Paced Tutorial Series'
categories: [tutorial-series]
tutorialSeriesName: vector-data-series
permalink: tutorial-series/vector-data-series/
image:
  feature: NEONCarpentryHeader_2.png
  credit: 
  creditlink: 
---

The tutorials in this workshop cover how to 
open, work with and plot with spatial data, in vector format (points, lines and polygons) in R. 
Topics covered include working with spatial metadata: extent and coordinate reference system,
working with spatial attributes and plotting data by attributes. Data used
in this series cover NEON Harvard Forest Field Site and are in Shapefile and .csv
format.


**R Skill Level:** Beginner - you've got the basics of `R` down but haven't worked with
spatial data in `R` before.

<div id="objectives" markdown="1">

# Workshop Goals / Objectives
After completing the lessons in this series you will:

 * B

## Things You’ll Need To Complete This Lesson
To complete this lesson: you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

### Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`
* **ggplot2:** `install.packages("ggplot2")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)


### Download Data

{% include/dataSubsets/_data_Site-Layout-Files.html %}
{% include/dataSubsets/_data_Airborne-Remote-Sensing.html %}

*****

{% include/_greyBox-wd-rscript.html %}

**Data Carpentry Lesson Series:** This workshop part of a larger 
[spatio-temporal Data Carpentry Workshop ]({{ site.baseurl }}self-paced-tutorials/spatio-temporal-workshop)
that includes working with
[raster data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-raster-series) 
and  
[tabular time series in R ]({{ site.baseurl }}self-paced-tutorials/tabular-time-series).

</div> 

## Tutorials in Workshop Series
