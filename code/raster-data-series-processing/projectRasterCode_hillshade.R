library(ggplot2)
library(rasterVis)

theme_set(theme_bw())
#use the raster vis gplot
gplot(DSM) + geom_tile(aes(fill = value)) +
  facet_wrap(~ variable) +
  scale_fill_gradient(low = 'white', high = 'blue') +
  coord_equal() +
  main="sdf"


#
#simplest approach
pr1 <- projectRaster(r, crs=newproj)


DTM <- raster("NEON_RemoteSensing/HARV/DTM/HARV_dtmCrop.tif")
#create hillshade
slope <- terrain(DTM, opt='slope')
aspect <- terrain(DTM, opt='aspect')
hill <- hillShade(slope, aspect, 40, 270)

#reproject to WGS84
pr1 <- projectRaster(hill, 
                     crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


#export CHM object to new geotiff
writeRaster(pr1,"HARV_DTMhill_WGS84.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

pr2 <- projectRaster(pr1, crs=crs(DTM),res=1)


#export CHM object to new geotiff
writeRaster(hill,"HARV_DTMhill.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

plot(hill, col=grey(0:100/100), legend=FALSE, main='Switzerland')
plot(DTM, col=rainbow(25, alpha=0.35), add=TRUE)


#create hillshade
slope <- terrain(DSM, opt='slope')
aspect <- terrain(DSM, opt='aspect')
hill <- hillShade(slope, aspect, 40, 270)
plot(hill, col=grey(0:100/100), legend=FALSE, main='Switzerland')
plot(DSM, col=rainbow(25, alpha=0.35), add=TRUE)

#export CHM object to new geotiff
writeRaster(hill,"HARV_DSMhill.tif",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

GDALinfo("HARV_DSMhill.tif")

########### CREATE SJER HILLSHADE 

DSM_SJER <- raster("NEON_RemoteSensing/SJER/DSM/SJER_dsmCrop.tif")
#create hillshade
slope_SJER <- terrain(DSM_SJER, opt='slope')
aspect_SJER <- terrain(DSM_SJER, opt='aspect')
hill_SJER <- hillShade(slope_SJER, aspect_SJER, 40, 270)


#export CHM object to new geotiff
writeRaster(hill_SJER,"SJER_dsmHill.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

DTM_SJER <- raster("NEON_RemoteSensing/SJER/DTM/SJER_dtmCrop.tif")
#create hillshade
slope_SJER <- terrain(DTM_SJER, opt='slope')
aspect_SJER <- terrain(DTM_SJER, opt='aspect')
hill_SJER <- hillShade(slope_SJER, aspect_SJER, 40, 270)

#export CHM object to new geotiff
writeRaster(hill_SJER,"SJER_dtmHill.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)
