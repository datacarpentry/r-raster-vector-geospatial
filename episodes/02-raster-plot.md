---
title: "Plot Raster Data in R"
teaching: 10
exercises: 0
questions:
- ""
objectives:
- "Know how to plot a single band raster in `R`."
- "Know how to layer a raster dataset on top of a hillshade to create an elegant basemap."
keypoints:
- ""
authors: [Leah A. Wasser, Megan A. Jones, Zack Brym, Kristina Riemer, Jason Williams, Jeff Hollister,  Mike Smorul, Joseph Stachelek]
contributors: [ ]
packagesLibraries: [raster, rgdal, dplyr, ggplot2]
dateCreated:  2015-10-23
lastModified: 2018-06-19
categories:  [self-paced-tutorial]
tags: [R, raster, spatial-data-gis]
tutorialSeries: [raster-data-series]
mainTag: raster-data-series
description: "This tutorial explains how to plot a raster in R using R's base plot
function. It also covers how to layer a raster on top of a hillshade to produce
an eloquent map."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink:
comments: true
---



This tutorial reviews how to plot a raster in `R` using the `plot()`
function. It also covers how to layer a raster on top of a hillshade to produce
an eloquent map.

## Plot Raster Data in R
In this tutorial, we will plot the Digital Surface Model (DSM) raster
for the NEON Harvard Forest Field Site. We will use the `hist()` function as a
tool to explore raster values. And render categorical plots, using the `breaks` argument to get bins that are meaningful representations of our data.

We will use the `raster` and `rgdal` packages in this tutorial. If you do not
have the `DSM_HARV` object from the
[Intro To Raster In R tutorial]({{ site.baseurl }}/R/Introduction-to-Raster-Data-In-R/),
please create it now.


~~~
# if they are not already loaded
library(rgdal)
~~~
{: .r}



~~~
Loading required package: sp
~~~
{: .output}



~~~
rgdal: version: 1.3-2, (SVN revision 755)
 Geospatial Data Abstraction Library extensions to R successfully loaded
 Loaded GDAL runtime: GDAL 2.1.3, released 2017/20/01
 Path to GDAL shared files: /Library/Frameworks/R.framework/Versions/3.5/Resources/library/rgdal/gdal
 GDAL binary built with GEOS: FALSE 
 Loaded PROJ.4 runtime: Rel. 4.9.3, 15 August 2016, [PJ_VERSION: 493]
 Path to PROJ.4 shared files: /Library/Frameworks/R.framework/Versions/3.5/Resources/library/rgdal/proj
 Linking to sp version: 1.3-1 
~~~
{: .output}



~~~
library(raster)

# import raster
DSM_HARV <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
~~~
{: .r}

First, let's plot our Digital Surface Model object (`DSM_HARV`) using the
`plot()` function. We add a title using the argument `main = "title"`.


~~~
library(ggplot2)

# convert to a df for plotting in two steps,
# First, to a SpatialPointsDataFrame
DSM_HARV_pts <- rasterToPoints(DSM_HARV, spatial = TRUE)
# Then to a 'conventional' dataframe
DSM_HARV_df  <- data.frame(DSM_HARV_pts)
rm(DSM_HARV_pts, DSM_HARV)

ggplot() +
 geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = HARV_dsmCrop)) + 
    ggtitle("Continuous Elevation Map - NEON Harvard Forest Field Site")
~~~
{: .r}

<img src="../fig/rmd-02-ggplot-raster-1.png" title="plot of chunk ggplot-raster" alt="plot of chunk ggplot-raster" style="display: block; margin: auto;" />

## Plotting Data Using Breaks
We can view our data "symbolized" or colored according to ranges of values
rather than using a continuous color ramp. This is comparable to a "classified"
map. However, to assign breaks, it is useful to first explore the distribution
of the data using a bar plot. 
We use `dplyr`'s mutate to combined with `cut()` to split the data into 3 bins.



~~~
library(dplyr)
~~~
{: .r}



~~~

Attaching package: 'dplyr'
~~~
{: .output}



~~~
The following objects are masked from 'package:raster':

    intersect, select, union
~~~
{: .output}



~~~
The following objects are masked from 'package:stats':

    filter, lag
~~~
{: .output}



~~~
The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union
~~~
{: .output}



~~~
DSM_HARV_df <- DSM_HARV_df %>%
                mutate(fct_elevation = cut(HARV_dsmCrop, breaks = 3))

ggplot() +
    geom_bar(data = DSM_HARV_df, aes(fct_elevation)) +
    xlab("Elevation (m)") +
    ggtitle("Histogram Digital Surface Model - NEON Harvard Forest Field Site")
~~~
{: .r}

<img src="../fig/rmd-02-histogram-breaks-ggplot-1.png" title="plot of chunk histogram-breaks-ggplot" alt="plot of chunk histogram-breaks-ggplot" style="display: block; margin: auto;" />

If we are want to know what the bins are we can ask for the unique values 
of `fct_elavation`:

~~~
unique(DSM_HARV_df$fct_elevation)
~~~
{: .r}



~~~
[1] (379,416] (342,379] (305,342]
Levels: (305,342] (342,379] (379,416]
~~~
{: .output}

And we can get the count of values in each bin using `dplyr`'s 
`group_by` and `summarize`:


~~~
DSM_HARV_df %>%
        group_by(fct_elevation) %>%
        summarize(counts = n())
~~~
{: .r}



~~~
# A tibble: 3 x 2
  fct_elevation  counts
  <fct>           <int>
1 (305,342]      418891
2 (342,379]     1530073
3 (379,416]      370835
~~~
{: .output}

We can customize the break points for the bins that `cut()` yields using the 
`breaks` variable in a different way. 
Lets round the breaks so that we have bins ranges of 
300-349m, 350 - 399m, and 400-450m.
To implement this we pass a numeric vector of break points instead 
of the number of breaks we want.


~~~
custom_bins <- c(300, 350, 400, 450)

DSM_HARV_df <- DSM_HARV_df %>%
                mutate(fct_elevation_2 = cut(HARV_dsmCrop, breaks = custom_bins))

unique(DSM_HARV_df$fct_elevation_2)
~~~
{: .r}



~~~
[1] (400,450] (350,400] (300,350]
Levels: (300,350] (350,400] (400,450]
~~~
{: .output}

> ## Data Tip
> Note that when we assign break values a set of 4 values will result in 3 bins of data.
{: .callout}

And now we can plot our bar plot again, using the new bins:


~~~
ggplot() +
    geom_bar(data = DSM_HARV_df, aes(fct_elevation_2)) +
    xlab("Elevation (m)") +
    ggtitle("Histogram Digital Surface Model - NEON Harvard Forest Field Site \nCustom Bin Ranges")
~~~
{: .r}

<img src="../fig/rmd-02-unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />

We can also look at the how frequent each occurence of our bins is:


~~~
DSM_HARV_df %>%
        group_by(fct_elevation_2) %>%
        summarize(counts = n())
~~~
{: .r}



~~~
# A tibble: 3 x 2
  fct_elevation_2  counts
  <fct>             <int>
1 (300,350]        741815
2 (350,400]       1567316
3 (400,450]         10668
~~~
{: .output}



We can use those bins to plot our raster data:


~~~
ggplot() +
 geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation_2)) + 
    ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site")
~~~
{: .r}

<img src="../fig/rmd-02-ggplot-with-breaks-1.png" title="plot of chunk ggplot-with-breaks" alt="plot of chunk ggplot-with-breaks" style="display: block; margin: auto;" />


The plot above uses the default colors inside `ggplot` for raster objects. 
We can specify our own colors to make the plot look a little nicer.
`R` has a built in set of colors for plotting terrain, which are built in
to the `terrain.colors` function.
Since we have three bins, we want to use the first three terrain colors:


~~~
terrain.colors(3)
~~~
{: .r}



~~~
[1] "#00A600FF" "#ECB176FF" "#F2F2F2FF"
~~~
{: .output}

We can see the `terrain.colors()` function returns *hex colors* - 
 each of these character strings represents a color.
To use these in our map, we pass them across using the 
 `scale_fill_manual()` function.


~~~
ggplot() +
 geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                      fill = fct_elevation_2)) + 
    scale_fill_manual(values = terrain.colors(3)) + 
    ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site")
~~~
{: .r}

<img src="../fig/rmd-02-ggplot-breaks-customcolors-1.png" title="plot of chunk ggplot-breaks-customcolors" alt="plot of chunk ggplot-breaks-customcolors" style="display: block; margin: auto;" />


### More Plot Formatting

If we need to create multiple plots using the same color palette, we can create
an `R` object (`my_col`) for the set of colors that we want to use. We can then
quickly change the palette across all plots by simply modifying the `my_col`
object.

We can label the x- and y-axes of our plot too using `xlab` and `ylab`.
We can also give the legend a more meaningful title by passing a value 
to the `name` option of `scale_fill_manual.`


~~~
# Assign color to a object for repeat use/ ease of changing
my_col <- terrain.colors(3)

ggplot() +
 geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                      fill = fct_elevation_2)) + 
    scale_fill_manual(values = my_col, name = "Elevation") + 
    ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site") +
    xlab("UTM Westing Coordinate (m)") +
    ylab("UTM Northing Coordinate (m)")
~~~
{: .r}

<img src="../fig/rmd-02-add-ggplot-labels-1.png" title="plot of chunk add-ggplot-labels" alt="plot of chunk add-ggplot-labels" style="display: block; margin: auto;" />

Or we can also turn off the axes altogether via passing `element_blank()` to
the relevant parts of the `theme()` function.


~~~
# or we can turn off the axis altogether
ggplot() +
 geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                      fill = fct_elevation_2)) + 
    scale_fill_manual(values = my_col, name = "Elevation") + 
    ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site") +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank())
~~~
{: .r}

<img src="../fig/rmd-02-turn-off-axes-1.png" title="plot of chunk turn-off-axes" alt="plot of chunk turn-off-axes" style="display: block; margin: auto;" />


> ## Challenge: Plot Using Custom Breaks
>
> Create a plot of the Harvard Forest Digital Surface Model (DSM) that has:
>
> 1. Six classified ranges of values (break points) that are evenly divided among the range of pixel values.
> 2. Axis labels
> 3. A plot title
>
> > ## Answers
> > <img src="../fig/rmd-02-challenge-code-plotting-1.png" title="plot of chunk challenge-code-plotting" alt="plot of chunk challenge-code-plotting" style="display: block; margin: auto;" />
> {: .solution}
{: .challenge}

## Layering Rasters
We can layer a raster on top of a hillshade raster for the same area, and use a
transparency factor to created a 3-dimensional shaded effect. A
hillshade is a raster that maps the shadows and texture that you would see from
above when viewing terrain.
We will add a custom color, making the plot grey. 


~~~
# import DSM hillshade
DSM_hill_HARV <-
  raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

# convert to a df for plotting in two steps,
# First, to a SpatialPointsDataFrame
DSM_hill_HARV_pts <- rasterToPoints(DSM_hill_HARV, spatial = TRUE)
# Then to a 'conventional' dataframe
DSM_hill_HARV_df  <- data.frame(DSM_hill_HARV_pts)
rm(DSM_hill_HARV_pts, DSM_hill_HARV)

ggplot() +
 geom_raster(data = DSM_hill_HARV_df , aes(x = x, y = y, alpha = HARV_DSMhill)) + 
    scale_alpha(range =  c(0.15, 0.65), guide = "none") +
    ggtitle("Hillshade - DSM - NEON Harvard Forest Field Site") +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank())
~~~
{: .r}

<img src="../fig/rmd-02-hillshade-1.png" title="plot of chunk hillshade" alt="plot of chunk hillshade" style="display: block; margin: auto;" />


> ## Data Tip
> Turn off, or hide, the legend on a plot using by adding `guide = "none"` 
to a `scale_something()` function or by setting
`theme(legend.position="none")`.
{: .callout}

We can layer another raster on top of our hillshade using by using `add = TRUE`.
Let's overlay `DSM_HARV` on top of the `hill_HARV`.


~~~
ggplot() +
    geom_raster(data = DSM_HARV_df , 
                aes(x = x, y = y, 
                     fill = HARV_dsmCrop,
                     alpha=0.8)
                ) + 
    geom_raster(data = DSM_hill_HARV_df, 
                aes(x = x, y = y, 
                  alpha = HARV_DSMhill)
                ) +
    scale_fill_gradientn(name = "Elevation", colors = rainbow(100)) +
    guides(fill = guide_colorbar()) +
    scale_alpha(range = c(0.15, 0.65), guide = "none") +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank()) +
    ggtitle("DSM with Hillshade - NEON Harvard Forest Field Site") +
    coord_equal()
~~~
{: .r}

<img src="../fig/rmd-02-overlay-hillshade-1.png" title="plot of chunk overlay-hillshade" alt="plot of chunk overlay-hillshade" style="display: block; margin: auto;" />


The alpha value determines how transparent the colors will be (0 being
transparent, 1 being opaque). Note that here we used the color palette
`rainbow()` instead of `terrain.color()`.

* More information in the
<a href="https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/palettes.html" target="_blank">`R` color palettes documentation</a>.

> ## Challenge: Create DTM & DSM for SJER
> 
> Use the files in the `NEON_RemoteSensing/SJER/` directory to create a Digital
Terrain Model map and Digital Surface Model map of the San Joaquin Experimental
Range field site.
> 
> Make sure to:
> 
> * include hillshade in the maps,
> * label axes on the DSM map and exclude them from the DTM map,
> * a title for the maps,
> * experiment with various alpha values and color palettes to represent the
 data.
>
> > ## Answers
> > 
> > 
> > ~~~
> > # CREATE DSM MAPS
> > 
> > # import DSM data
> > DSM_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
> > # convert to a df for plotting in two steps,
> > # First, to a SpatialPointsDataFrame
> > DSM_SJER_pts <- rasterToPoints(DSM_SJER, spatial = TRUE)
> > # Then to a 'conventional' dataframe
> > DSM_SJER_df  <- data.frame(DSM_SJER_pts)
> > rm(DSM_SJER_pts, DSM_SJER)
> > 
> > # import DSM hillshade
> > DSM_hill_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmHill.tif")
> > # convert to a df for plotting in two steps,
> > # First, to a SpatialPointsDataFrame
> > DSM_hill_SJER_pts <- rasterToPoints(DSM_hill_SJER, spatial = TRUE)
> > # Then to a 'conventional' dataframe
> > DSM_hill_SJER_df  <- data.frame(DSM_hill_SJER_pts)
> > rm(DSM_hill_SJER_pts, DSM_hill_SJER)
> > 
> > # Build Plot
> > ggplot() +
> >     geom_raster(data = DSM_SJER_df , 
> >                 aes(x = x, y = y, 
> >                      fill = SJER_dsmCrop,
> >                      alpha=0.8)
> >                 ) + 
> >     geom_raster(data = DSM_hill_SJER_df, 
> >                 aes(x = x, y = y, 
> >                   alpha = SJER_dsmHill)
> >                 ) +
> >     scale_fill_gradientn(name = "Elevation", colors = terrain.colors(100)) +
> >     guides(fill = guide_colorbar()) +
> >     scale_alpha(range = c(0.4, 0.7), guide = "none") +
> >     # remove grey background and grid lines
> >     theme_bw() + 
> >     theme(panel.grid.major = element_blank(), 
> >           panel.grid.minor = element_blank()) +
> >     xlab("UTM Westing Coordinate (m)") +
> >     ylab("UTM Northing Coordinate (m)") +
> >     ggtitle("DSM with Hillshade - NEON SJER Field Site") +
> >     coord_equal()
> > ~~~
> > {: .r}
> > 
> > <img src="../fig/rmd-02-challenge-hillshade-layering-1.png" title="plot of chunk challenge-hillshade-layering" alt="plot of chunk challenge-hillshade-layering" style="display: block; margin: auto;" />
> > 
> > ~~~
> > # CREATE SJER DTM MAP
> > # import DTM
> > DTM_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")
> > DTM_SJER_pts <- rasterToPoints(DTM_SJER, spatial = TRUE)
> > DTM_SJER_df  <- data.frame(DTM_SJER_pts)
> > rm(DTM_SJER_pts, DTM_SJER)
> > 
> > # DTM Hillshade
> > DTM_hill_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmHill.tif")
> > DTM_hill_SJER_pts <- rasterToPoints(DTM_hill_SJER, spatial = TRUE)
> > DTM_hill_SJER_df  <- data.frame(DTM_hill_SJER_pts)
> > rm(DTM_hill_SJER_pts, DTM_hill_SJER)
> > 
> > ggplot() +
> >     geom_raster(data = DTM_SJER_df ,
> >                 aes(x = x, y = y,
> >                      fill = SJER_dtmCrop,
> >                      alpha = 2.0)
> >                 ) +
> >     geom_raster(data = DTM_hill_SJER_df,
> >                 aes(x = x, y = y,
> >                   alpha = SJER_dtmHill)
> >                 ) +
> >     scale_fill_gradientn(name = "Elevation", colors = terrain.colors(100)) +
> >     guides(fill = guide_colorbar()) +
> >     scale_alpha(range = c(0.4, 0.7), guide = "none") +
> >     theme_bw() +
> >     theme(panel.grid.major = element_blank(), 
> >           panel.grid.minor = element_blank()) +
> >     theme(axis.title.x = element_blank(),
> >           axis.title.y = element_blank()) +
> >     ggtitle("DTM with Hillshade - NEON SJER Field Site") +
> >     coord_equal()
> > ~~~
> > {: .r}
> > 
> > <img src="../fig/rmd-02-challenge-hillshade-layering-2.png" title="plot of chunk challenge-hillshade-layering" alt="plot of chunk challenge-hillshade-layering" style="display: block; margin: auto;" />
> {: .solution}
{: .challenge}




