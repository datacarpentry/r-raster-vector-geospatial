---
layout: page
title: Setup
permalink: /setup/
---
> ## Data
Data for this lesson comes from the National Ecological Observatory Network - available on FigShare as four parts:
* [Site layout shapefiles](https://ndownloader.figshare.com/files/3708751)
* [Airborne remote sensing data](https://ndownloader.figshare.com/files/3701578)
* [Landsat NDVI raster data](https://ndownloader.figshare.com/files/4933582)
* [Meteorological data](https://ndownloader.figshare.com/files/3701572)
{: .prereq}

Once you click on them they will be automatically downloaded to your default download directory.

> ## Software
[R](http://cran.r-project.org) is a popular language for scientific computing, and great for general-purpose programming as well.
{: .prereq}

## Required `R` Packages for this workshop

* [sf](https://cran.r-project.org/package=sf)
* [raster](https://cran.r-project.org/package=raster)
* [rgdal](https://cran.r-project.org/package=rgdal)
* [rasterVis](https://cran.r-project.org/package=rasterVis)

#### Download and install RStudio

Download and install [RStudio](https://www.rstudio.com/products/rstudio/download/#download).
Remember to download and install `R` first.

### Install the required workshop packages with RStudio

From the `R` prompt, type:

```r
install.packages(c("sf", "raster", "rgdal", "rasterVis"))
```

### Help and more information

Use the **Help** menu and its options when needed.

## Setup a New Project

We are going to follow the instructions provided [here](http://www.datacarpentry.org/r-intro-geospatial/02-project-intro/)
 to set up a new RStudio Project for the remainder of this lesson.
Let's proceed as follows:

1. Click the "File" menu button, then "New Project".
2. Click "New Directory".
3. Click "Empty Project".
4. Type in "r-geospatial" as the name of the directory.
5. Click the "Create Project" button.

A key advantage of an RStudio Project is that whenever we open this project in
  subsequent RStudio sessions our working directory will *always* be set to the
  folder `r-geospatial.`
Let's check our working directory by entering the following into the R console:

```{r}
getwd()
```

R should return `your/path/r-geospatial` as the working directory.

### Moving Downloaded Data

Now we want to move the data that we downloaded above into a subdirectory
 inside `r-geospatial`.

1. Create a new directory called `data` inside our working directory.
2. Copy across the downloaded .zip files to the `data` directory.
3. Once the data have been moved, unzip all files.

Once you have completed moving the data across to the new folder,
 your data directory should look as follows:

 ```
 data/
    NEON-DS-Airborne-Remote-Sensing/
    NEON-DS-Landsat-NDVI/
    NEON-DS-Met-Time-Series/
    NEON-DS-Site-Layout-Files/
    NEON-DS-Airborne-Remote-Sensing.zip
    NEON-DS-Landsat-NDVI.zip
    NEON-DS-Met-Time-Series.zip
    NEON-DS-Site-Layout-Files.zip
 ```
