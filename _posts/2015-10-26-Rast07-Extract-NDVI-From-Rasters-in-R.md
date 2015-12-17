---
layout: post
title: "Lesson 07: Extract NDVI Summary Values from a Raster Time Series"
date:   2015-10-22
authors: [Leah Wasser, Kristina Riemer, Zack Bryn, Jason Williams, Jeff
Hollister,  Mike Smorul]
contributors: [Megan A. Jones]
packagesLibraries: [raster, rgdal]
dateCreated:  2014-11-26
lastModified: 2015-12-17
category: time-series-workshop
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson will explore a way to extract NDVI values from a
raster time series in `R` and plot them using `ggplot`. Methods learned in this 
lesson could be applied to any raster time series data."
code1: SR07-Extract-NDVI-From-Rasters-in-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Extract-NDVI-From-Rasters-In-R/
comments: false
---

{% include _toc.html %}

##About
In this lesson, we will extract NDVI values from a
raster time series in `R` and plot them using `ggplot`. Methods learned in this 
lesson could be applied to any raster time series data. 

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will:

* Be able to extract summary pixel values from a raster.
* Know how to save summary values to a .csv file.
* Be able to plot summary pixel values using `ggplot()`.
* Have experience comparing NDVI values between to different sites. 

###Challenge Code
Throughout the lesson we have Challenges that reinforce learned skills. Possible
solutions to the challenges are not posted on this page, however, the code for 
each challenge is in the `R` code that can be downloaded for this lesson (see 
footer on this page).

###Things You'll Need To Complete This Lesson

Please be sure you have the most current version of `R` and, preferably,
RStudio to write your code.

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

####Data to Download

<a href=" https://ndownloader.figshare.com/files/3579867" class="btn btn-success"> Download Landsat derived NDVI raster files</a> 

The imagery data used to create this raster teaching data subset were collected
over the National Ecological Observatory Network's
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard Forest</a>
and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin Experimental Range</a>
field sites.  
The imagery was created by the U.S. Geological Survey (USGS) using a 
<a href="http://eros.usgs.gov/#/Find_Data/Products_and_Data_Available/MSS" target="_blank" >  multispectral scanner</a>
on a <a href="http://landsat.usgs.gov" target="_blank" > Landsat Satellite </a>.
The data files are Geographic Tagged Image-File Format (GeoTIFF). 

####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a
refresher on setting the working directory, please view the [Setting A Working Directory In R]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") 
lesson prior to beginning this lesson.

####Raster Lesson Series 
This lesson is a part of a series of raster data in R lessons:

* [Lesson 00 - Intro to Raster Data in R]({{ site.baseurl}}/R/Introduction-to-Raster-Data-In-R/)
* [Lesson 01 - Plot Raster Data in R]({{ site.baseurl}}/R/Plot-Rasters-In-R/)
* [Lesson 02 - Reproject Raster Data in R]({{ site.baseurl}}/R/Reproject-Raster-In-R/)
* [Lesson 03 - Raster Calculations in R]({{ site.baseurl}}/R/Raster-Calculations-In-R/)
* [Lesson 04 - Work With Multi-Band Rasters - Images in R]({{ site.baseurl}}/R/Multi-Band-Rasters-In-R/)
* [Lesson 05 - Raster Time Series Data in R]({{ site.baseurl}}/R/Raster-Times-Series-Data-In-R/)
* [Lesson 06 - Plot Raster Time Series Data in R Using RasterVis and LevelPlot]({{ site.baseurl}}/R/Plot-Raster-Times-Series-Data-In-R/)
* [Lesson 07- Extract NDVI Summary Values from a Raster Time Series]({{ site.baseurl}}/R/Extract-NDVI-From-Rasters-In-R/)

###Additional Resources

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in `R`.</a>

</div>

#Extracting Summary Statistics From Raster Data
In science, we often want to extract summary values from raster data. For
example, we might want to understand overall greeness across a field site or at
each plot within a field site. These values can then be compared betweeen 
different field sites and combined with other
related metrics to support modeling and other types of analysis.

##Getting Started 
In this lesson, we are working with the same set of rasters used in the
[Raster Time Series Data in R ]({{ site.baseurl}} /R/Raster-Times-Series-Data-In-R/) and [Plot Raster Time Series Data in R Using RasterVis and Levelplot ]({{ site.baseurl}}/R/Plot-Raster-Times-Series-Data-In-R/)
lessons. If you do not yet have this RasterStack, please create it now. 


    library(raster)
    library(rgdal)
    library(ggplot2)
    
    # Create list of NDVI file paths
    all_HARV_NDVI <- list.files("Landsat_NDVI/HARV/2011/ndvi",
                                full.names = TRUE,
                                pattern = ".tif$")
    
    # Create a time series raster stack
    NDVI_HARV_stack <- stack(all_HARV_NDVI)

#Calculate Average NDVI
Our output goal is a data frame that contains a single, mean NDVI value for
each raster in our time series. This represents the mean or average NDVI value
for the area on a given day.  

We can calculate the mean for each raster using the `cellStats` function. This
produces a numeric array of values. However, we want a `data.frame` so we can 
convert from the array to a data frame with `as.data.frame()`.


    #calculate mean NDVI for each raster
    avg_NDVI_HARV <- cellStats(NDVI_HARV_stack,mean)
    
    #convert output array to data.frame
    avg_NDVI_HARV <- as.data.frame(avg_NDVI_HARV)
    
    #To be more efficient we could do the above two steps with one line of code
    #avg_NDVI_HARV <- as.data.frame(cellStats(NDVI_stack_HARV,mean))
    
    #view data
    avg_NDVI_HARV

    ##                     avg_NDVI_HARV
    ## X005_HARV_ndvi_crop       3651.50
    ## X037_HARV_ndvi_crop       2426.45
    ## X085_HARV_ndvi_crop       2513.90
    ## X133_HARV_ndvi_crop       5993.00
    ## X181_HARV_ndvi_crop       8787.25
    ## X197_HARV_ndvi_crop       8932.50
    ## X213_HARV_ndvi_crop       8783.95
    ## X229_HARV_ndvi_crop       8815.05
    ## X245_HARV_ndvi_crop       8501.20
    ## X261_HARV_ndvi_crop       7963.60
    ## X277_HARV_ndvi_crop        330.50
    ## X293_HARV_ndvi_crop        568.95
    ## X309_HARV_ndvi_crop       5411.30

    #view only the value in row 1, column 1 of the data frame
    avg_NDVI_HARV[1,1]

    ## [1] 3651.5

We now have a `data.frame` with `row.names` based on the original
file name and a mean NDVI value for one. We can also select values by their
location in the `data.frame`.

It is a bit confusing to have duplicate object & column names (e.g.
`avg_NDVI_HARV`), additionally the "avg" does not expressely denote how the
value is calculated. MeanNDVI is better. We can change the column name. 


    #view column name slot
    names(avg_NDVI_HARV)

    ## [1] "avg_NDVI_HARV"

    #rename the NDVI column
    names(avg_NDVI_HARV) <- "meanNDVI"
    
    #view cleaned column names
    names(avg_NDVI_HARV)

    ## [1] "meanNDVI"

However, by renaming we loose the information that this is at the Harvard
Forest.  While, we are only working with one site now, we
might want to compare several sites worth of data in the future. To allow us to
do this, let's add a column to our data frame called "site". We can populate this
with the site name.


    #add a site column to our data
    avg_NDVI_HARV$site <- "HARV"
    
    #add a "year" column to our data
    avg_NDVI_HARV$year <- "2011"
    
    #view data
    head(avg_NDVI_HARV)

    ##                     meanNDVI site year
    ## X005_HARV_ndvi_crop  3651.50 HARV 2011
    ## X037_HARV_ndvi_crop  2426.45 HARV 2011
    ## X085_HARV_ndvi_crop  2513.90 HARV 2011
    ## X133_HARV_ndvi_crop  5993.00 HARV 2011
    ## X181_HARV_ndvi_crop  8787.25 HARV 2011
    ## X197_HARV_ndvi_crop  8932.50 HARV 2011

We now have data frame with each file and two values for each one `meanNDVI` and 
`site`.  

#Extract Julian Day from row.names
We'd like to produce a plot where Julian days (the numeric day of the year,
0 - 365/366) is on the x-axis and NDVI is on
the y-axis. To do this, we'll need a column that is populated with only the
Julian day value for each NDVI value. We can do this using one of several
approaches. 

For this lesson, we will use `gsub` to replace the `X` and the `_HARV_ndvi_crop`.


    #note the use of the vertical bar character ( | ) is equivalent to "or". This
    # allows us to search for more than one pattern in our text strings.
    julianDays <- gsub(pattern = "X|_HARV_ndvi_crop", #the pattern to find 
                x = row.names(avg_NDVI_HARV), #the object containing the strings
                replacement = "") #what to replace each instance of the pattern with
    
    #alternate format
    #julianDays <- gsub("X|_HARV_ndvi_crop", "", row.names(avg_NDVI_HARV))
    
    #make sure output looks ok
    head(julianDays)

    ## [1] "005" "037" "085" "133" "181" "197"

    #add julianDay values as a column in the data frame
    avg_NDVI_HARV$julianDay <- julianDays
    
    #what class is the new column
    class(avg_NDVI_HARV$julianDay)

    ## [1] "character"


##Create Date Column from Julian Day
Currently the Julian day is recognized as a character class value.  We'd prefer
if it was recognized by `R` as one of the data-time classes so that `R` can
interpret and format it as a date when plotting and in other functions. 

For more information on date-time classes, see the NEON Data Skills lesson 
[Convert Date & Time Data from Character Class to Date-Time Class (POSIX) in R ]({{ site.baseurl}} /R/Time-Series-Convert-Date-Time-Class-POSIX/).  

We know our data is from 2011, therefore the first day or origin for our Julian
day count is 01 January 2011.  After setting this as the origin we just need to 
add the Julian day (as an integer) to the origin date.  Since the origin data
was originally set as a Date class object, the new `Date` column is also Date 
class. 

    #set the origin for the julian date (1 Jan 2011)
    origin<-as.Date ("2011-01-01")
    
    #convert "julianDay" from class character to integer
    avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)
    
    #create a date column; -1 added because origin is the 1st. 
    # If not -1, 01/01/2011 + 5 = 01/06/2011 which is Julian day 6, not 5.
    avg_NDVI_HARV$Date<- origin + (avg_NDVI_HARV$julianDay-1)
    
    #did it work? 
    head(avg_NDVI_HARV$Date)

    ## [1] "2011-01-05" "2011-02-06" "2011-03-26" "2011-05-13" "2011-06-30"
    ## [6] "2011-07-16"

    #What are the classes of the two columns now? 
    class(avg_NDVI_HARV$Date)

    ## [1] "Date"

    class(avg_NDVI_HARV$julianDay)

    ## [1] "integer"

#Deal with Scale Factors
Next, we need to scale our data. Valid NDVI values range from 0-1. However, the
range of our data is 277 to 9140. Why? 

The metadata for this NDVI data states that it has a scale factor of 10,000. 
This eliminates needing to store decimal values in the data which keeps file 
sizes smaller.

As we have a small data set of only 13 values we do not need to have the values
scaled.  


    #apply the scale factor of 10,000 to the data
    avg_NDVI_HARV$meanNDVI <- avg_NDVI_HARV$meanNDVI / 10000
    
    #view output
    head(avg_NDVI_HARV)

    ##                     meanNDVI site year julianDay       Date
    ## X005_HARV_ndvi_crop 0.365150 HARV 2011         5 2011-01-05
    ## X037_HARV_ndvi_crop 0.242645 HARV 2011        37 2011-02-06
    ## X085_HARV_ndvi_crop 0.251390 HARV 2011        85 2011-03-26
    ## X133_HARV_ndvi_crop 0.599300 HARV 2011       133 2011-05-13
    ## X181_HARV_ndvi_crop 0.878725 HARV 2011       181 2011-06-30
    ## X197_HARV_ndvi_crop 0.893250 HARV 2011       197 2011-07-16

#Challenge: NDVI for the San Joaquin Experimental Range
We often want to compare two different sites in ecological studies.  Up to this
point,
we've only worked with data from the Harvard Forest.  The National
Ecological Obseravatory Network (NEON) and Landsat also collect data and remote 
sensing imagery for the 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin Experimental Range (SJER) </a> 
located in California.  

In order to faciliate comparison between the Harvard Forests and SJER, create a
complementary NDVI data set for SJER based on NDVI GeoTIFF files in the
Landsat_NDVI/SJER/2011/ndvi directory. 



#Plot NDVI Using ggplot
We now have a clean data frame with properly scaled NDVI and Julian days.  Let's
plot our data.  

We will use the `ggplot()` function within the `ggplot2` package for this plot. 
If you are unfamiliar with `ggplot()` or would like to learn more about plotting
in `ggplot()` see the lesson on
[Plotting Time Series with ggplot in R ]({{ site.baseurl}}/R/Time-Series-Plot-ggplot/).


    #plot NDVI
    ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI)) +
      geom_point(size=4,colour = "blue") + 
      ggtitle("NDVI for HARV 2011\nLandsat Derived") +
      xlab("Julian Days") + ylab("Mean NDVI") +
      theme(text = element_text(size=20))

![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/ggplot-data-1.png) 


#Challenge: ggplot for San Joaquin Experimental Range Data
Create a plot for the SJER data. Plot the data points in a different color. 


    #plot NDVI
    ggplot(avg_NDVI_SJER, aes(julianDay, meanNDVI)) +
      geom_point(size=4,colour = "darkgreen") + 
      ggtitle("NDVI for SJER 2011\nLandsat Derived") +
      xlab("Julian Day") + ylab("Mean NDVI") +
      theme(text = element_text(size=20))

![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/challenge-code-ggplot-data-1.png) 

#Compare NDVI from Two Different Sites in One Plot
Comparison of plots is often easiest when both plots are side by side. Or, even 
better, if both sets of data are plotted in the same plot. We can do this by 
binding the two data sets together.  The date frames must have the same number
of columns and exact same column names to be bound.  


    #Merge Data Frames
    ndvi_HARV_SJER <- rbind(avg_NDVI_HARV,avg_NDVI_SJER)  
      
    #plot NDVI values for both sites
    ggplot(ndvi_HARV_SJER, aes(julianDay, meanNDVI, colour=site)) +
      geom_point(size=4,aes(group=site)) + 
      geom_line(aes(group=site)) +
      ggtitle("Landsat Derived NDVI - 2011\nNEON Harvard Forest vs San Joaquin") +
      xlab("Julian Day") + ylab("Mean NDVI") +
      scale_colour_manual(values=c("blue", "darkgreen")) +   #match previous plots
      theme(text = element_text(size=20))

![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/merge-df-single-plot-1.png) 

#Challenge: Plot NDVI with Date
Plot the SJER and HARV data in one plot but use date, not julian day, 
for the x-axis. 

![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/challenge-code-plot2-1.png) 

#Remove Questionable Data
As we look at these plots we see variation across the year.  However, th
pattern is interrupted by a few deep dips to an NDVI value near 0.  Is the
vegetation truely dead and gone or are these inapproriate values that should be
removed from the data.  

Let's look at the RGB images from Harvard Forest.
![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/view-all-rgb-1.png) 

Notice that on the same days that have very low NDVI values the images are
filled with clouds.  Therefore the low NDVI is due to no reflectance from
vegetation being recorded.  While we don't have RGBImagery for SJER, we can
guess that a similar data problem occured for the two days (in January &
September) that the NDVI values dip to near 0.  

As we don't want to create the impression that NDVI is acutally lower on those
days let's remove them and replot.  

First, we need to identify the rows that should be retained. We can do this by
identifying all values less than some threshold for the questionable data.  
Given the plots of this data a threshold of 0.1 would work. We can then use the
subset function to just keep the data that is not suspect.  


    #retain only rows with meanNDVI>0.1
    avg_NDVI_HARV_clean<-subset(avg_NDVI_HARV, meanNDVI>0.1)
    
    #work?
    avg_NDVI_HARV_clean$meanNDVI<0.1

    ##  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

Now we can create another plot without the suspect data. 


    #plot without questionable data
    ggplot(avg_NDVI_HARV_clean, aes(julianDay, meanNDVI)) +
      geom_point(size=4,colour = "blue") + 
      ggtitle("NDVI for HARV 2011\nLandsat Derived") +
      xlab("Julian Days") + ylab("Mean NDVI") +
      theme(text = element_text(size=20))

![ ]({{ site.baseurl }}/images/rfigs/07-Extract-NDVI-From-Rasters-in-R/plot-clean-HARV-1.png) 
  
Now we can see a much cleaner annual pattern.  Notice that the scale bar has now
changed. 

#Write NDVI data to a .csv File
This summarized NDVI data is in a tabular, not raster, format. We could now
compare it to other times of time-series data to compare vegetative,
meteorological, or other types of data to the the NDVI.  However, to do this we
need to export the data into a file format that can easily be used in other
programs, used in `R` at a later time, or shared with colleagues.  A Comma
Seperated Value (.csv) file format is an excellent choice for this as it is a
common plain-text format used by many programs and unlikely to become outdated.

We can use `write.csv()` to write a specified data frame to a .csv file that is 
saved in the current working directory (can specify otherwise). 


    #confirm data frame is the way we want it
    head(avg_NDVI_HARV_clean)

    ##                     meanNDVI site year julianDay       Date
    ## X005_HARV_ndvi_crop 0.365150 HARV 2011         5 2011-01-05
    ## X037_HARV_ndvi_crop 0.242645 HARV 2011        37 2011-02-06
    ## X085_HARV_ndvi_crop 0.251390 HARV 2011        85 2011-03-26
    ## X133_HARV_ndvi_crop 0.599300 HARV 2011       133 2011-05-13
    ## X181_HARV_ndvi_crop 0.878725 HARV 2011       181 2011-06-30
    ## X197_HARV_ndvi_crop 0.893250 HARV 2011       197 2011-07-16

We have all the data we want in our data frame, however, we still have row names
based on the individual raster files that the NDVI mean came from.  All the data
in the names is repeated in other columns. If we wrote to a .csv currently this
the first column would be an unnamed column.  Instead we can prevent any future
problems by removing this column prior to writing to .csv.  


    #create new df to prevent changes to avg_NDVI_HARV
    NDVI_HARV_toWrite<-avg_NDVI_HARV_clean
    
    #drop the row.names column 
    row.names(NDVI_HARV_toWrite)<-NULL
    
    #check data frame
    head(NDVI_HARV_toWrite)

    ##   meanNDVI site year julianDay       Date
    ## 1 0.365150 HARV 2011         5 2011-01-05
    ## 2 0.242645 HARV 2011        37 2011-02-06
    ## 3 0.251390 HARV 2011        85 2011-03-26
    ## 4 0.599300 HARV 2011       133 2011-05-13
    ## 5 0.878725 HARV 2011       181 2011-06-30
    ## 6 0.893250 HARV 2011       197 2011-07-16

    #create a .csv of mean NDVI values being sure to give descriptive name
    #write.csv(DateFrameName, file="NewFileName")
    write.csv(NDVI_HARV_toWrite, file="meanNDVI_HARV_2011.csv")

#Challenge: Write to .csv
Create a NDVI .csv file for the SJER that is compatable with the one we just
created for the Harvard Forest.  Be sure to inspect for questionable values 
before writing any data to a .csv file. 


