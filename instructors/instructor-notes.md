---
title: Instructor Notes
---


## Instructor notes

## Lesson motivation and learning objectives

This lesson is designed to introduce learners to the fundamental principles and skills for working with
raster and vector geospatial data in R. It begins by introducing the structure of and simple plotting of
raster data. It then covers re-projection of raster data, performing raster math, and working with multi-band
raster data. After introducing raster data, the lesson moves into working with vector data. Line, point, and
polygon shapefiles are included in the data. Learners will plot multiple raster and/or vector layers
in a single plot, and learn how to customize plot elements such as legends and titles. They will
also learn how to read data in from a csv formatted file and re-format it to a shapefile. Lastly, learners
will work with multi-layered raster data set representing time series data and extract summary statistics
from this data.

## Lesson design

#### Overall comments

- As of initial release of this lesson (August 2018), the timing is set to be the same for each episode. This
  is very likely incorrect and will need to be updated as these lessons are taught. If you teach this lesson,
  please put in an issue or PR to suggest an updating timing scheme!!

- The code examples presented in each episode assume that the learners still have all of the data and packages
  loaded from all previous episodes in this lesson. If learners close out of their R session during the breaks or
  at the end of the first day, they will need to either save the workspace or reload the data and packages.
  Because of this, it is essential that learners save their code to a script throughout the lesson.

#### [Intro to Raster Data in R](01-raster-structure.md)

- Be sure to introduce the datasets that will be used in this lesson. There are many data files. It may
  be helpful to draw a diagram on the board showing the types of data that will be plotted and analyzed
  throughout the lesson.
- If the [Introduction to Geospatial Concepts](https://datacarpentry.org/organization-geospatial/) lesson was
  included in your workshop, learners will have been introduced to the GDAL library. It will be useful to make
  the connection back to that lesson explicitly.
- If the [Introduction to R for Geospatial Data](https://datacarpentry.org/r-intro-geospatial/) lesson was included
  in your workshop, learners will be familiar with the idea of packages and with most of the functions used
  in this lesson.
- The Dealing with Missing Data and Bad Data Values in Rasters sections have several plots showing alternative ways of displaying missing
  data. The code for generating these plots is **not** shared with the learners, as it relies on many functions
  they have not yet learned. For these and other plots with hidden demonstration code, show the images in the
  lesson page while discussing those examples.
- Be sure to draw a distinction between the DTM and the DSM files, as these two datasets will be used
  throughout the lesson.

#### [Plot Raster Data in R](02-raster-plot.md)

- `geom_bar()` is a new geom for the learners. They were introduced to `geom_col()` in the [Introduction to R for Geospatial Data](https://datacarpentry.org/r-intro-geospatial/) lesson.
- `dplyr` syntax should be familiar to your learners from the [Introduction to R for Geospatial Data](https://datacarpentry.org/r-intro-geospatial/) lesson.
- This may be the first time learners are exposed to hex colors, so be sure to explain that concept.
- Starting in this episode and continuing throughout the lesson, the `ggplot` calls can be very long. Be sure
  to explicitly describe each step of the function call and what it is doing for the overall plot.

#### [Reproject Raster Data in R](03-raster-reproject-in-r.md)

- No notes yet. Please add your tips and comments!

#### [Raster Calculations in R](04-raster-calculations-in-r.md)

- The `overlay()` function syntax is fairly complex compared to other function calls the learners have seen.
  Be sure to explain it in detail.

#### [Work With Multi-Band Rasters in R](05-raster-multi-band-in-r.md)

- No notes yet. Please add your tips and comments!

#### [Open and Plot Shapefiles in R](06-vector-open-shapefile-in-r.md)

- Learners may have heard of the `sp` package. If it comes up, explain that `sf` is a
  more modern update of `sp`.
- There is a known bug in the `geom_sf()` function that leads to an intermittent error on some platforms.
  If you see the following error message, try to re-run your plotting command and it should work.
  The `ggplot` development team is working on fixing this bug.

## Error message

> ```
> Error in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y,  : 
> ```

polygon edge not found

> ```
> {: .error}
> ```

#### [Explore and Plot by Shapefile Attributes](07-vector-shapefile-attributes-in-r.md)

- No notes yet. Please add your tips and comments!

#### [Plot Multiple Shapefiles in R](08-vector-plot-shapefiles-custom-legend.md)

- No notes yet. Please add your tips and comments!

#### [Handling Spatial Projection \& CRS in R](09-vector-when-data-dont-line-up-crs.md)

- Note that, although `ggplot` automatically reprojects vector data when plotting multiple shapefiles with
  different projections together, it is still important to be aware of the CRSs of your data and to keep track
  of how they are being transformed.

#### [Convert from .csv to a Shapefile in R](10-vector-csv-to-shapefile-in-r.md)

- No notes yet. Please add your tips and comments!

#### [Manipulate Raster Data in R](11-vector-raster-integration.md)

- Learners have not yet been exposed to the `melt()` function in this workshop. They will need to have
  the syntax explained.
- This is the first instance of a faceted plot in this workshop.

#### [Raster Time Series Data in R](12-time-series-raster.md)

- No notes yet. Please add your tips and comments!

#### [Create Publication-quality Graphics](13-plot-time-series-rasters-in-r.md)

- Be sure to show learners the before and after plots to motivate the complexity of the
  `ggplot` calls that will be used in this episode.

#### [Derive Values from Raster Time Series](14-extract-ndvi-from-rasters-in-r.md)

- This is the first time in the workshop that learners will have worked with date data.

#### Concluding remarks

- No notes yet. Please add your tips and comments!

## Technical tips and tricks

- Leave about 30 minutes at the start of each workshop and another 15 mins
  at the start of each session for technical difficulties like WiFi and
  installing things (even if you asked students to install in advance, longer if
  not).

- Don't worry about being correct or knowing the material back-to-front. Use
  mistakes as teaching moments: the most vital skill you can impart is how to
  debug and recover from unexpected errors.

## Scheduling tips

- You will almost certainly not have enough time to teach this entire curriculum. If pressed for time,
  here is one possible shortened schedule you can use (used in a 4 half-day curriculum in May 2022):
  - Day 1: Workshop intro, installation, troubleshooting. Episodes 1-5 of Introduction to R for Geospatial Data.
    Skip everything in Episode 3 after "Vectors and Type Coercion, but keep Challenge 4. Skip everything in
    Episode 4 starting at "Adding columns and rows in data frames". Only include the "Data frames" section of Episode 5.
    You can introduce factors on-the-fly in the rest of the curriculum.
  - Day 2: Episodes 6-8 of Introduction to R for Geospatial Data, Episodes 6-8 of R for Raster and Vector Data (as far
    as you get in Episode 8).
  - Day 3: Episodes 8-10 of R for Raster and Vector Data, Episodes 1-2 of R for Raster and Vector Data.
  - Day 4: Episodes 3, 11 of Raster and Vector Data (and whatever else you'd like to cover), workshop conclusion.
- It is a good idea to start your teaching with **vector data** (which is more immediately relevant to a greater number of
  researchers, particularly those outside of environmental sciences), then move to raster data if there is extra time.
- Skip Introduction to Geospatial Concepts. Spend at most 30 minutes reviewing things as this is currently not
  an interactive curriculum. Most of the concepts you can cover within the R for Raster and Vector Data curriculum.

## Common problems

- Pre-installation for this curriculum is particularly important because geospatial data and software is large and can take
  a very long time to load during a workshop. Make sure everything is installed and downloaded ahead of time.
- TBA - Instructors please add other situations you encounter here.




