# Load libraries.
library(leaflet)
library(rgdal)
library(tidyverse)
library(viridis)
library(sf)
library(raster)
library(rmapshaper)

# Read shapefile.
rural_urban_boundaries <- 
  readOGR(dsn = "data/statsnzurban-rural-2018-generalised-SHP/urban-rural-2018-generalised.shp",
          layer = 'urban-rural-2018-generalised')

shapename <- st_read(dsn = "data/statsnzurban-rural-2018-generalised-SHP/urban-rural-2018-generalised.shp")%>% 
  st_transform(crs="+init=epsg:4326") %>% 
  ms_simplify(.)
names(st_geometry(shapename)) = NULL

# Leaflet map object.  
boundaries_map <- leaflet() %>% 
  # Add base map with provider tile theme. 
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
  # Center over NZ, using coordinates.
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  # Add polygons, using shapefile to divide by region.
  addPolygons(data = shapename, 
              color = "#FFFFFF", 
              weight = 1, smoothFactor = 1,
              opacity = 1, fillOpacity = 1,
              fillColor = viridis(nrow(shapename)), 
              label = shapename$IUR2018__1)
boundaries_map
