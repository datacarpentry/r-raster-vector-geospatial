---
layout: post
title: "Vector 04: Convert from .csv to a Shapefile in R"
date:   2015-10-23
authors: [Joseph Stachelek, Leah A. Wasser, Megan A. Jones]
contributors: [Sarah Newman]
dateCreated:  2015-10-23
lastModified: `r format(Sys.time(), "%Y-%m-%d")`
packagesLibraries: [rgdal, raster]
categories: [self-paced-tutorial]
mainTag: vector-data-series
tags: [vector-data, R, spatial-data-gis]
tutorialSeries: [vector-data-series]
description: "This tutorial covers how to convert a .csv file that contains
spatial coordinate information into a spatial object in R. We will then export
the spatial object as a Shapefile for efficient import into R and other GUI GIS
applications including QGIS and ArcGIS"
code1: /R/dc-spatial-vector/04-csv-to-shapefile-in-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink:
permalink: /R/csv-to-shapefile-R/
comments: true
---

{% include _toc.html %}

## About

This tutorial will review how to import spatial points stored in `.csv` (Comma
Separated Value) format into
`R` as a spatial object - a `SpatialPointsDataFrame`. We will also
reproject data imported in a shapefile format, and export a shapefile from an
`R` spatial object and plot raster and vector data as
layers in the same plot. 

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

# Goals / Objectives
After completing this activity, you will:

* Be able to import .csv files containing x,y coordinate locations into `R`.
* Know how to convert a .csv to a spatial object.
* Understand how to project coordinate locations provided in a Geographic
Coordinate System (Latitude, Longitude) to a projected coordinate system (UTM).
* Be able to plot raster and vector data in the same plot to create a map.

## Things You’ll Need To Complete This Tutorial
You will need the most current version of `R` and, preferably, `RStudio` loaded 
on your computer to complete this tutorial.

### Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`

* [More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}/R/Packages-In-R/)

## Data to Download
{% include/dataSubsets/_data_Site-Layout-Files.html %}

{% include/dataSubsets/_data_Airborne-Remote-Sensing.html %}

****

{% include/_greyBox-wd-rscript.html %}

</div>

## Spatial Data in Text Format

The `HARV_PlotLocations.csv` file contains `x, y` (point) locations for study 
plot where NEON collects data on
<a href="http://www.neonscience.org/science-design/collection-methods/terrestrial-organismal-sampling" target="_blank"> vegetation and other ecological metrics</a>.
We would like to:

* Create a map of these plot locations. 
* Export the data in a `shapefile` format to share with our colleagues. This
shapefile can be imported into any GIS software.
* Create a map showing vegetation height with plot locations layered on top.

Spatial data are sometimes stored in a text file format (`.txt` or `.csv`). If 
the text file has an associated `x` and `y` location column, then we can 
convert it into an `R` spatial object which in the case of point data,
will be a `SpatialPointsDataFrame`. The `SpatialPointsDataFrame` 
allows us to store both the `x,y` values that represent the coordinate location
of each point and the associated attribute data - or columns describing each
feature in the spatial object.

<i class="fa fa-star"></i> **Data Tip:** There is a `SpatialPoints` object (not
`SpatialPointsDataFrame`) in `R` that does not allow you to store associated
attributes. 
{: .notice}

We will use the `rgdal` and `raster` libraries in this tutorial. 

```{r load-libraries}

# load packages
library(rgdal)  # for vector work; sp package should always load with rgdal. 
library (raster)   # for metadata/attributes- vectors or rasters

# set working directory to data folder
# setwd("pathToDirHere")

```

## Import .csv 
To begin let's import `.csv` file that contains plot coordinate `x, y`
locations at the NEON Harvard Forest Field Site (`HARV_PlotLocations.csv`) in
`R`. Note that we set `stringsAsFactors=FALSE` so our data import as a
`character` rather than a `factor` class.

```{r read-csv }

# Read the .csv file
plot.locations_HARV <- 
  read.csv("NEON-DS-Site-Layout-Files/HARV/HARV_PlotLocations.csv",
           stringsAsFactors = FALSE)

# look at the data structure
str(plot.locations_HARV)

```

Also note that `plot.locations_HARV` is a `data.frame` that contains 21 
locations (rows) and 15 variables (attributes). 

Next, let's identify explore  `data.frame` to determine whether it contains
columns with coordinate values. If we are lucky, our `.csv` will contain columns
labeled:

* "X" and "Y" OR
* Latitude and Longitude OR
* easting and northing (UTM coordinates)

Let's check out the column `names` of our file.

```{r find-coordinates }

# view column names
names(plot.locations_HARV)

```

## Identify X,Y Location Columns

View the column names, we can see that our `data.frame`  that contains several 
fields that might contain spatial information. The `plot.locations_HARV$easting`
and `plot.locations_HARV$northing` columns contain coordinate values. 

```{r check-out-coordinates }
# view first 6 rows of the X and Y columns
head(plot.locations_HARV$easting)
head(plot.locations_HARV$northing)

# note that  you can also call the same two columns using their COLUMN NUMBER
# view first 6 rows of the X and Y columns
head(plot.locations_HARV[,1])
head(plot.locations_HARV[,2])

```

So, we have coordinate values in our `data.frame` but in order to convert our
`data.frame` to a `SpatialPointsDataFrame`, we also need to know the CRS
associated with those coordinate values. 

There are several ways to figure out the CRS of spatial data in text format.

1. We can check the file **metadata** in hopes that the CRS was recorded in the
data. For more information on metadata, check out the
[Why Metadata Are Important: How to Work with Metadata in Text & EML Format]({{site.baseurl}}/R/why-metadata-are-important/) 
tutorial. 
2. We can explore the file itself to see if CRS information is embedded in the
file header or somewhere in the data columns.

Following the `easting` and `northing` columns, there is a `geodeticDa` and a 
`utmZone` column. These appear to contain CRS information
(`datum` and `projection`). Let's view those next. 

```{r view-CRS-info }
# view first 6 rows of the X and Y columns
head(plot.locations_HARV$geodeticDa)
head(plot.locations_HARV$utmZone)

```

It is not typical to store CRS information in a column. But this particular
file contains CRS information this way. The `geodeticDa` and `utmZone` columns
contain the information that helps us determine the CRS: 

* `geodeticDa`: WGS84  -- this is geodetic datum WGS84
* `utmZone`: 18

In 
[When Vector Data Don't Line Up - Handling Spatial Projection & CRS in R]({{site.baseurl}}/R/vector-data-reproject-crs-R/)
we learned about the components of a `proj4` string. We have everything we need 
to now assign a CRS to our data.frame.

To create the `proj4` associated with `UTM Zone 18 WGS84` we could look up the 
projection on the 
<a href="http://www.spatialreference.org/ref/epsg/wgs-84-utm-zone-18n/" target="_blank"> spatial reference website</a> 
which contains a list of CRS formats for each projection: 

* This link shows 
<a href="http://www.spatialreference.org/ref/epsg/wgs-84-utm-zone-18n/proj4/" target="_blank">the proj4 string for UTM Zone 18N WGS84</a>. 

However, if we have other data in the `UTM Zone 18N` projection, it's much
easier to simply assign the `crs()` in `proj4` format from that object to our 
new spatial object. Let's import the roads layer from Harvard forest and check 
out its CRS.

```{r explore-units}

# Import the line shapefile
lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/", "HARV_roads")

# view CRS
crs(lines_HARV)

# view extent
extent(lines_HARV)

```

Exploring the data above, we can see that the lines shapefile is in
`UTM zone 18N`. We can thus use the CRS from that spatial object to convert our
non-spatial `data.frame` into a `spatialPointsDataFrame`. 

Next, let's create a `crs` object that we can use to define the CRS of our 
`SpatialPointsDataFrame` when we create it

```{r crs-object } 
# create crs object
utm18nCRS <- crs(lines_HARV)
utm18nCRS

class(utm18nCRS)
```

## .csv to R SpatialPointsDataFrame
Next, let's convert our `data.frame` into a `SpatialPointsDataFrame`. To do
this, we need to specify:

1. The columns containing X (`easting`) and Y (`northing`) coordinate values
2. The CRS that the column coordinate represent (units are included in the CRS) -
stored in our `utmCRS` object.
3. optional: the other columns stored in the data frame that you wish to append
as attributes to your spatial object

We will use the `SpatialPointsDataFrame()` function to perform the conversion.

```{r convert-csv-shapefile}
# note that the easting and northing columns are in columns 1 and 2
plot.locationsSp_HARV <- SpatialPointsDataFrame(plot.locations_HARV[,1:2],
                    plot.locations_HARV,    #the R object to convert
                    proj4string = utm18nCRS)   # assign a CRS 
                                          
# look at CRS
crs(plot.locationsSp_HARV)

```

## Plot Spatial Object 
We now have a spatial `R` object, we can plot our newly created spatial object.

```{r plot-data-points }
# plot spatial object
plot(plot.locationsSp_HARV, 
     main="Map of Plot Locations")

```

## Define Plot Extent

In 
[Open and Plot Shapefiles in R]({{site.baseurl}}/R/open-shapefiles-in-R/)
we learned about spatial object `extent`. When we plot several spatial layers in
`R`, the first layer that is plotted, becomes the extent of the plot. If we add
additional layers that are outside of that extent, then the data will not be
visible in our plot. It is thus useful to know how to set the spatial extent of
a plot using `xlim` and `ylim`.

Let's first create a SpatialPolygon object from the
`NEON-DS-Site-Layout-Files/HarClip_UTMZ18` shapefile. (If you have completed
Vector 00-02 tutorials in this 
[Introduction to Working with Vector Data in R]({{site.baseurl}}/tutorial-series/vector-data-series/)
series, you can skip this code as you have already created this object.)

``` {r create-aoi-boundary}
# create boundary object 
aoiBoundary_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                            "HarClip_UTMZ18")
```

To begin, let's plot our `aoiBoundary` object with our vegetation plots.

```{r plot-data }
# plot Boundary
plot(aoiBoundary_HARV,
     main="AOI Boundary\nNEON Harvard Forest Field Site")

# add plot locations
plot(plot.locationsSp_HARV, 
     pch=8, add=TRUE)

# no plots added, why? CRS?
# view CRS of each
crs(aoiBoundary_HARV)
crs(plot.locationsSp_HARV)

```

When we attempt to plot the two layers together, we can see that the plot
locations are not rendered. We can see that our data are in the same projection
- so what is going on?

```{r compare-extents}
# view extent of each
extent(aoiBoundary_HARV)
extent(plot.locationsSp_HARV)

# add extra space to right of plot area; 
# par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)

plot(extent(plot.locationsSp_HARV),
     col="purple", 
     xlab="easting",
     ylab="northing", lwd=8,
     main="Extent Boundary of Plot Locations \nCompared to the AOI Spatial Object",
     ylim=c(4712400,4714000)) # extent the y axis to make room for the legend

plot(extent(aoiBoundary_HARV), 
     add=TRUE,
     lwd=6,
     col="springgreen")

legend("bottomright",
       #inset=c(-0.5,0),
       legend=c("Layer One Extent", "Layer Two Extent"),
       bty="n", 
       col=c("purple","springgreen"),
       cex=.8,
       lty=c(1,1),
       lwd=6)

```

The **extents** of our two objects are **different**. `plot.locationsSp_HARV` is
much larger than `aoiBoundary_HARV`. When we plot `aoiBoundary_HARV` first, `R`
uses the extent of that object to as the plot extent. Thus the points in the 
`plot.locationsSp_HARV` object are not rendered. To fix this, we can manually
assign the plot extent using `xlims` and `ylims`. We can grab the extent
values from the spatial object that has a larger extent. Let's try it.

<figure>
    <a href="{{ site.baseurl }}/images/dc-spatial-vector/spatial_extent.png">
    <img src="{{ site.baseurl }}/images/dc-spatial-vector/spatial_extent.png"></a>
    <figcaption>The spatial extent of a shapefile or R spatial object
    represents the geographic <b> edge </b> or location that is the furthest
    north, south, east and west. Thus is represents the overall geographic
    coverage of the spatial object. Source: National Ecological Observatory
    Network (NEON) 
    </figcaption>
</figure>

```{r set-plot-extent }

plotLoc.extent <- extent(plot.locationsSp_HARV)
plotLoc.extent
# grab the x and y min and max values from the spatial plot locations layer
xmin <- plotLoc.extent@xmin
xmax <- plotLoc.extent@xmax
ymin <- plotLoc.extent@ymin
ymax <- plotLoc.extent@ymax

# adjust the plot extent using x and ylim
plot(aoiBoundary_HARV,
     main="NEON Harvard Forest Field Site\nModified Extent",
     border="darkgreen",
     xlim=c(xmin,xmax),
     ylim=c(ymin,ymax))

plot(plot.locationsSp_HARV, 
     pch=8,
		 col="purple",
		 add=TRUE)

# add a legend
legend("bottomright", 
       legend=c("Plots", "AOI Boundary"),
       pch=c(8,NA),
       lty=c(NA,1),
       bty="n", 
       col=c("purple","darkgreen"),
       cex=.8)

```

<div id="challenge" markdown="1">
## Challenge - Import & Plot Additional Points
We want to add two phenology plots to our existing map of vegetation plot
locations. 

Import the .csv: `HARV/HARV_2NewPhenPlots.csv` into `R` and do the following:

1. Find the X and Y coordinate locations. Which value is X and which value is Y?
2. These data were collected in a geographic coordinate system (WGS84). Convert
the `data.frame` into an `R` `spatialPointsDataFrame`.
3. Plot the new points with the plot location points from above. Be sure to add
a legend. Use a different symbol for the 2 new points!  You may need to adjust
the X and Y limits of your plot to ensure that both points are rendered by `R`!

If you have extra time, feel free to add roads and other layers to your map!

HINT: Refer to
[When Vector Data Don't Line Up - Handling Spatial Projection & CRS in R]({{site.baseurl}}/R/vector-data-reproject-crs-R/)
for more on working with geographic coordinate systems. You may want to "borrow"
the projection from the objects used in that tutorial!
</div>

```{r challenge-code-phen-plots, echo=FALSE, results="hide", warning=FALSE }
## 1
# Read the .csv file
newPlot.locations_HARV <- 
  read.csv("NEON-DS-Site-Layout-Files/HARV/HARV_2NewPhenPlots.csv",
           stringsAsFactors = FALSE)

# look at the data structure -> locations in lat/long
str(newPlot.locations_HARV)

## 2
## Find/ establish a CRS for new points
# Import the US boundary which is in a geographic WGS84 coordinate system
Country.Boundary.US <- readOGR("NEON-DS-Site-Layout-Files/US-Boundary-Layers",
          "US-Boundary-Dissolved-States")

# grab the geographic CRS
geogCRS <- crs(Country.Boundary.US)
geogCRS

## Convert to spatial data frame
# note that the easting and northing columns are in columns 1 and 2
newPlot.Sp.HARV <- SpatialPointsDataFrame(newPlot.locations_HARV[,2:1],
                    newPlot.locations_HARV,    # the R object to convert
                    proj4string = geogCRS)   # assign a CRS 
                                         
# view CRS
crs(newPlot.Sp.HARV)

## We now have the data imported and in WGS84 Lat/Long. We want to map with plot
# locations in UTM so we'll have to reproject. 

# remember we have a UTM Zone 18N crs object from previous code
utm18nCRS

# reproject the new points into UTM using `utm18nCRS`
newPlot.Sp.HARV.UTM <- spTransform(newPlot.Sp.HARV,
                                  utm18nCRS)
# check new plot CRS
crs(newPlot.Sp.HARV.UTM)

## 3
# create plot
plot(plot.locationsSp_HARV, 
     main="NEON Harvard Forest Field Site \nPlot Locations" )

plot(newPlot.Sp.HARV.UTM, 
     add=TRUE, pch=20, col="darkgreen")

# oops - looks like we are missing a point on our new plot. let's compare
# the spatial extents of both objects!
extent(plot.locationsSp_HARV)
extent(newPlot.Sp.HARV.UTM)

# when you plot in base plot, if the extent isn't specified, then the data that
# is added FIRST will define the extent of the plot
plot(extent(plot.locationsSp_HARV),
     main="Comparison of Spatial Object Extents\nPlot Locations vs New Plot Locations")
plot(extent(newPlot.Sp.HARV.UTM),
     col="darkgreen",
     add=TRUE)

# looks like the green box showing the newPlot extent extends
# beyond the plot.locations extent.

# We need to grab the x min and max and y min from our original plots
# but then the ymax from our new plots

originalPlotExtent <- extent(plot.locationsSp_HARV)
newPlotExtent <- extent(newPlot.Sp.HARV.UTM)

# set xmin and max
xmin <- originalPlotExtent@xmin
xmax <- originalPlotExtent@xmax
ymin <- originalPlotExtent@ymin
ymax <- newPlotExtent@ymax

# 3 again... re-plot
# try again but this time specify the x and ylims
# note: we could also write a function that would harvest the smallest and
# largest
# x and y values from an extent object. This is beyond the scope of this tutorial.
plot(plot.locationsSp_HARV, 
     main="NEON Harvard Forest Field Site\nVegetation & Phenology Plots",
     pch=8,
     col="purple",
     xlim=c(xmin,xmax),
     ylim=c(ymin,ymax))

plot(newPlot.Sp.HARV.UTM, 
     add=TRUE, pch=20, col="darkgreen")

# when we create a legend in R, we need to specify the text for each item 
# listed in the legend.
legend("bottomright", 
       legend=c("Vegetation Plots", "Phenology Plots"),
       pch=c(8,20), 
       bty="n", 
       col=c("purple","darkgreen"),
       cex=1.3)
```

## Export a Shapefile

We can write an `R` spatial object to a shapefile using the `writeOGR` function 
in `rgdal`. To do this we need the following arguments:

* the name of the spatial object (`plot.locationsSp_HARV`)
* the directory where we want to save our shapefile
           (to use `current = getwd()` or you can specify a different path)
* the name of the new shapefile  (`PlotLocations_HARV`)
* the driver which specifies the file format (ESRI Shapefile)

We can now export the spatial object as a shapefile. 

``` {r write-shapefile, warnings="hide", eval=FALSE}
# write a shapefile
writeOGR(plot.locationsSp_HARV, getwd(),
         "PlotLocations_HARV", driver="ESRI Shapefile")

```

