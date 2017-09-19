---
layout: page
title: Setup
permalink: /setup/
---
> ## Data
Data for this lesson is the National Ecological Observatory Network - available on FigShare as four parts: 
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
* [raster](https://cran.r-project.org/package=sf)

#### Download and install RStudio

Download and install [RStudio](https://www.rstudio.com/products/rstudio/download/#download).
Remember to download and install `R` first.

### Install the required workshop packages with RStudio

From the `R` prompt, type:

```r
install.packages(c("sf", "raster"))
```

### Help and more information

Use the **Help** menu and its options when needed.
