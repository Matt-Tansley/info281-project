# Load libraries.
library(leaflet)
library(rgdal)
library(tidyverse)
library(viridis)

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
internet_access <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/AIMS_ADDRESS_POSITION_NBBM_OUT_CSV.csv")

# Reading AIMS Address Position
address_position <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/lds-new-zealand-15layers-CSV/aims-address-position/aims-address-position.csv")

sample_addresses <- head(address_position, 100)

view(head(address_position, 10))
view(head(internet_access, 10))

# Combine data sets 
combined_data <- full_join(internet_access, address_position, 
                           by = "address_id")

# Select specific columns. 
selected_data <- combined_data[-c(3,4,5,8,9,10,13,14,15,18,19,20,23,24,25,33)]
# Rename columns. 
colnames(selected_data)[23:24] <- c("longitude", "latitude")               
        
view(head(selected_data, 10))

# Adding circle markers. 
m <- leaflet() %>% 
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  addPolygons(data = nz_regions, color = "#FFFFFF", 
              weight = 1, smoothFactor = 1,
              opacity = 1, fillOpacity = 1,
              fillColor = viridis(nrow(nz_regions@data)), 
              label = nz_regions@data$REGC2018_1) %>%
  addCircleMarkers(lat = sample_addresses$shape_Y, 
                   lng = sample_addresses$shape_X,
                   color = 'red',
                   weight = 1,
                   radius = 5)
m
