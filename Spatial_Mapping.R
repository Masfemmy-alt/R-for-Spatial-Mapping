
setwd("C:/Users/Ayoola_John/OneDrive/Desktop/Gis Exercise/Nigeria")

library(sf)
library(dplyr)
library(tmap)

# Load Nigeria admin boundary
State <- st_read("NGA_adm1.shp")
Oyo_state <- filter(State, NAME_1 == "Oyo")

# Load LGAs
LGA <- st_read("NGA_adm2.shp")

# Filter Ogbomoso North
OgbomosoNorth <- filter(LGA, NAME_2 == "Ogbomosho North")

# Towns Data
towns <- data.frame(
  name = c("Ogbomoso", "Ibadan", "Oyo Town"),
  lon = c(4.2667, 3.8964, 3.95),
  lat = c(8.1333, 7.3878, 7.85)
  
)

# Convert to sf
towns_sf <- st_as_sf(towns, coords = c("lon", "lat"), crs = 4326)
towns_sf <- st_transform(towns_sf, st_crs(Oyo_state))


Spatial_Mapping <-tm_shape(Oyo_state) +
  tm_borders(col = "black", lwd = 3) +
  
  tm_shape(OgbomosoNorth) +
  tm_borders(col = "red", lwd = 2) +
  
  tm_layout(
    outer.margins = c(0.02,0.04,0,0.04),
    asp = 1,
    legend.text.size = 0.5,
    legend.title.size = 0.8,
    legend.frame = TRUE) +
  
  tm_shape(towns_sf) +
  tm_symbols(size = 0.3, col = "black") +
  tm_text("name", size = 0.7, ymod = -0.3) +
  
  tm_credits("Data Source: NGA_adm Shapefiles\nDone by: Ayoola John Oluwafemi\nDate: 2 November, 2025",
             position = c(0.02, 0.09),
             size = 0.5, color ="#000000") +
  tm_credits("#R4GIS&RsM\nThanks Dickson Mbeya",
             fontface = "italic",
             position = c(0.73, 0.1),
             size = 0.5, color ="black") +
  
  tm_title("Spatial Mapping:\nCase study of Oyo State",
           color = "black", position = c(0.0001, 0.95), fontface = "bold", size = 1.1) +
  
  tm_add_legend(
    type = "lines",
    labels = c("Oyo State Boundary", "Ogbomoso North LGA"),
    col = c("black", "red"),
    lwd = c(3, 2),
    title = "Map Legend",
    position = c(0.75, 0.25)
  ) +
  
  tm_scalebar(text.size = 0.6, position = c(0.01, 0.16)) +
  tm_compass(type = "4star", position = c(0.8, 0.95)) +
  tm_graticules(alpha = 0) + 
  tm_logo("r.png", height = 1,position = c(0.9, 1))


Spatial_Mapping

tmap_save(Spatial_Mapping, "Spatial_Map_for_Oyo.png")


