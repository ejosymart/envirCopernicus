library(raster)
library(dplyr)
library(plyr)

# Read data (presence + envir) --------------------------------------------
presence <- read.csv("output/presence_copernicus.csv")



# Average observed days ------------------------------------------------------------
# In this case use the observed days
lab_time <- unique(presence$eventDate)

fnames                <- paste0("output/daily/raster_", lab_time, ".grd")
myStack               <- raster::stack(fnames)
myStackAverage        <- raster::stackApply(myStack, indices = rep(c(1,2,3), length(fnames)), fun = mean, na.rm = TRUE)
names(myStackAverage) <- c("CHL", "SSS", "SST")
writeRaster(myStackAverage, filename = "output/daily/average_observed.grd", overwrite = TRUE)


# Average a particular period -------------------------------------------------
# In this case use a particular time period
lab_time <- seq(as.Date("2014-01-01"), as.Date("2015-12-31"), by = "day")

fnames                <- paste0("output/daily/raster_", lab_time, ".grd")
myStack               <- raster::stack(fnames)
myStackAverage        <- raster::stackApply(myStack, indices = rep(c(1,2,3), length(fnames)), fun = mean, na.rm = TRUE)
names(myStackAverage) <- c("CHL", "SSS", "SST")
writeRaster(myStackAverage, filename = "output/daily/average_period.grd", overwrite = TRUE)