library(ncdf4)
library(raster)


# COPERNICUS --------------------------------------------------------------
# Download data 01-01-2014 al 31-12-2015 | lon: c(-125, -117) | lat: c(32, 42)
# Please, go to the COPERNICUS WEBSITE and download SST, SSS and CHL using the 
# information detailed above

# DAILY -------------------------------------------------------------------

# Sea Surface Temperature -------------------------------------------------
sst_cop <- nc_open("data/daily/global-reanalysis-phy-001-030-daily_sea_surface_temperature.nc")

# get longitude and latitude
lon_sst <- ncvar_get(sst_cop, "longitude")
lat_sst <- ncvar_get(sst_cop,"latitude")

# get time
time_sst <- ncvar_get(sst_cop,"time")
date_sst <- as.Date(as.POSIXct(time_sst*3600, origin = '1950-01-01 00:00'))

# get sst
x_sst <- ncvar_get(sst_cop, sst_cop$var[[1]]$name)



# Sea Surface Salinity ---------------------------------------------------
sss_cop <- nc_open("data/daily/global-reanalysis-phy-001-030-daily_sea_surface_salinity.nc")

# get longitude and latitude
lon_sss <- ncvar_get(sss_cop, "longitude")
lat_sss <- ncvar_get(sss_cop,"latitude")

# get time
time_sss <- ncvar_get(sss_cop,"time")
date_sss <- as.Date(as.POSIXct(time_sss*3600, origin = '1950-01-01 00:00'))

# get sss
x_sss <- ncvar_get(sss_cop, sss_cop$var[[1]]$name)



# Chlorophyll -------------------------------------------------------------
chl_cop <- nc_open("data/daily/global-reanalysis-bio-001-029-daily_chlorophyll.nc")

# get longitude and latitude
lon_chl <- ncvar_get(chl_cop, "longitude")
lat_chl <- ncvar_get(chl_cop,"latitude")

# get time
time_chl <- ncvar_get(chl_cop,"time")
date_chl <- as.Date(as.POSIXct(time_chl*3600, origin = '1950-01-01 00:00'))

# get chl
x_chl <- ncvar_get(chl_cop, chl_cop$var[[1]]$name)


# Raster daily ----------------------------------------------------------
myList <- list()
label <- date_sst
for(i in seq_along(label)){
  myList$x <- lon_sst
  myList$y <- lat_sst
  myList$z <- x_sst[,,i]
  r        <- raster(myList)
  writeRaster(r, filename = paste0("output/daily/sst_", label[i], ".grd"), overwrite=TRUE)
}


myList <- list()
label <- date_sss
for(i in seq_along(label)){
  myList$x <- lon_sss
  myList$y <- lat_sss
  myList$z <- x_sss[,,i]
  r        <- raster(myList)
  writeRaster(r, filename = paste0("output/daily/sss_", label[i], ".grd"), overwrite=TRUE)
}


myList <- list()
label <- date_chl
for(i in seq_along(label)){
  myList$x <- lon_chl
  myList$y <- lat_chl
  myList$z <- x_chl[,,i]
  r        <- raster(myList)
  writeRaster(r, filename = paste0("output/daily/chl_", label[i], ".grd"), overwrite=TRUE)
}




# UNIFORM EXTENT Y RESOLUTION -------------------------------------------
minDate <- as.Date('2014-01-01')
maxDate <- as.Date('2015-12-31')
labelTime <- seq(minDate, maxDate, by = "day")

# Joint the individual daily SST, SSS and CHL rasters into a single raster.
# In addition, the resolution is standardized, since CHL comes from another "product" and has a resolution of 0.25.
# The result is that you will have a raster per day with the 3 environmental variables (you can append many more variables). 
for(i in seq_along(labelTime)){
  fnames <- list.files(path ='output/daily/',
                       pattern = paste0(labelTime[i],".grd"), full.names=TRUE)
  Env1  <- raster::stack(fnames[1]) #raster de CHL
  Env2  <- raster::stack(fnames[c(2,3)]) #raster de SST y SSS
  Env3  <- raster::resample(Env1, Env2, resample = 'bilinear') #uniformizar la resolución
  out   <- stack(Env3, Env2)
  names(out) <- c("CHL", "SSS", "SST")
  writeRaster(out, filename = paste0("output/daily/raster_", labelTime[i], ".grd"), overwrite=TRUE)
}






# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------


# MONTHLY -----------------------------------------------------------------

# Sea Surface Temperature -------------------------------------------------
sst_cop <- nc_open("data/monthly/global-reanalysis-phy-001-030-monthly_sea_surface_temperature.nc")

# get longitude and latitude
lon_sst <- ncvar_get(sst_cop, "longitude")
lat_sst <- ncvar_get(sst_cop,"latitude")

# get time
time_sst <- ncvar_get(sst_cop,"time")
date_sst <- as.Date(as.POSIXct(time_sst*3600, origin = '1950-01-01 00:00'))
date_sst <- as.Date(paste0(year(date_sst), "-", month(date_sst), "-", 16), format =  "%Y-%m-%d")

# get sst
x_sst <- ncvar_get(sst_cop, sst_cop$var[[1]]$name)



# Sea Surface Salinity ---------------------------------------------------
sss_cop <- nc_open("data/monthly/global-reanalysis-phy-001-030-monthly_sea_surface_salinity.nc")

# get longitude and latitude
lon_sss <- ncvar_get(sss_cop, "longitude")
lat_sss <- ncvar_get(sss_cop,"latitude")

# get time
time_sss <- ncvar_get(sss_cop,"time")
date_sss <- as.Date(as.POSIXct(time_sss*3600, origin = '1950-01-01 00:00'))
date_sss <- as.Date(paste0(year(date_sss), "-", month(date_sss), "-", 16), format =  "%Y-%m-%d")

# get sss
x_sss <- ncvar_get(sss_cop, sss_cop$var[[1]]$name)



# Chlorophyll -------------------------------------------------------------
chl_cop <- nc_open("data/monthly/global-reanalysis-bio-001-029-monthly_chlorophyll.nc")

# get longitude and latitude
lon_chl <- ncvar_get(chl_cop, "longitude")
lat_chl <- ncvar_get(chl_cop,"latitude")

# get time
time_chl <- ncvar_get(chl_cop,"time")
date_chl <- as.Date(as.POSIXct(time_chl*3600, origin = '1950-01-01 00:00'))
date_chl <- as.Date(paste0(year(date_chl), "-", month(date_chl), "-", 16), format =  "%Y-%m-%d")

# get chl
x_chl <- ncvar_get(chl_cop, chl_cop$var[[1]]$name)



# Raster monthly ----------------------------------------------------------
myList <- list()
label <- date_sst
for(i in seq_along(label)){
  myList$x <- lon_sst
  myList$y <- lat_sst
  myList$z <- x_sst[,,i]
  r        <- raster(myList)
  writeRaster(r, filename = paste0("output/monthly/sst_", label[i], ".grd"), overwrite=TRUE)
}


myList <- list()
label <- date_sss
for(i in seq_along(label)){
  myList$x <- lon_sss
  myList$y <- lat_sss
  myList$z <- x_sss[,,i]
  r        <- raster(myList)
  writeRaster(r, filename = paste0("output/monthly/sss_", label[i], ".grd"), overwrite=TRUE)
}


myList <- list()
label <- date_chl
for(i in seq_along(label)){
  myList$x <- lon_chl
  myList$y <- lat_chl
  myList$z <- x_chl[,,i]
  r        <- raster(myList)
  writeRaster(r, filename = paste0("output/monthly/chl_", label[i], ".grd"), overwrite=TRUE)
}




# UNIFORME EXTENT AND RESOLUTION ------------------------------------------
minDate <- as.Date('2014-01-16')
maxDate <- as.Date('2015-12-16')
labelTime <- seq(minDate, maxDate, by = "month")

for(i in seq_along(labelTime)){
  fnames <- list.files(path ='output/monthly/',
                       pattern = paste0(labelTime[i],".grd"), full.names=TRUE)
  Env1  <- raster::stack(fnames[1])
  Env2  <- raster::stack(fnames[c(2,3)])
  Env3  <- raster::resample(Env1, Env2, method = 'bilinear')
  out   <- stack(Env3, Env2)
  names(out) <- c("CHL", "SSS", "SST")
  writeRaster(out, filename = paste0("output/monthly/raster_", labelTime[i], ".grd"), overwrite=TRUE)
}