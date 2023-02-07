---
title: Reproject Raster Data
teaching: 40
exercises: 20
source: Rmd
---



::::::::::::::::::::::::::::::::::::::: objectives

- Reproject a raster in R.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I work with raster data sets that are in different projections?

::::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::::::::  prereq

## Things You'll Need To Complete This Episode

See the [lesson homepage](.) for detailed information about the software,
data, and other prerequisites you will need to work through the examples in this episode.


::::::::::::::::::::::::::::::::::::::::::::::::::

Sometimes we encounter raster datasets that do not "line up" when plotted or
analyzed. Rasters that don't line up are most often in different Coordinate
Reference Systems (CRS). This episode explains how to deal with rasters in different, known CRSs. It
will walk though reprojecting rasters in R using the `projectRaster()`
function in the `raster` package.

## Raster Projection in R

In the [Plot Raster Data in R](02-raster-plot/)
episode, we learned how to layer a raster file on top of a hillshade for a nice
looking basemap. In that episode, all of our data were in the same CRS. What
happens when things don't line up?

For this episode, we will be working with the Harvard Forest Digital Terrain
Model data. This differs from the surface model data we've been working with so
far in that the digital surface model (DSM) includes the tops of trees, while
the digital terrain model (DTM) shows the ground level.

We'll be looking at another model (the canopy height model) in
[a later episode](04-raster-calculations-in-r/) and will see how to calculate the CHM from the
DSM and DTM. Here, we will create a map of the Harvard Forest Digital
Terrain Model
(`DTM_HARV`) draped or layered on top of the hillshade (`DTM_hill_HARV`).
The hillshade layer maps the terrain using light and shadow to create a 3D-looking image,
based on a hypothetical illumination of the ground level.

![](fig/dc-spatial-raster/lidarTree-height.png){alt='Source: National Ecological Observatory Network (NEON).'}

First, we need to import the DTM and DTM hillshade data.


```r
DTM_HARV <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")

DTM_hill_HARV <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")
```

Next, we will convert each of these datasets to a dataframe for
plotting with `ggplot`.


```r
DTM_HARV_df <- as.data.frame(DTM_HARV, xy = TRUE)

DTM_hill_HARV_df <- as.data.frame(DTM_hill_HARV, xy = TRUE)
```

Now we can create a map of the DTM layered over the hillshade.


```r
ggplot() +
     geom_raster(data = DTM_HARV_df , 
                 aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
     geom_raster(data = DTM_hill_HARV_df, 
                 aes(x = x, y = y, 
                   alpha = HARV_DTMhill_WGS84)) +
     scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
     coord_quickmap()
```

<img src="fig/03-raster-reproject-in-r-rendered-unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

Our results are curious - neither the Digital Terrain Model (`DTM_HARV_df`)
nor the DTM Hillshade (`DTM_hill_HARV_df`) plotted.
Let's try to
plot the DTM on its own to make sure there are data there.


```r
ggplot() +
geom_raster(data = DTM_HARV_df,
    aes(x = x, y = y,
    fill = HARV_dtmCrop)) +
scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
coord_quickmap()
```

<img src="fig/03-raster-reproject-in-r-rendered-plot-DTM-1.png" style="display: block; margin: auto;" />

Our DTM seems to contain data and plots just fine.

Next we plot the DTM Hillshade on its own to see whether everything is OK.


```r
ggplot() +
geom_raster(data = DTM_hill_HARV_df,
    aes(x = x, y = y,
    alpha = HARV_DTMhill_WGS84)) + 
    coord_quickmap()
```

<img src="fig/03-raster-reproject-in-r-rendered-plot-DTM-hill-1.png" style="display: block; margin: auto;" />

If we look at the axes, we can see that the projections of the two rasters are different.
When this is the case, `ggplot` won't render the image. It won't even
throw an error message to tell you something has gone wrong. We can look at Coordinate Reference Systems (CRSs) of the DTM and
the hillshade data to see how they differ.

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise

View the CRS for each of these two datasets. What projection
does each use?

:::::::::::::::  solution

## Solution


```r
# view crs for DTM
crs(DTM_HARV)
```

```{.output}
Coordinate Reference System:
Deprecated Proj.4 representation:
 +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
WKT2 2019 representation:
PROJCRS["unknown",
    BASEGEOGCRS["unknown",
        DATUM["World Geodetic System 1984",
            ELLIPSOID["WGS 84",6378137,298.257223563,
                LENGTHUNIT["metre",1]],
            ID["EPSG",6326]],
        PRIMEM["Greenwich",0,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8901]]],
    CONVERSION["UTM zone 18N",
        METHOD["Transverse Mercator",
            ID["EPSG",9807]],
        PARAMETER["Latitude of natural origin",0,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8801]],
        PARAMETER["Longitude of natural origin",-75,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8802]],
        PARAMETER["Scale factor at natural origin",0.9996,
            SCALEUNIT["unity",1],
            ID["EPSG",8805]],
        PARAMETER["False easting",500000,
            LENGTHUNIT["metre",1],
            ID["EPSG",8806]],
        PARAMETER["False northing",0,
            LENGTHUNIT["metre",1],
            ID["EPSG",8807]],
        ID["EPSG",16018]],
    CS[Cartesian,2],
        AXIS["(E)",east,
            ORDER[1],
            LENGTHUNIT["metre",1,
                ID["EPSG",9001]]],
        AXIS["(N)",north,
            ORDER[2],
            LENGTHUNIT["metre",1,
                ID["EPSG",9001]]]] 
```

```r
# view crs for hillshade
crs(DTM_hill_HARV)
```

```{.output}
Coordinate Reference System:
Deprecated Proj.4 representation: +proj=longlat +datum=WGS84 +no_defs 
WKT2 2019 representation:
GEOGCRS["unknown",
    DATUM["World Geodetic System 1984",
        ELLIPSOID["WGS 84",6378137,298.257223563,
            LENGTHUNIT["metre",1]],
        ID["EPSG",6326]],
    PRIMEM["Greenwich",0,
        ANGLEUNIT["degree",0.0174532925199433],
        ID["EPSG",8901]],
    CS[ellipsoidal,2],
        AXIS["longitude",east,
            ORDER[1],
            ANGLEUNIT["degree",0.0174532925199433,
                ID["EPSG",9122]]],
        AXIS["latitude",north,
            ORDER[2],
            ANGLEUNIT["degree",0.0174532925199433,
                ID["EPSG",9122]]]] 
```

`DTM_HARV` is in the UTM projection, with units of meters.
`DTM_hill_HARV` is in
`Geographic WGS84` - which is represented by latitude and longitude values.



:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

Because the two rasters are in different CRSs, they don't line up when plotted
in R. We need to reproject (or change the projection of) `DTM_hill_HARV` into the UTM CRS. Alternatively,
we could reproject `DTM_HARV` into WGS84.

## Reproject Rasters

We can use the `projectRaster()` function to reproject a raster into a new CRS.
Keep in mind that reprojection only works when you first have a defined CRS
for the raster object that you want to reproject. It cannot be used if no
CRS is defined. Lucky for us, the `DTM_hill_HARV` has a defined CRS.

:::::::::::::::::::::::::::::::::::::::::  callout

## Data Tip

When we reproject a raster, we
move it from one "grid" to another. Thus, we are modifying the data! Keep this
in mind as we work with raster data.


::::::::::::::::::::::::::::::::::::::::::::::::::

To use the `projectRaster()` function, we need to define two things:

1. the object we want to reproject and
2. the CRS that we want to reproject it to.

The syntax is `projectRaster(RasterObject, crs = CRSToReprojectTo)`

We want the CRS of our hillshade to match the `DTM_HARV` raster. We can thus
assign the CRS of our `DTM_HARV` to our hillshade within the `projectRaster()`
function as follows: `crs = crs(DTM_HARV)`.
Note that we are using the `projectRaster()` function on the raster object,
not the `data.frame()` we use for plotting with `ggplot`.

First we will reproject our `DTM_hill_HARV` raster data to match the `DTM_HARV` raster CRS:


```r
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV,
                                       crs = crs(DTM_HARV))
```

Now we can compare the CRS of our original DTM hillshade
and our new DTM hillshade, to see how they are different.


```r
crs(DTM_hill_UTMZ18N_HARV)
```

```{.output}
Coordinate Reference System:
Deprecated Proj.4 representation:
 +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
WKT2 2019 representation:
PROJCRS["unknown",
    BASEGEOGCRS["unknown",
        DATUM["World Geodetic System 1984",
            ELLIPSOID["WGS 84",6378137,298.257223563,
                LENGTHUNIT["metre",1]],
            ID["EPSG",6326]],
        PRIMEM["Greenwich",0,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8901]]],
    CONVERSION["UTM zone 18N",
        METHOD["Transverse Mercator",
            ID["EPSG",9807]],
        PARAMETER["Latitude of natural origin",0,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8801]],
        PARAMETER["Longitude of natural origin",-75,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8802]],
        PARAMETER["Scale factor at natural origin",0.9996,
            SCALEUNIT["unity",1],
            ID["EPSG",8805]],
        PARAMETER["False easting",500000,
            LENGTHUNIT["metre",1],
            ID["EPSG",8806]],
        PARAMETER["False northing",0,
            LENGTHUNIT["metre",1],
            ID["EPSG",8807]],
        ID["EPSG",16018]],
    CS[Cartesian,2],
        AXIS["(E)",east,
            ORDER[1],
            LENGTHUNIT["metre",1,
                ID["EPSG",9001]]],
        AXIS["(N)",north,
            ORDER[2],
            LENGTHUNIT["metre",1,
                ID["EPSG",9001]]]] 
```

```r
crs(DTM_hill_HARV)
```

```{.output}
Coordinate Reference System:
Deprecated Proj.4 representation: +proj=longlat +datum=WGS84 +no_defs 
WKT2 2019 representation:
GEOGCRS["unknown",
    DATUM["World Geodetic System 1984",
        ELLIPSOID["WGS 84",6378137,298.257223563,
            LENGTHUNIT["metre",1]],
        ID["EPSG",6326]],
    PRIMEM["Greenwich",0,
        ANGLEUNIT["degree",0.0174532925199433],
        ID["EPSG",8901]],
    CS[ellipsoidal,2],
        AXIS["longitude",east,
            ORDER[1],
            ANGLEUNIT["degree",0.0174532925199433,
                ID["EPSG",9122]]],
        AXIS["latitude",north,
            ORDER[2],
            ANGLEUNIT["degree",0.0174532925199433,
                ID["EPSG",9122]]]] 
```

We can also compare the extent of the two objects.


```r
extent(DTM_hill_UTMZ18N_HARV)
```

```{.output}
class      : Extent 
xmin       : 731397.3 
xmax       : 733205.3 
ymin       : 4712403 
ymax       : 4713907 
```

```r
extent(DTM_hill_HARV)
```

```{.output}
class      : Extent 
xmin       : -72.18192 
xmax       : -72.16061 
ymin       : 42.52941 
ymax       : 42.54234 
```

Notice in the output above that the `crs()` of `DTM_hill_UTMZ18N_HARV` is now
UTM. However, the extent values of `DTM_hillUTMZ18N_HARV` are different from
`DTM_hill_HARV`.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge: Extent Change with CRS Change

Why do you think the two extents differ?

:::::::::::::::  solution

## Answers

The extent for DTM\_hill\_UTMZ18N\_HARV is in UTMs so the extent is in meters. The extent for DTM\_hill\_HARV is in lat/long so the extent is expressed
in decimal degrees.



:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Deal with Raster Resolution

Let's next have a look at the resolution of our reprojected hillshade versus our original data.


```r
res(DTM_hill_UTMZ18N_HARV)
```

```{.output}
[1] 1.000 0.998
```

```r
res(DTM_HARV)
```

```{.output}
[1] 1 1
```

These two resolutions are different, but they're representing the same data. We can tell R to force our
newly reprojected raster to be 1m x 1m resolution by adding a line of code
`res=1` within the `projectRaster()` function. In the example below, we ensure a resolution match by using `res(DTM_HARV)` as a variable.


```r
  DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV,
                                         crs = crs(DTM_HARV),
                                         res = res(DTM_HARV)) 
```

Now both our resolutions and our CRSs match, so we can plot these two data sets together. Let's double-check our resolution to be sure:


```r
res(DTM_hill_UTMZ18N_HARV)
```

```{.output}
[1] 1 1
```

```r
res(DTM_HARV)
```

```{.output}
[1] 1 1
```

For plotting with `ggplot()`, we will need to create a dataframe from our newly reprojected raster.


```r
DTM_hill_HARV_2_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy = TRUE)
```

We can now create a plot of this data.


```r
ggplot() +
     geom_raster(data = DTM_HARV_df , 
                 aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
     geom_raster(data = DTM_hill_HARV_2_df, 
                 aes(x = x, y = y, 
                   alpha = HARV_DTMhill_WGS84)) +
     scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
     coord_quickmap()
```

<img src="fig/03-raster-reproject-in-r-rendered-plot-projected-raster-1.png" style="display: block; margin: auto;" />

We have now successfully draped the Digital Terrain Model on top of our
hillshade to produce a nice looking, textured map!

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge: Reproject, then Plot a Digital Terrain Model

Create a map of the
[San Joaquin Experimental Range](https://www.neonscience.org/field-sites/field-sites-map/SJER)
field site using the `SJER_DSMhill_WGS84.tif` and `SJER_dsmCrop.tif` files.

Reproject the data as necessary to make things line up!

:::::::::::::::  solution

## Answers


```r
# import DSM
DSM_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
# import DSM hillshade
DSM_hill_SJER_WGS <-
raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")

# reproject raster
DTM_hill_UTMZ18N_SJER <- projectRaster(DSM_hill_SJER_WGS,
                                  crs = crs(DSM_SJER),
                                  res = 1)

# convert to data.frames
DSM_SJER_df <- as.data.frame(DSM_SJER, xy = TRUE)

DSM_hill_SJER_df <- as.data.frame(DTM_hill_UTMZ18N_SJER, xy = TRUE)

ggplot() +
     geom_raster(data = DSM_hill_SJER_df, 
                 aes(x = x, y = y, 
                   alpha = SJER_DSMhill_WGS84)
                 ) +
     geom_raster(data = DSM_SJER_df, 
             aes(x = x, y = y, 
                  fill = SJER_dsmCrop,
                  alpha=0.8)
             ) + 
     scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
     coord_quickmap()
```

<img src="fig/03-raster-reproject-in-r-rendered-challenge-code-reprojection-1.png" style="display: block; margin: auto;" />

:::::::::::::::::::::::::

If you completed the San Joaquin plotting challenge in the
[Plot Raster Data in R](02-raster-plot/)
episode, how does the map you just created compare to that map?

:::::::::::::::  solution

## Answers

The maps look identical. Which is what they should be as the only difference
is this one was reprojected from WGS84 to UTM prior to plotting.



:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::



:::::::::::::::::::::::::::::::::::::::: keypoints

- In order to plot two raster data sets together, they must be in the same CRS.
- Use the `projectRaster()` function to convert between CRSs.

::::::::::::::::::::::::::::::::::::::::::::::::::


