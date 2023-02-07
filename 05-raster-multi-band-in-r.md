---
title: Work With Multi-Band Rasters
teaching: 40
exercises: 20
source: Rmd
---



::::::::::::::::::::::::::::::::::::::: objectives

- Identify a single vs. a multi-band raster file.
- Import multi-band rasters into R using the `raster` package.
- Plot multi-band color image rasters in R using the `ggplot` package.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I visualize individual and multiple bands in a raster object?

::::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::::::::  prereq

## Things You'll Need To Complete This Episode

See the [lesson homepage](.) for detailed information about the software,
data, and other prerequisites you will need to work through the examples in this episode.


::::::::::::::::::::::::::::::::::::::::::::::::::

We introduced multi-band raster data in
[an earlier lesson](https://datacarpentry.org/organization-geospatial/01-intro-raster-data). This episode explores how to import and plot
a multi-band raster in
R.

## Getting Started with Multi-Band Data in R

In this episode, the multi-band data that we are working with is imagery
collected using the
[NEON Airborne Observation Platform](https://www.neonscience.org/data-collection/airborne-remote-sensing)
high resolution camera over the
[NEON Harvard Forest field site](https://www.neonscience.org/field-sites/field-sites-map/HARV).
Each RGB image is a 3-band raster. The same steps would apply to
working with a multi-spectral image with 4 or more bands - like Landsat imagery.

If we read a RasterStack object into R using the `raster()` function, it only reads
in the first band.


```r
RGB_band1_HARV <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")
```

We need to convert this data to a data frame in order to plot it with `ggplot`.


```r
RGB_band1_HARV_df  <- as.data.frame(RGB_band1_HARV, xy = TRUE)
```


```r
ggplot() +
  geom_raster(data = RGB_band1_HARV_df,
              aes(x = x, y = y, alpha = layer)) + 
  coord_quickmap()
```

<img src="fig/05-raster-multi-band-in-r-rendered-harv-rgb-band1-1.png" style="display: block; margin: auto;" />

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

View the attributes of this band. What are its dimensions, CRS, resolution, min and max values,
and band number?

:::::::::::::::  solution

## Solution


```r
RGB_band1_HARV
```

```{.output}
class      : RasterLayer 
band       : 1  (of  3  bands)
dimensions : 2317, 3073, 7120141  (nrow, ncol, ncell)
resolution : 0.25, 0.25  (x, y)
extent     : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
source     : HARV_RGB_Ortho.tif 
names      : layer 
values     : 0, 255  (min, max)
```

Notice that when we look at the attributes of this band, we see:
`band: 1  (of  3  bands)`

This is R telling us that this particular raster object has more bands (3)
associated with it.



:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Data Tip

The number of bands associated with a
raster object can also be determined using the `nbands()` function: syntax is
`nbands(RGB_band1_HARV)`.


::::::::::::::::::::::::::::::::::::::::::::::::::

### Image Raster Data Values

As we saw in the previous exercise, this raster contains values between 0 and 255. These values
represent degrees of brightness associated with the image band. In
the case of a RGB image (red, green and blue), band 1 is the red band. When
we plot the red band, larger numbers (towards 255) represent pixels with more
red in them (a strong red reflection). Smaller numbers (towards 0) represent
pixels with less red in them (less red was reflected). To
plot an RGB image, we mix red + green + blue values into one single color to
create a full color image - similar to the color image a digital camera creates.

### Import A Specific Band

We can use the `raster()` function to import specific bands in our raster object
by specifying which band we want with `band = N` (N represents the band number we
want to work with). To import the green band, we would use `band = 2`.


```r
RGB_band2_HARV <-  raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", band = 2)
```

We can convert this data to a data frame and plot the same way we plotted the red band:


```r
RGB_band2_HARV_df <- as.data.frame(RGB_band2_HARV, xy = TRUE)
```


```r
ggplot() +
  geom_raster(data = RGB_band2_HARV_df,
              aes(x = x, y = y, alpha = layer)) + 
  coord_equal()
```

<img src="fig/05-raster-multi-band-in-r-rendered-rgb-harv-band2-1.png" style="display: block; margin: auto;" />

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge: Making Sense of Single Band Images

Compare the plots of band 1 (red) and band 2 (green). Is the forested area darker or lighter in band 2 (the green band) compared to band 1 (the red band)?

:::::::::::::::  solution

## Solution

We'd expect a *brighter* value for the forest in band 2 (green) than in
band 1 (red) because the leaves on trees of most often appear "green" -
healthy leaves reflect MORE green light than red light.



:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Raster Stacks in R

Next, we will work with all three image bands (red, green and blue) as an R
RasterStack object. We will then plot a 3-band composite, or full color,
image.

To bring in all bands of a multi-band raster, we use the`stack()` function.


```r
RGB_stack_HARV <- stack("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")
```

Let's preview the attributes of our stack object:


```r
RGB_stack_HARV
```

```{.output}
class      : RasterStack 
dimensions : 2317, 3073, 7120141, 3  (nrow, ncol, ncell, nlayers)
resolution : 0.25, 0.25  (x, y)
extent     : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
names      : HARV_RGB_Ortho_1, HARV_RGB_Ortho_2, HARV_RGB_Ortho_3 
min values :                0,                0,                0 
max values :              255,              255,              255 
```

We can view the attributes of each band in the stack in a single output:


```r
RGB_stack_HARV@layers
```

```{.output}
[[1]]
class      : RasterLayer 
band       : 1  (of  3  bands)
dimensions : 2317, 3073, 7120141  (nrow, ncol, ncell)
resolution : 0.25, 0.25  (x, y)
extent     : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
source     : HARV_RGB_Ortho.tif 
names      : HARV_RGB_Ortho_1 
values     : 0, 255  (min, max)


[[2]]
class      : RasterLayer 
band       : 2  (of  3  bands)
dimensions : 2317, 3073, 7120141  (nrow, ncol, ncell)
resolution : 0.25, 0.25  (x, y)
extent     : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
source     : HARV_RGB_Ortho.tif 
names      : HARV_RGB_Ortho_2 
values     : 0, 255  (min, max)


[[3]]
class      : RasterLayer 
band       : 3  (of  3  bands)
dimensions : 2317, 3073, 7120141  (nrow, ncol, ncell)
resolution : 0.25, 0.25  (x, y)
extent     : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
source     : HARV_RGB_Ortho.tif 
names      : HARV_RGB_Ortho_3 
values     : 0, 255  (min, max)
```

If we have hundreds of bands, we can specify which band we'd like to view
attributes for using an index value:


```r
RGB_stack_HARV[[2]]
```

```{.output}
class      : RasterLayer 
band       : 2  (of  3  bands)
dimensions : 2317, 3073, 7120141  (nrow, ncol, ncell)
resolution : 0.25, 0.25  (x, y)
extent     : 731998.5, 732766.8, 4712956, 4713536  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
source     : HARV_RGB_Ortho.tif 
names      : HARV_RGB_Ortho_2 
values     : 0, 255  (min, max)
```

We can also use the `ggplot` functions to plot the data in any layer
of our RasterStack object. Remember, we need to convert to a data
frame first.


```r
RGB_stack_HARV_df  <- as.data.frame(RGB_stack_HARV, xy = TRUE)
```

Each band in our RasterStack gets its own column in the data frame. Thus we have:


```r
str(RGB_stack_HARV_df)
```

```{.output}
'data.frame':	7120141 obs. of  5 variables:
 $ x               : num  731999 731999 731999 731999 732000 ...
 $ y               : num  4713535 4713535 4713535 4713535 4713535 ...
 $ HARV_RGB_Ortho_1: num  0 2 6 0 16 0 0 6 1 5 ...
 $ HARV_RGB_Ortho_2: num  1 0 9 0 5 0 4 2 1 0 ...
 $ HARV_RGB_Ortho_3: num  0 10 1 0 17 0 4 0 0 7 ...
```

Let's create a histogram of the first band:


```r
ggplot() +
  geom_histogram(data = RGB_stack_HARV_df, aes(HARV_RGB_Ortho_1))
```

```{.output}
`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="fig/05-raster-multi-band-in-r-rendered-rgb-harv-hist-band1-1.png" style="display: block; margin: auto;" />

And a raster plot of the second band:


```r
ggplot() +
  geom_raster(data = RGB_stack_HARV_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho_2)) + 
  coord_quickmap()
```

<img src="fig/05-raster-multi-band-in-r-rendered-rgb-harv-plot-band2-1.png" style="display: block; margin: auto;" />

We can access any individual band in the same way.

### Create A Three Band Image

To render a final three band, colored image in R, we use the `plotRGB()` function.

This function allows us to:

1. Identify what bands we want to render in the red, green and blue regions. The
  `plotRGB()` function defaults to a 1=red, 2=green, and 3=blue band order. However,
  you can define what bands you'd like to plot manually. Manual definition of
  bands is useful if you have, for example a near-infrared band and want to create
  a color infrared image.
2. Adjust the `stretch` of the image to increase or decrease contrast.

Let's plot our 3-band image. Note that we can use the `plotRGB()`
function directly with our RasterStack object (we don't need a
dataframe as this function isn't part of the `ggplot2` package).


```r
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3)
```

<img src="fig/05-raster-multi-band-in-r-rendered-plot-rgb-image-1.png" style="display: block; margin: auto;" />

The image above looks pretty good. We can explore whether applying a stretch to
the image might improve clarity and contrast using `stretch="lin"` or
`stretch="hist"`.

![](fig/dc-spatial-raster/imageStretch_dark.jpg){alt='Image Stretch'}

When the range of pixel brightness values is closer to 0, a darker image is rendered by default. We can stretch
the values to extend to the full 0-255 range of potential values to increase the visual contrast of the image.

![](fig/dc-spatial-raster/imageStretch_light.jpg){alt='Image Stretch light'}

When the range of pixel brightness values is closer to 255, a
lighter image is rendered by default. We can stretch the values to extend to
the full 0-255 range of potential values to increase the visual contrast of
the image.


```r
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "lin")
```

<img src="fig/05-raster-multi-band-in-r-rendered-plot-rbg-image-linear-1.png" style="display: block; margin: auto;" />


```r
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "hist")
```

<img src="fig/05-raster-multi-band-in-r-rendered-plot-rgb-image-hist-1.png" style="display: block; margin: auto;" />

In this case, the stretch doesn't enhance the contrast our image significantly
given the distribution of reflectance (or brightness) values is distributed well
between 0 and 255.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge - NoData Values

Let's explore what happens with NoData values when working with
RasterStack objects and using the
`plotRGB()` function. We will use the
`HARV_Ortho_wNA.tif` GeoTIFF file in the
`NEON-DS-Airborne-Remote-Sensing/HARVRGB_Imagery/` directory.

1. View the files attributes. Are there `NoData` values assigned for this file?
2. If so, what is the `NoData` Value?
3. How many bands does it have?
4. Load the multi-band raster file into R.
5. Plot the object as a true color image.
6. What happened to the black edges in the data?
7. What does this tell us about the difference in the data structure between
  `HARV_Ortho_wNA.tif` and `HARV_RGB_Ortho.tif` (R object `RGB_stack`). How can
  you check?

:::::::::::::::  solution

## Answers

1) First we use the `GDALinfo()` function to view the
  data attributes.


```r
GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")
```

```{.warning}
Warning: GDAL support is provided by the sf and terra packages among others
```

```{.warning}
Warning: GDAL support is provided by the sf and terra packages among others
```

```{.warning}
Warning: GDAL support is provided by the sf and terra packages among others
```

```{.output}
rows        2317 
columns     3073 
bands       3 
lower left origin.x        731998.5 
lower left origin.y        4712956 
res.x       0.25 
res.y       0.25 
ysign       -1 
oblique.x   0 
oblique.y   0 
driver      GTiff 
projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
file        data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif 
apparent band summary:
   GDType hasNoDataValue NoDataValue blockSize1 blockSize2
1 Float64           TRUE       -9999          1       3073
2 Float64           TRUE       -9999          1       3073
3 Float64           TRUE       -9999          1       3073
apparent band statistics:
  Bmin Bmax     Bmean      Bsd
1    0  255 107.83651 30.01918
2    0  255 130.09595 32.00168
3    0  255  95.75979 16.57704
Metadata:
AREA_OR_POINT=Area 
```

2) From the output above, we see that there are `NoData` values
  and they are assigned the value of -9999.

3) The data has three bands.

4) To read in the file, we will use the `stack()` function:


```r
HARV_NA <- stack("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")
```

5) We can plot the data with the `plotRGB()` function:


```r
plotRGB(HARV_NA,
        r = 1, g = 2, b = 3)
```

<img src="fig/05-raster-multi-band-in-r-rendered-harv-na-rgb-1.png" style="display: block; margin: auto;" />

6) The black edges are not plotted.
7) Both data sets have `NoData` values, however, in the RGB\_stack the NoData value is not
  defined in the tiff tags, thus R renders them as black as the reflectance
  values are 0. The black edges in the other file are defined as -9999 and R renders them as NA.


```r
GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")
```

```{.warning}
Warning: GDAL support is provided by the sf and terra packages among others
```

```{.warning}
Warning: GDAL support is provided by the sf and terra packages among others
```

```{.warning}
Warning: GDAL support is provided by the sf and terra packages among others
```

```{.output}
rows        2317 
columns     3073 
bands       3 
lower left origin.x        731998.5 
lower left origin.y        4712956 
res.x       0.25 
res.y       0.25 
ysign       -1 
oblique.x   0 
oblique.y   0 
driver      GTiff 
projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
file        data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif 
apparent band summary:
   GDType hasNoDataValue NoDataValue blockSize1 blockSize2
1 Float64           TRUE   -1.7e+308          1       3073
2 Float64           TRUE   -1.7e+308          1       3073
3 Float64           TRUE   -1.7e+308          1       3073
apparent band statistics:
  Bmin Bmax Bmean Bsd
1    0  255   NaN NaN
2    0  255   NaN NaN
3    0  255   NaN NaN
Metadata:
AREA_OR_POINT=Area 
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Data Tip

We can create a RasterStack from
several, individual single-band GeoTIFFs too. We will do this in
a later episode,
[Raster Time Series Data in R](12-time-series-raster/).


::::::::::::::::::::::::::::::::::::::::::::::::::

## RasterStack vs RasterBrick in R

The R RasterStack and RasterBrick object types can both store multiple bands.
However, how they store each band is different. The bands in a RasterStack are
stored as links to raster data that is located somewhere on our computer. A
RasterBrick contains all of the objects stored within the actual R object.
In most cases, we can work with a RasterBrick in the same way we might work
with a RasterStack. However a RasterBrick is often more efficient and faster
to process - which is important when working with larger files.

:::::::::::::::::::::::::::::::::::::::::  callout

## More Resources

You can read the help for the `brick()` function by typing `?brick`.


::::::::::::::::::::::::::::::::::::::::::::::::::

We can turn a RasterStack into a RasterBrick in R by using
`brick(StackName)`. Let's use the `object.size()` function to compare RasterStack and RasterBrick objects. First we will check
the size of our RasterStack object:


```r
object.size(RGB_stack_HARV)
```

```{.output}
56432 bytes
```

Now we will create a RasterBrick object from our RasterStack data and view its size:


```r
RGB_brick_HARV <- brick(RGB_stack_HARV)

object.size(RGB_brick_HARV)
```

```{.output}
170898792 bytes
```

Notice that in the RasterBrick, all of the bands are stored within the actual
object. Thus, the RasterBrick object size is much larger than the
RasterStack object.

You use the `plotRGB()` function to plot a RasterBrick too:


```r
plotRGB(RGB_brick_HARV)
```

<img src="fig/05-raster-multi-band-in-r-rendered-plot-brick-1.png" style="display: block; margin: auto;" />

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge: What Functions Can Be Used on an R Object of a particular class?

We can view various functions (or methods) available to use on an R object with
`methods(class=class(objectNameHere))`. Use this to figure out:

1. What methods can be used on the `RGB_stack_HARV` object?
2. What methods can be used on a single band within `RGB_stack_HARV`?
3. Why do you think there is a difference?

:::::::::::::::  solution

## Answers

1) We can see a list of all of the methods available for our
  RasterStack object:


```r
methods(class=class(RGB_stack_HARV))
```

```{.output}
  [1] !                     !=                    [                    
  [4] [[                    [[<-                  [<-                  
  [7] %in%                  ==                    $                    
 [10] $<-                   addLayer              adjacent             
 [13] aggregate             all.equal             animate              
 [16] approxNA              area                  Arith                
 [19] as.array              as.character          as.data.frame        
 [22] as.integer            as.list               as.logical           
 [25] as.matrix             as.vector             atan2                
 [28] bbox                  blockSize             boxplot              
 [31] brick                 calc                  cellFromRowCol       
 [34] cellFromRowColCombine cellFromXY            cellStats            
 [37] clamp                 click                 coerce               
 [40] colFromCell           colFromX              colSums              
 [43] Compare               coordinates           corLocal             
 [46] couldBeLonLat         cover                 crop                 
 [49] crosstab              crs<-                 cut                  
 [52] cv                    density               dim                  
 [55] dim<-                 disaggregate          dropLayer            
 [58] extend                extent                extract              
 [61] flip                  freq                  getValues            
 [64] getValuesBlock        getValuesFocal        hasValues            
 [67] head                  hist                  image                
 [70] init                  initialize            inMemory             
 [73] interpolate           intersect             is.factor            
 [76] is.finite             is.infinite           is.na                
 [79] is.nan                isLonLat              KML                  
 [82] labels                length                levels               
 [85] levels<-              log                   Logic                
 [88] mask                  match                 Math                 
 [91] Math2                 maxValue              mean                 
 [94] merge                 metadata              minValue             
 [97] modal                 mosaic                names                
[100] names<-               ncell                 ncol                 
[103] ncol<-                nlayers               nrow                 
[106] nrow<-                origin                origin<-             
[109] overlay               pairs                 persp                
[112] plot                  plotRGB               predict              
[115] print                 proj4string           proj4string<-        
[118] quantile              raster                rasterize            
[121] ratify                readAll               readStart            
[124] readStop              reclassify            rectify              
[127] res                   res<-                 resample             
[130] rotate                rowColFromCell        rowFromCell          
[133] rowFromY              rowSums               sampleRandom         
[136] sampleRegular         scale                 select               
[139] setMinMax             setValues             shift                
[142] show                  spplot                stack                
[145] stackSelect           stretch               subs                 
[148] subset                Summary               summary              
[151] t                     tail                  text                 
[154] trim                  unique                unstack              
[157] values                values<-              weighted.mean        
[160] which.max             which.min             whiches.max          
[163] whiches.min           wkt                   writeRaster          
[166] xFromCell             xFromCol              xmax                 
[169] xmax<-                xmin                  xmin<-               
[172] xres                  xyFromCell            yFromCell            
[175] yFromRow              ymax                  ymax<-               
[178] ymin                  ymin<-                yres                 
[181] zonal                 zoom                 
see '?methods' for accessing help and source code
```

2) And compare that with the methods available for a single band:


```r
methods(class=class(RGB_stack_HARV[1]))
```

```{.warning}
Warning in .S3methods(generic.function, class, envir): 'class' is of length >
1; only the first element will be used
```

```{.output}
 [1] [             [<-           anyDuplicated Arith         as_tibble    
 [6] as.data.frame as.raster     bind          boxplot       brick        
[11] cellFromXY    coerce        Compare       coordinates   determinant  
[16] distance      duplicated    edit          extent        extract      
[21] head          initialize    isSymmetric   Math          Math2        
[26] Ops           raster        rasterize     relist        subset       
[31] summary       surfaceArea   tail          trim          unique       
[36] values<-      weighted.mean writeValues  
see '?methods' for accessing help and source code
```

3) There are far more things one could or want to ask of a full stack than of
  a single band.
  
  

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::



:::::::::::::::::::::::::::::::::::::::: keypoints

- A single raster file can contain multiple bands or layers.
- Use the `stack()` function to load all bands in a multi-layer raster file into R.
- Individual bands within a stack can be accessed, analyzed, and visualized using the same functions as single bands.

::::::::::::::::::::::::::::::::::::::::::::::::::


