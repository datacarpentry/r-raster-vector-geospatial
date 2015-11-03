---
layout: post
title:  "Spatio-Temporal / NEON Data Workshop "
date:   2015-10-15 10:00:00
output: html_document
permalink: /R/spatio-temporal/
---



#M4. Working with Tabular Time Series Data

**Goal:** Participants will know how to open, clean, explore, and  plot time series data

##Learning Objectives:

Participants will know how to open a csv file in R
*Open a csv file in R and why we are using that format in this training
*Examine data structures and types
*Prepare data for analysis
  *Clean
  *Convert/Transform
  *Summarize (looking at basic descriptives)
*Create a basic plot
*Exploring trends in data


#LESSON 1: Load and Understand your Data
When you initiate a workflow you always want to load a package prior to starting (if you later need another package add it here)


    # Load packages
    #load ggplot for plotting 
    library(ggplot2)
    #the scales library supports breaks and formatting in ggplot
    library(scales)
    
    # Load file and make it work
    #don't load strings as factors
    #read in 15 min average data 
    harMet <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv", stringsAsFactors = FALSE)

Look at Metadata & Data Structure

Metadata in text file.  Look for temp, precip, and daylength in the file.  One is missing.  



















