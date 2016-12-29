---
layout: post
title: "Vector 05: Crop Raster Data and Extract Summary Pixels Values From 
Rasters in R"
date:   2015-10-22
authors: [Joseph Stachelek, Leah A. Wasser, Megan A. Jones]
contributors: [Sarah Newman]
dateCreated:  2015-10-23
lastModified: `r format(Sys.time(), "%Y-%m-%d")`
packagesLibraries: [rgdal, raster]
categories: [self-paced-tutorial]
mainTag: vector-data-series
tags: [vector-data, R, spatial-data-gis]
tutorialSeries: [vector-data-series]
description: "This tutorial covers how to modify (crop) a raster extent using
the extent of a vector shapefile. It also covers extracting pixel values from 
defined locations stored in a spatial object."
code1: /R/dc-spatial-vector/05-vector-raster-integration-advanced.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink:
permalink: /R/crop-extract-raster-data-R/
comments: true
---

{% include _toc.html %}

## About
This tutorial explains how to crop a raster using the extent of a vector
shapefile. We will also cover how to extract values from a raster that occur
within a set of polygons, or in a buffer (surrounding) region around a set of
points.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">
# Goals / Objectives
After completing this activity, you will:

 * Be able to crop a raster to the extent of a vector layer.
 * Be able to extract values from raster that correspond to a vector file
 overlay.
 
## Things You’ll Need To Complete This Tutorial
You will need the most current version of `R` and, preferably, `RStudio` loaded 
on your computer to complete this tutorial.

### Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`

* [More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}/R/Packages-In-R/)

### Download Data
{% include/dataSubsets/_data_Site-Layout-Files.html %}
{% include/dataSubsets/_data_Airborne-Remote-Sensing.html %}

****

{% include/_greyBox-wd-rscript.html %}

</div>

## Crop a Raster to Vector Extent
We often work with spatial layers that have different spatial extents.

<figure>
    <a href="{{ site.baseurl }}/images/dc-spatial-vector/spatial_extent.png">
    <img src="{{ site.baseurl }}/images/dc-spatial-vector/spatial_extent.png"></a>
    <figcaption>The spatial extent of a shapefile or R spatial object represents
    the geographic "edge" or location that is the furthest north, south east and 
    west. Thus is represents the overall geographic coverage of the spatial 
    object. Image Source: National Ecological Observatory Network (NEON) 
    </figcaption>
</figure>

The graphic below illustrates the extent of several of the spatial layers that 
we have worked with in this vector data tutorial series:

* Area of interest (AOI) -- blue
* Roads and trails -- purple
* Vegetation plot locations -- black

and a raster file, that we will introduce this tutorial: 

* A canopy height model (CHM) in GeoTIFF format -- green

```{r view-extents, echo=FALSE, results='hide'}
## Load Packages
library(rgdal)  # for vector work; sp package should always load with rgdal. 
library (raster)

# Import a polygon shapefile 
aoiBoundary_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                            "HarClip_UTMZ18")

# Import a line shapefile
lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/", 
                       "HARV_roads")

# Import a point shapefile 
point_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                      "HARVtower_UTM18N")

chm_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

utm18nCRS <- crs(point_HARV)

# Read the .csv file
plot.locations_HARV <- 
  read.csv("NEON-DS-Site-Layout-Files/HARV/HARV_PlotLocations.csv",
           stringsAsFactors = FALSE)

# note that the easting and northing columns are in columns 1 and 2
plot.locationsSp_HARV <- SpatialPointsDataFrame(plot.locations_HARV[,1:2],
                    plot.locations_HARV,    # the R object to convert
                    proj4string = utm18nCRS)   # assign a CRS 

plot(extent(lines_HARV),
     col="purple", lwd="3",
     xlab="Easting", ylab="Northing",
    main="Extent Boundary of Several Spatial Files",
    xlim=c(730741.2,735000),
    col.lab = 'grey', # set axis label color
    col.axis = 'grey') # set axis tick label color

plot(extent(plot.locationsSp_HARV),
     col="black",
     add=TRUE)

plot(extent(aoiBoundary_HARV),
     add=TRUE,
     col="blue", 
     lwd=4)

plot(extent(chm_HARV),
     add=TRUE, 
     lwd=5,
     col="springgreen")

legend("topright", 
       legend=c("Roads","Plot Locations","Tower AOI", "CHM"),
       lwd=3,
       col=c("purple","black","blue","springgreen"),
       bty = "n",  
       cex = .8)

```

```{r reset-par, results="hide", echo=FALSE }
# reset par
dev.off()
```

Frequent use cases of cropping a raster file include reducing file size and
creating maps.

Sometimes we have a raster file that is much larger than our study area or area
of interest. It is often most efficient to crop the raster to the extent of our
study area to keep reduce file sizes as we process our data.

Cropping a raster can also be useful when creating pretty maps so that the
raster layer matches the extent of the desired vector layers.

### Import Data
We will begin by importing four vector shapefiles (field site boundary,
roads/trails, tower location, and veg study plot locations) and one raster
GeoTIFF file, a Canopy Height Model for the Harvard Forest, Massachusetts.
These data can be used to create maps that characterize our study location.

If you have completed the Vector 00-04 tutorials in this 
[Introduction to Working with Vector Data in R]({{site.baseurl}}/tutorial-series/vector-data-series/)
series, you can skip this code as you have already created these object.)

```{r load-libraries-data, results="hide", warning=FALSE }
# load necessary packages
library(rgdal)  # for vector work; sp package should always load with rgdal. 
library (raster)

# set working directory to data folder
# setwd("pathToDirHere")

# Imported in Vector 00: Vector Data in R - Open & Plot Data
# shapefile 
aoiBoundary_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                            "HarClip_UTMZ18")
# Import a line shapefile
lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/",
                       "HARV_roads")
# Import a point shapefile 
point_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                      "HARVtower_UTM18N")

# Imported in  Vector 02: .csv to Shapefile in R
# import raster Canopy Height Model (CHM)
chm_HARV <- 
  raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

```

## Crop a Raster Using Vector Extent
We can use the `crop` function to crop a raster to the extent of another spatial 
object. To do this, we need to specify the raster to be cropped and the spatial
object that will be used to crop the raster. `R` will use the `extent` of the
spatial object as the cropping boundary.

```{r Crop-by-vector-extent}
# plot full CHM
plot(chm_HARV,
     main="LiDAR CHM - Not Cropped\nNEON Harvard Forest Field Site")

# crop the chm
chm_HARV_Crop <- crop(x = chm_HARV, y = aoiBoundary_HARV)

# plot full CHM
plot(extent(chm_HARV),
     lwd=4,col="springgreen",
     main="LiDAR CHM - Cropped\nNEON Harvard Forest Field Site",
     xlab="easting", ylab="northing")

plot(chm_HARV_Crop,
     add=TRUE)

```

We can see from the plot above that the full CHM extent (plotted in green) is
much larger than the resulting cropped raster. Our new cropped CHM now has the 
same extent as the `aoiBoundary_HARV` object that was used as a crop extent 
(blue boarder below).

```{r view-crop-extent, echo=FALSE}
# view the data in a plot
plot(aoiBoundary_HARV, lwd=8, border="blue",
     main = "Cropped LiDAR Canopy Height Model \n NEON Harvard Forest Field Site")

plot(chm_HARV_Crop, add = TRUE)
```

We can look at the extent of all the other objects. 

``` {r view-extent}
# lets look at the extent of all of our objects
extent(chm_HARV)
extent(chm_HARV_Crop)
extent(aoiBoundary_HARV)

```

Which object has the largest extent?  Our plot location extent is not the 
largest but is larger than the AOI Boundary. It would be nice to see our
vegetation plot locations with the Canopy Height Model information.

<div id="challenge" markdown="1">
## Challenge: Crop to Vector Points Extent

1. Crop the Canopy Height Model to the extent of the study plot locations. 
2. Plot the vegetation plot location points on top of the Canopy Height Model. 

If you completed
[.csv to Shapefile in R]({{site.baseurl}}/R/csv-to-shapefile-R/)
you have these plot locations as the spatial `R` spatial object
`plot.locationsSp_HARV`. Otherwise, import the locations from the
`\HARV\PlotLocations_HARV.shp` shapefile in the downloaded data. 

</div>

```{r challenge-code-crop-raster-points, include=TRUE, results="hide", echo=FALSE}

# Created/imported in L02: .csv to Shapefile in R
plot.locationSp_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
																"PlotLocations_HARV")

# crop the chm 
CHM_plots_HARVcrop <- crop(x = chm_HARV, y = plot.locationsSp_HARV)

plot(CHM_plots_HARVcrop,
     main="Study Plot Locations\n NEON Harvard Forest")

plot(plot.locationSp_HARV, 
     add=TRUE,
     pch=19,
     col="blue")

```

In the plot above, created in the challenge, all the vegetation plot locations
(blue) appear on the Canopy Height Model raster layer except for one. One is
situated on the white space. Why? 

A modification of the first figure in this tutorial is below, showing the 
relative extents of all the spatial objects. Notice that the extent for our 
vegetation plot layer (black) extends further west than the extent of our CHM 
raster (bright green). The crop function will make a raster extent smaller, it 
will not expand the extent in areas where there are no data. Thus, extent of our
vegetation plot layer will still extend further west than the extent of our 
(cropped) raster data (dark green).

``` {r raster-extents-cropped, echo=FALSE}
plot(extent(lines_HARV),
     col="purple", lwd="3",
     xlab="Easting", ylab="Northing",
    main="Extent Boundary of Several Spatial Files")

plot(extent(plot.locationsSp_HARV),
     col="black",
     add=TRUE)

plot(extent(chm_HARV),
     add=TRUE, 
     lwd=5,
     col="springgreen")

plot(extent(CHM_plots_HARVcrop),
     add=TRUE, 
     lwd=5,
     col="darkgreen")

legend("bottomright", 
        legend=c("Roads","Plot Locations", "CHM", "CHM cropped to Plots"),
       lwd=3,
       col=c("purple","black","springgreen", "darkgreen"),
       bty = "n",  
       cex = .8)

```

## Define an Extent
We can also use an `extent()` method to define an extent to be used as a cropping
boundary. This creates an object of class `extent`.

```{r hidden-extent-chunk}
# extent format (xmin,xmax,ymin,ymax)
new.extent <- extent(732161.2, 732238.7, 4713249, 4713333)
class(new.extent)
```

Once we have defined the extent, we can use the `crop` function to crop our
raster. 

```{r crop-using-drawn-extent}

# crop raster
CHM_HARV_manualCrop <- crop(x = chm_HARV, y = new.extent)

# plot extent boundary and newly cropped raster
plot(aoiBoundary_HARV, 
     main = "Manually Cropped Raster\n NEON Harvard Forest Field Site")
plot(new.extent, 
     col="brown", 
     lwd=4,
     add = TRUE)
plot(CHM_HARV_manualCrop, 
     add = TRUE)

```

Notice that our manual `new.extent` (in red) is smaller than the
`aoiBoundary_HARV` and that the raster is now the same as the `new.extent`
object.
 
See the documentation for the `extent()` function for more ways
to create an `extent` object. 

* `??raster::extent`
* More on the 
<a href="http://www.inside-r.org/packages/cran/raster/docs/extent" target="_blank">
extent class in `R`</a>.

## Extract Raster Pixels Values Using Vector Polygons

Often we want to extract values from a raster layer for particular locations - 
for example, plot locations that we are sampling on the ground. 

<figure>
    <a href="http://neondataskills.org/images/spatialData/BufferSquare.png">
    <img src="http://neondataskills.org/images/spatialData/BufferSquare.png"></a>
    <figcaption> Extract raster information using a polygon boundary. We can
    extract all pixel values within 20m of our x,y point of interest. These can 
    then be summarized into some value of interest (e.g. mean, maximum, total).
    Source: National Ecological Observatory Network (NEON).
    </figcaption>
</figure>

To do this in `R`, we use the `extract()` function. The `extract()` function
requires:

* The raster that we wish to extract values from,
* The vector layer containing the polygons that we wish to use as a boundary or 
boundaries,
* we can tell it to store the output values in a `data.frame` using
`df=TRUE` (optional, default is to NOT return a `data.frame`) .

We will begin by extracting all canopy height pixel values located within our
`aoiBoundary` polygon which surrounds the tower located at the NEON Harvard
Forest field site. 

```{r extract-from-raster}

# extract tree height for AOI
# set df=TRUE to return a data.frame rather than a list of values
tree_height <- extract(x = chm_HARV, 
                       y = aoiBoundary_HARV, 
                       df=TRUE)

# view the object
head(tree_height)

nrow(tree_height)
```

When we use the extract command, `R` extracts the value for each pixel located 
within the boundary of the polygon being used to perform the extraction - in
this case the `aoiBoundary` object (1 single polygon). In this case, the
function extracted values from 18,450 pixels.

The `extract` function returns a `list` of values as default. You can tell `R` 
to summarize the data in some way or to return the data as a `data.frame`
(`df=TRUE`).

We can create a histogram of tree height values within the boundary to better
understand the structure or height distribution of trees. We can also use the 
`summary()` function to view descriptive statistics including min, max and mean
height values. These values help us better understand vegetation at our field
site.

```{r view-extract-histogram}
# view histogram of tree heights in study area
hist(tree_height$HARV_chmCrop, 
     main="Histogram of CHM Height Values (m) \nNEON Harvard Forest Field Site",
     col="springgreen",
     xlab="Tree Height", ylab="Frequency of Pixels")

# view summary of values
summary(tree_height$HARV_chmCrop)

```

* Check out the documentation for the `extract()` function for more details 
(`??raster::extract`).

## Summarize Extracted Raster Values 

We often want to extract summary values from a raster. We can tell `R` the type
of summary statistic we are interested in using the `fun=` method. Let's extract
a mean height value for our AOI. 

```{r summarize-extract }
# extract the average tree height (calculated using the raster pixels)
# located within the AOI polygon
av_tree_height_AOI <- extract(x = chm_HARV, 
                              y = aoiBoundary_HARV,
                              fun=mean, 
                              df=TRUE)

# view output
av_tree_height_AOI

```

It appears that the mean height value, extracted from our LiDAR data derived
canopy height model is 22.43 meters.

##Extract Data using x,y Locations

We can also extract pixel values from a raster by defining a buffer or area 
surrounding individual point locations using the `extract()` function. To do this
we define the summary method (`fun=mean`) and the buffer distance (`buffer=20`)
which represents the radius of a circular region around each point.

The units of the buffer are the same units of the data `CRS`.

<figure>
    <a href="http://neondataskills.org/images/spatialData/BufferCircular.png">
    <img src="http://neondataskills.org/images/spatialData/BufferCircular.png"></a>
    <figcaption> Extract raster information using a buffer region. All pixels
    that are touched by the buffer region are included in the extract. 
    Source: National Ecological Observatory Network (NEON).
    </figcaption>
</figure>

Let's put this into practice by figuring out the average tree height in the 
20m around the tower location. 

```{r extract-point-to-buffer }
# what are the units of our buffer
crs(point_HARV)

# extract the average tree height (height is given by the raster pixel value)
# at the tower location
# use a buffer of 20 meters and mean function (fun) 
av_tree_height_tower <- extract(x = chm_HARV, 
                                y = point_HARV, 
                                buffer=20,
                                fun=mean, 
                                df=TRUE)

# view data
head(av_tree_height_tower)

# how many pixels were extracted
nrow(av_tree_height_tower)

```

<div id="challenge" markdown="1">
## Challenge: Extract Raster Height Values For Plot Locations

Use the plot location points shapefile `HARV/plot.locations_HARV.shp` or spatial
object `plot.locationsSp_HARV` to extract an average tree height value for the
area within 20m of each vegetation plot location in the study area.

Create a simple plot showing the mean tree height of each plot using the `plot()`
function in base-R.
</div>


```{r challenge-code-extract-plot-tHeight, include=TRUE, results="hide", echo=FALSE}

# first import the plot location file.
plot.locationsSp_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                            "PlotLocations_HARV")

# extract data at each plot location
meanTreeHt_plots_HARV <- extract(x = chm_HARV, 
                               y = plot.locationsSp_HARV, 
                               buffer=20,
                               fun=mean, 
                               df=TRUE)

# view data
meanTreeHt_plots_HARV

# plot data
plot(meanTreeHt_plots_HARV,
     main="MeanTree Height at each Plot\nNEON Harvard Forest Field Site",
     xlab="Plot ID", ylab="Tree Height (m)",
     pch=16)

```
