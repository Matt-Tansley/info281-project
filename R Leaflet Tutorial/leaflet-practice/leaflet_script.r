# Load libraries.
library(leaflet)
library(rgdal)

# Basic map.
m <- leaflet() %>%
  # Add base map. 
  addTiles() %>%
  # Center over NZ, using coordinates.
  setView(lat = -40.9006, lng = 174.8860, zoom = 4)
m

# Customised map. 
m <- leaflet() %>% 
  # Add base map. 
  #addTiles() %>%
  # Use an alternative tile set (different theme).
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
  # Center over NZ, using coordinates.
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  # Add polygons, using shapefile to divide by region.
  # Colour and add labels. 
  # viridis generates a colour palette of n colours, where
  # n is the number of rows in the nz_region@data data.frame.
  addPolygons(data = nz_regions, color = "#FFFFFF", 
              weight = 1, smoothFactor = 1,
              opacity = 1, fillOpacity = 1,
              fillColor = viridis(nrow(nz_regions@data)), 
              label = nz_regions@data$REGC2018_1)
m

# Reading shapefiles.
nz_regions <- readOGR("data/statsnzregional-council-2018-generalised-SHP (1)/regional-council-2018-generalised.shp")

hawkes <- readOGR("C:/Users/30mat/Documents/lds-hawkes-bay-03m-rural-aerial-photos-index-tiles-2014-2015-SHP/hawkes-bay-03m-rural-aerial-photos-index-tiles-2014-2015.shp")

# Reading InternetNZ Data.
# Unfortunately I cannot make this data public, so it will
# not be uploaded to GitHub. 

# Reading AIMS Address Position
address_position <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/lds-new-zealand-15layers-CSV/aims-address-position/aims-address-position.csv")

# Adding circle markers. 
m <- leaflet() %>% 
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  addPolygons(data = nz_regions, color = "#FFFFFF", 
              weight = 1, smoothFactor = 1,
              opacity = 1, fillOpacity = 1,
              fillColor = viridis(nrow(nz_regions@data)), 
              label = nz_regions@data$REGC2018_1) %>%
  addCircleMarkers(lat = address_position$shape_Y, 
                   lng = address_position$shape_X)
m
