setwd("C:/Users/Ayoola_John/OneDrive/Desktop/Gis Exercise/Nigeria")
library(sf)
library(dplyr)
library(ggplot2)
library(ggspatial)
library(leaflet)
library(htmlwidgets)

getwd()
# Load Nigeria admin boundary
State <- st_read("NGA_adm1.shp")
plot(State$geometry)

# Filter Oyo State
Oyo_state <- filter(State, NAME_1 == "Oyo")
plot(Oyo_state$geometry)

# Load LGAs
LGA <- st_read("NGA_adm2.shp")

# Filter Ogbomoso North (adjust spelling if needed)
OgbomosoNorth <- filter(LGA, NAME_2 == "Ogbomosho North")

# Match projection
Oyo <- st_transform(Oyo_state, st_crs(OgbomosoNorth))

# Intersection: confirm boundary overlap
C <- st_intersection(OgbomosoNorth, Oyo)

# Plot intersection
plot(Oyo$geometry)
plot(C$geometry, add = TRUE, lty = 6, col = "red")

# Towns Data
towns <- data.frame(
  name = c("Ogbomoso", "Ibadan", "Oyo Town"),
  lon = c(4.2667, 3.8964, 3.95),
  lat = c(8.1333, 7.3878, 7.85)
)

# Convert to sf
towns_sf <- st_as_sf(towns, coords = c("lon", "lat"), crs = 4326)
towns_sf <- st_transform(towns_sf, st_crs(Oyo))

# Create map object
p <- ggplot() +
  geom_sf(data = Oyo, fill = "white", color = "green", size = 0.8) +
  geom_sf(data = C, fill = NA, color = "red", size = 1.4) +
  geom_sf(data = towns_sf, size = 2) +
  geom_sf_text(data = towns_sf, aes(label = name), size = 3, nudge_y = 0.1) +
  labs(
    title = "Ogbomoso North within Oyo State",
    subtitle = "With Major Town Locations",
    caption ="Data Source: NGA_adm Shapefiles",
    x = "Longitude",
    y = "Latitude"
  ) +
  annotation_scale(location = "bl", width_hint = 0.2) +
  annotation_north_arrow(location = "tr", 
                         style = north_arrow_fancy_orienteering()) +
  theme_minimal()

# Display
print(p)

# Save Map
ggsave("OgbomosoNorth_Oyo_Map.png", p, width = 9, height = 6, dpi = 900)

# Leaflet interactive map
leaflet() %>%
  addTiles() %>%
  addPolygons(data = Oyo, weight = 2, color = "black", fillOpacity = 0.1,
              label = "Oyo State") %>%
  addPolygons(data = C, weight = 3, color = "red",
              label = "Ogbomoso North LGA") %>%
  addCircleMarkers(data = towns_sf, radius = 5, popup = towns_sf$name) %>%
  addScaleBar(position = "topleft") %>%
  addMiniMap(toggleDisplay = TRUE)


# Save leaflet widget
saveWidget(
  leaflet() %>%
    addTiles() %>%
    addPolygons(data = Oyo, weight = 2, color = "black", fillOpacity = 0.1) %>%
    addPolygons(data = C, weight = 3, color = "red") %>%
    addCircleMarkers(data = towns_sf, radius = 5, popup = towns_sf$name) %>%
    addScaleBar(position = "bottomleft") %>%
    addMiniMap(toggleDisplay = TRUE),
  file = "OgbomosoNorth_Oyo_Leaflet.html"
)


install.packages("h2o")

install.packages("h2o", type = "source",
                 repos = "https://h2o-release.s3.amazonaws.com/h2o/latest_stable_R")
