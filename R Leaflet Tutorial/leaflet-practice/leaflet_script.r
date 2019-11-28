# Load libraries.
library(leaflet)
library(rgdal)

# Create leaflet object.
m <- leaflet()
m

m <- leaflet() %>%
  # Add base map. 
  addTiles() %>%
  # Center over NZ, using coordinates.
  setView(lat = -40.9006, lng = 174.8860, zoom = 4)
m


# Uses providerTiles to change default map theme. 
m <- leaflet() %>%
  # Add base map. 
  addProviderTiles(providers$Hydda.Full) %>%
  # Center over NZ, using coordinates.
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  addPolygons(data = nz_electorates, weight = 3, color = 'red')
m


# Read NZ 2020 General Electorate shapefile
# Seems to read fine, but doesn't work when I try to put it 
# on the map.
nz_electorates <- readOGR(
  "data/statsnzproposed-general-electorates-2020-SHP (1)/proposed-general-electorates-2020.shp")
