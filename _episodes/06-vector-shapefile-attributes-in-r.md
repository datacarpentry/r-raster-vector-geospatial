---
layout: post
title: "Vector 01: Explore Shapefile Attributes & Plot Shapefile Objects by
Attribute Value in R"
date:   2015-10-26
authors: [Joseph Stachelek, Leah A. Wasser, Megan A. Jones]
contributors: [Sarah Newman]
dateCreated:  2015-10-23
lastModified: 2017-09-07
packagesLibraries: [rgdal, raster]
categories: [self-paced-tutorial]
mainTag: vector-data-series
tags: [vector-data, R, spatial-data-gis]
tutorialSeries: [vector-data-series]
description: "This tutorial provides an overview of how to locate and query
shapefile attributes as well as subset shapefiles by specific attribute values
in R. It also covers plotting multiple shapefiles by attribute and building a 
custom plot legend. "
code1: /R/dc-spatial-vector/01-shapefile-attributes.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink:
permalink: /R/shapefile-attributes-in-R/
comments: true
---

## About
This tutorial explains what shapefile attributes are and how to work with 
shapefile attributes in `R`. It also covers how to identify and query shapefile
attributes, as well as subset shapefiles by specific attribute values. 
Finally, we will review how to plot a shapefile according to a set of attribute 
values.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

# Goals / Objectives
After completing this activity, you will:

 * Be able to query shapefile attributes.
 * Be able to subset shapefiles using specific attribute values.
 * Know how to plot a shapefile, colored by unique attribute values.
 
## Things You’ll Need To Complete This Tutorial
You will need the most current version of `R` and, preferably, `RStudio` loaded 
on your computer to complete this tutorial.

### Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}/R/Packages-In-R/)

## Download Data

****

</div>

## Shapefile Metadata & Attributes
When we import a shapefile into `R`, the `readOGR()` function automatically
stores metadata and attributes associated with the file.

## Load the Data
To work with vector data in `R`, we can use the `rgdal` library. The `raster` 
package also allows us to explore metadata using similar commands for both
raster and vector files. 

We will import three shapefiles. The first is our `AOI` or area of
interest boundary polygon that we worked with in 
[Open and Plot Shapefiles in R]({{site.baseurl}}/R/open-shapefiles-in-R/). 
The second is a shapefile containing the location of roads and trails within the
field site. The third is a file containing the Fisher tower location.

If you completed the
[Open and Plot Shapefiles in R]({{site.baseurl}}/R/open-shapefiles-in-R/) 
tutorial, you can skip this code.


```r
# load packages
# rgdal: for vector work; sp package should always load with rgdal. 
library(rgdal)  
# raster: for metadata/attributes- vectors or rasters
library (raster)   

# set working directory to data folder
# setwd("pathToDirHere")

# Import a polygon shapefile 
aoiBoundary_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                            "HarClip_UTMZ18")
```

```
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
```

```r
# Import a line shapefile
lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/", "HARV_roads")
```

```
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
```

```r
# Import a point shapefile 
point_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                      "HARVtower_UTM18N")
```

```
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
```

## Query Shapefile Metadata 
Remember, as covered in 
[Open and Plot Shapefiles in R]({{site.baseurl}}/R/open-shapefiles-in-R/),
we can view metadata associated with an `R` object using:

* `class()` - Describes the type of vector data stored in the object.
* `length()` - How many features are in this spatial object?
* object `extent()` - The spatial extent (geographic area covered by) features 
in the object.
* coordinate reference system (`crs()`) - The spatial projection that the data are
in. 

Let's explore the metadata for our `point_HARV` object. 


```r
# view class
class(x = point_HARV)
```

```
## Error in eval(expr, envir, enclos): object 'point_HARV' not found
```

```r
# x= isn't actually needed; it just specifies which object
# view features count
length(point_HARV)
```

```
## Error in eval(expr, envir, enclos): object 'point_HARV' not found
```

```r
# view crs - note - this only works with the raster package loaded
crs(point_HARV)
```

```
## Error in crs(point_HARV): object 'point_HARV' not found
```

```r
# view extent- note - this only works with the raster package loaded
extent(point_HARV)
```

```
## Error in extent(point_HARV): object 'point_HARV' not found
```

```r
# view metadata summary
point_HARV
```

```
## Error in eval(expr, envir, enclos): object 'point_HARV' not found
```

## About Shapefile Attributes
Shapefiles often contain an associated database or spreadsheet of values called
**attributes** that describe the vector features in the shapefile. You can think
of this like a spreadsheet with rows and columns. Each column in the spreadsheet
is an individual **attribute** that describes an object. Shapefile attributes
include measurements that correspond to the geometry of the shapefile features.

For example, the `HARV_Roads` shapefile (`lines_HARV` object) contains an
attribute called `TYPE`. Each line in the shapefile has an associated `TYPE` 
which describes the type of road (woods road, footpath, boardwalk, or 
stone wall).

<figure>
    <a href="{{ site.baseurl }}/images/dc-spatial-vector/Attribute_Table.png">
    <img src="{{ site.baseurl }}/images/dc-spatial-vector/Attribute_Table.png"></a>
    <figcaption>The shapefile format allows us to store attributes for each
    feature (vector object) stored in the shapefile. The attribute table, is 
    similar to a spreadsheet. There is a row for each feature. The first column
    contains the unique ID of the feature. We can add additional columns that
    describe the feature. Image Source: National Ecological Observatory Network
    (NEON) 
    </figcaption>
</figure>

We can look at all of the associated data attributes by printing the contents of
the `data` slot with `objectName@data`. We can use the base `R` `length` 
function to count the number of attributes associated with a spatial object too.


```r
# just view the attributes & first 6 attribute values of the data
head(lines_HARV@data)
```

```
## Error in head(lines_HARV@data): object 'lines_HARV' not found
```

```r
# how many attributes are in our vector data object?
length(lines_HARV@data)
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

We can view the individual **name of each attribute** using the
`names(lines_HARV@data)` method in `R`. We could also view just the first 6 rows
of attribute values using  `head(lines_HARV@data)`. 

Let's give it a try.


```r
# view just the attribute names for the lines_HARV spatial object
names(lines_HARV@data)
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

<div id="challenge" markdown="1">
## Challenge: Attributes for Different Spatial Classes
Explore the attributes associated with the `point_HARV` and `aoiBoundary_HARV` 
spatial objects. 

1. How many attributes do each have?
2. Who owns the site in the `point_HARV` data object?
3. Which of the following is NOT an attribute of the `point` data object?

    A) Latitude      B) County     C) Country
</div>


```
## Error in eval(expr, envir, enclos): object 'point_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'aoiBoundary_HARV' not found
```

```
## Error in head(point_HARV@data): object 'point_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'point_HARV' not found
```

## Explore Values within One Attribute
We can explore individual values stored within a particular attribute.
Again, comparing attributes to a spreadsheet or a `data.frame`, this is similar
to exploring values in a column. We can do this using the `$` and the name of
the attribute: `objectName$attributeName`. 


```r
# view all attributes in the lines shapefile within the TYPE field
lines_HARV$TYPE
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
# view unique values within the "TYPE" attributes
levels(lines_HARV@data$TYPE)
```

```
## Error in levels(lines_HARV@data$TYPE): object 'lines_HARV' not found
```

Notice that two of our TYPE attribute values consist of two separate words: 
stone wall and woods road. There are really four unique TYPE values, not six 
TYPE values.  

### Subset Shapefiles
We can use the `objectName$attributeName` syntax to select a subset of features
from a spatial object in `R`. 


```r
# select features that are of TYPE "footpath"
# could put this code into other function to only have that function work on
# "footpath" lines
lines_HARV[lines_HARV$TYPE == "footpath",]
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
# save an object with only footpath lines
footpath_HARV <- lines_HARV[lines_HARV$TYPE == "footpath",]
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
footpath_HARV
```

```
## Error in eval(expr, envir, enclos): object 'footpath_HARV' not found
```

```r
# how many features are in our new object
length(footpath_HARV)
```

```
## Error in eval(expr, envir, enclos): object 'footpath_HARV' not found
```

Our subsetting operation reduces the `features` count from 13 to 2. This means
that only two feature lines in our spatial object have the attribute
"TYPE=footpath".

We can plot our subsetted shapefiles.


```r
# plot just footpaths
plot(footpath_HARV,
     lwd=6,
     main="NEON Harvard Forest Field Site\n Footpaths")
```

```
## Error in plot(footpath_HARV, lwd = 6, main = "NEON Harvard Forest Field Site\n Footpaths"): object 'footpath_HARV' not found
```

Interesting. Above, it appeared as if we had 2 features in our footpaths subset.
Why does the plot look like there is only one feature?

Let's adjust the colors used in our plot. If we have 2 features in our vector
object, we can plot each using a unique color by assigning unique colors (`col=`)
to our features. We use the syntax

`col="c("colorOne","colorTwo")`

to do this.


```r
# plot just footpaths
plot(footpath_HARV,
     col=c("green","blue"), # set color for each feature 
     lwd=6,
     main="NEON Harvard Forest Field Site\n Footpaths \n Feature one = blue, Feature two= green")
```

```
## Error in plot(footpath_HARV, col = c("green", "blue"), lwd = 6, main = "NEON Harvard Forest Field Site\n Footpaths \n Feature one = blue, Feature two= green"): object 'footpath_HARV' not found
```

Now, we see that there are in fact two features in our plot! 


<div id="challenge" markdown="1">
## Challenge: Subset Spatial Line Objects
Subset out all:

1. `boardwalk` from the lines layer and plot it.
2. `stone wall` features from the lines layer and plot it. 

For each plot, color each feature using a unique color.
</div>


```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'boardwalk_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'boardwalk_HARV' not found
```

```
## Error in plot(boardwalk_HARV, col = c("green"), lwd = 6, main = "NEON Harvard Forest Field Site\n Boardwalks\n Feature one = blue, Feature two= green"): object 'boardwalk_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'stoneWall_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'stoneWall_HARV' not found
```

```
## Error in plot(stoneWall_HARV, col = c("green", "blue", "orange", "brown", : object 'stoneWall_HARV' not found
```

## Plot Lines by Attribute Value
To plot vector data with the color determined by a set of attribute values, the 
attribute values must be class = `factor`. A **factor** is similar to a category
- you can group vector objects by a particular category value - for example you 
can group all lines of `TYPE=footpath`. However, in `R`, a factor can also have 
a determined *order*. 

By default, `R` will import spatial object attributes as `factors`.

<i class="fa fa-star"></i> **Data Tip:** If our data attribute values are not 
read in as factors, we can convert the categorical 
attribute values using `as.factor()`.
{: .notice}


```r
# view the original class of the TYPE column
class(lines_HARV$TYPE)
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
# view levels or categories - note that there are no categories yet in our data!
# the attributes are just read as a list of character elements.
levels(lines_HARV$TYPE)
```

```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

```r
# Convert the TYPE attribute into a factor
# Only do this IF the data do not import as a factor!
# lines_HARV$TYPE <- as.factor(lines_HARV$TYPE)
# class(lines_HARV$TYPE)
# levels(lines_HARV$TYPE)

# how many features are in each category or level?
summary(lines_HARV$TYPE)
```

```
## Error in summary(lines_HARV$TYPE): object 'lines_HARV' not found
```

When we use `plot()`, we can specify the colors to use for each attribute using
the `col=` element. To ensure that `R` renders each feature by it's associated 
factor / attribute value, we need to create a `vector` or colors - one for each 
feature, according to it's associated attribute value / `factor` value. 

To create this vector we can use the following syntax:

`c("colorOne", "colorTwo","colorThree")[object$factor]`

Note in the above example we have 

1. a vector of colors - one for each factor value (unique attribute value)
2. the attribute itself (`[object$factor]`) of class `factor`.

Let's give this a try.



```r
# Check the class of the attribute - is it a factor?
class(lines_HARV$TYPE)
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
# how many "levels" or unique values does hte factor have?
# view factor values
levels(lines_HARV$TYPE)
```

```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

```r
# count the number of unique values or levels
length(levels(lines_HARV$TYPE))
```

```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

```r
# create a color palette of 4 colors - one for each factor level
roadPalette <- c("blue","green","grey","purple")
roadPalette
```

```
## [1] "blue"   "green"  "grey"   "purple"
```

```r
# create a vector of colors - one for each feature in our vector object
# according to its attribute value
roadColors <- c("blue","green","grey","purple")[lines_HARV$TYPE]
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
roadColors
```

```
## Error in eval(expr, envir, enclos): object 'roadColors' not found
```

```r
# plot the lines data, apply a diff color to each factor level)
plot(lines_HARV, 
     col=roadColors,
     lwd=3,
     main="NEON Harvard Forest Field Site\n Roads & Trails")
```

```
## Error in plot(lines_HARV, col = roadColors, lwd = 3, main = "NEON Harvard Forest Field Site\n Roads & Trails"): object 'lines_HARV' not found
```

### Adjust Line Width
We can also adjust the width of our plot lines using `lwd`. We can set all lines
to be thicker or thinner using `lwd=`. 


```r
# make all lines thicker
plot(lines_HARV, 
     col=roadColors,
     main="NEON Harvard Forest Field Site\n Roads & Trails\n All Lines Thickness=6",
     lwd=6)
```

```
## Error in plot(lines_HARV, col = roadColors, main = "NEON Harvard Forest Field Site\n Roads & Trails\n All Lines Thickness=6", : object 'lines_HARV' not found
```

### Adjust Line Width by Attribute

If we want a unique line width for each factor level or attribute category
in our spatial object, we can use the same syntax that we used for colors, above.

`lwd=c("widthOne", "widthTwo","widthThree")[object$factor]`

Note that this requires the attribute to be of class `factor`. Let's give it a 
try.


```r
class(lines_HARV$TYPE)
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
levels(lines_HARV$TYPE)
```

```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

```r
# create vector of line widths
lineWidths <- (c(1,2,3,4))[lines_HARV$TYPE]
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```r
# adjust line width by level
# in this case, boardwalk (the first level) is the narrowest.
plot(lines_HARV, 
     col=roadColors,
     main="NEON Harvard Forest Field Site\n Roads & Trails \n Line width varies by TYPE Attribute Value",
     lwd=lineWidths)
```

```
## Error in plot(lines_HARV, col = roadColors, main = "NEON Harvard Forest Field Site\n Roads & Trails \n Line width varies by TYPE Attribute Value", : object 'lines_HARV' not found
```

<div id="challenge" markdown="1">
## Challenge: Plot Line Width by Attribute 
We can customize the width of each line, according to specific attribute value,
too. To do this, we create a vector of line width values, and map that vector
to the factor levels - using the same syntax that we used above for colors.
HINT: `lwd=(vector of line width thicknesses)[spatialObject$factorAttribute]`

Create a plot of roads using the following line thicknesses:

1. woods road lwd=8
2. Boardwalks lwd = 2
3. footpath lwd=4
4. stone wall lwd=3
 
</div>


```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'lineWidth' not found
```

```
## Error in plot(lines_HARV, col = roadColors, main = "NEON Harvard Forest Field Site\n Roads & Trails \n Line width varies by Type Attribute Value", : object 'lines_HARV' not found
```

<i class="fa fa-star"></i> **Data Tip:** Given we have a factor with 4 levels, 
we can create an vector of numbers, each of which specifies the thickness of each
feature in our `SpatialLinesDataFrame` by factor level (category): `c(6,4,1,2)[lines_HARV$TYPE]`
{: .notice}

## Add Plot Legend
We can add a legend to our plot too. When we add a legend, we use the following
elements to specify labels and colors:

* `bottomright`: We specify the **location** of our legend by using a default 
keyword. We could also use `top`, `topright`, etc.
* `levels(objectName$attributeName)`: Label the **legend elements** using the
categories of `levels` in an attribute (e.g., levels(lines_HARV$TYPE) means use
the levels boardwalk, footpath, etc).
* `fill=`: apply unique **colors** to the boxes in our legend. `palette()` is 
the default set of colors that `R` applies to all plots. 

Let's add a legend to our plot.


```r
plot(lines_HARV, 
     col=roadColors,
     main="NEON Harvard Forest Field Site\n Roads & Trails\n Default Legend")
```

```
## Error in plot(lines_HARV, col = roadColors, main = "NEON Harvard Forest Field Site\n Roads & Trails\n Default Legend"): object 'lines_HARV' not found
```

```r
# we can use the color object that we created above to color the legend objects
roadPalette
```

```
## [1] "blue"   "green"  "grey"   "purple"
```

```r
# add a legend to our map
legend("bottomright",   # location of legend
      legend=levels(lines_HARV$TYPE), # categories or elements to render in 
			 # the legend
      fill=roadPalette) # color palette to use to fill objects in legend.
```

```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

We can tweak the appearance of our legend too.

* `bty=n`: turn off the legend BORDER
* `cex`: change the font size

Let's try it out.


```r
plot(lines_HARV, 
     col=roadColors,
     main="NEON Harvard Forest Field Site\n Roads & Trails \n Modified Legend")
```

```
## Error in plot(lines_HARV, col = roadColors, main = "NEON Harvard Forest Field Site\n Roads & Trails \n Modified Legend"): object 'lines_HARV' not found
```

```r
# add a legend to our map
legend("bottomright", 
       legend=levels(lines_HARV$TYPE), 
       fill=roadPalette, 
       bty="n", # turn off the legend border
       cex=.8) # decrease the font / legend size
```

```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

We can modify the colors used to plot our lines by creating a new color vector,
directly in the plot code too rather than creating a separate object.

`col=(newColors)[lines_HARV$TYPE]`

Let's try it!


```r
# manually set the colors for the plot!
newColors <- c("springgreen", "blue", "magenta", "orange")
newColors
```

```
## [1] "springgreen" "blue"        "magenta"     "orange"
```

```r
# plot using new colors
plot(lines_HARV, 
     col=(newColors)[lines_HARV$TYPE],
     main="NEON Harvard Forest Field Site\n Roads & Trails \n Pretty Colors")
```

```
## Error in plot(lines_HARV, col = (newColors)[lines_HARV$TYPE], main = "NEON Harvard Forest Field Site\n Roads & Trails \n Pretty Colors"): object 'lines_HARV' not found
```

```r
# add a legend to our map
legend("bottomright", 
       levels(lines_HARV$TYPE), 
       fill=newColors, 
       bty="n", cex=.8)
```

```
## Error in levels(lines_HARV$TYPE): object 'lines_HARV' not found
```

<i class="fa fa-star"></i> **Data Tip:** You can modify the defaul R color palette 
using the palette method. For example `palette(rainbow(6))` or
`palette(terrain.colors(6))`. You can reset the palette colors using
`palette("default")`!
{: .notice} 

<div id="challenge" markdown="1">
## Challenge: Plot Lines by Attribute
Create a plot that emphasizes only roads where bicycles and horses are allowed.
To emphasize this, make the lines where bicycles are not allowed THINNER than
the roads where bicycles are allowed.
NOTE: this attribute information is located in the `lines_HARV$BicyclesHo` 
attribute.

Be sure to add a title and legend to your map! You might consider a color
palette that has all bike/horse-friendly roads displayed in a bright color. All
other lines can be grey.

</div>


```
## Error in levels(lines_HARV$BicyclesHo): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```
## Error in as.factor(lines_HARV$BicyclesHo): object 'lines_HARV' not found
```

```
## Error in levels(lines_HARV$BicyclesHo): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```
## Error in levels(lines_HARV$BicyclesHo): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```
## Error in eval(expr, envir, enclos): object 'lines_HARV' not found
```

```
## Error in plot(lines_HARV, col = (challengeColors)[lines_HARV$BicyclesHo], : object 'lines_HARV' not found
```

```
## Error in levels(lines_HARV$BicyclesHo): object 'lines_HARV' not found
```

<div id="challenge" markdown="1">
## Challenge: Plot Polygon by Attribute

1. Create a map of the State boundaries in the United States using the data
located in your downloaded data folder: `NEON-DS-Site-Layout-Files/US-Boundary-Layers\US-State-Boundaries-Census-2014`. 
Apply a fill color to each state using its `region` value. Add a legend.

2. Using the `NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp` shapefile, 
create a map of study plot locations, with each point colored by the soil type
(`soilTypeOr`).  **Question:** How many different soil types are there at this particular field site? 

3. BONUS -- modify the field site plot above. Plot each point,
using a different symbol. HINT: you can assign the symbol using `pch=` value. 
You can create a vector object of symbols by factor level using the syntax
syntax that we used above to create a vector of lines widths and colors:
`pch=c(15,17)[lines_HARV$soilTypeOr]`. Type `?pch` to learn more about pch or 
use google to find a list of pch symbols that you can use in `R`.

</div>


```
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
```

```
## Error in levels(State.Boundary.US$region): object 'State.Boundary.US' not found
```

```
## Error in plot(State.Boundary.US, col = (colors)[State.Boundary.US$region], : object 'State.Boundary.US' not found
```

```
## Error in levels(State.Boundary.US$region): object 'State.Boundary.US' not found
```

```
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
```

```
## Error in unique(plotLocations$soilTypeOr): object 'plotLocations' not found
```

```
## Error in plot(plotLocations, col = (blueGreen)[plotLocations$soilTypeOr], : object 'plotLocations' not found
```

```
## Error in strwidth(legend, units = "user", cex = cex, font = text.font): plot.new has not been called yet
```

```
## Error in eval(expr, envir, enclos): object 'plotLocations' not found
```

```
## Error in eval(expr, envir, enclos): object 'plSymbols' not found
```

```
## Error in plot(plotLocations, col = plotLocations$soilTypeOr, pch = plSymbols, : object 'plotLocations' not found
```

```
## Error in strwidth(legend, units = "user", cex = cex, font = text.font): plot.new has not been called yet
```
