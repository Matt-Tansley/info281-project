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
  #addTiles() %>%
  addProviderTiles(providers$Hydda.Full) %>%
  # Center over NZ, using coordinates.
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  # Add polygons, using shapefile to divide by region.
  addPolygons(data = nz_regions, color = "#FFFFFF", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = 'yellow', label = nz_regions@data$REGC2018_1)
m

nz_regions <- readOGR("data/statsnzregional-council-2018-generalised-SHP (1)/regional-council-2018-generalised.shp")

hawkes <- readOGR("C:/Users/30mat/Documents/lds-hawkes-bay-03m-rural-aerial-photos-index-tiles-2014-2015-SHP/hawkes-bay-03m-rural-aerial-photos-index-tiles-2014-2015.shp")