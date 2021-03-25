library(raster)
library(dplyr)
library(plyr)
# -------------------------------------------------------------------------
# ADD ENVIR DATA TO PRESENCE ----------------------------------------------
# -------------------------------------------------------------------------

#LEER BASE DE DATOS
presence <- read.table(file = "data/presence_sp.txt", header = TRUE, sep = " ")
head(presence)


#PROCESO PARA AGREGAR LAS VARIABLES AMBIENTALES DEL DÍA A LOS DATOS DE PRESENCIA
lab_date <- unique(presence$eventDate)

out <- list()
for(i in seq_along(lab_date)){
  input      <- presence %>% filter(eventDate == lab_date[i]) #filtra por fecha
  fnames     <- paste0("output/daily/raster_", lab_date[i], ".grd") #encuentra el raster por fecha
  Env        <- raster::stack(fnames) #leer el raster de esa fecha
  test       <- raster::extract(Env, input[,c("lon", "lat")], df = TRUE) #extrae las variables de esa fecha en las posiciones dadas.
  test       <- test[, -1] #elimina la primer columna ID
  out[[i]]   <- cbind(input, test)
}


#Junta las listas en un solo data.frame
presence_copernicus <- plyr::ldply(out, data.frame)

#Guardar la base de datos de presencia con su correspodientes variables ambientales que corresponde al día 
write.csv(x = presence_copernicus, file = "output/presence_copernicus.csv", row.names = FALSE)
