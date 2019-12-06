# Load libraries.
library(leaflet)
library(rgdal)
library(tidyverse)
library(viridis)
devtools::install_github("rstudio/leaflet.mapboxgl")

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

# Write wrangled data to csv. 
write_csv(selected_data,"C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/wrangled_and_combined_internet_data.csv")

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


# Writing CSV files to separate by connection type --------
# Load data to work with
address_markers <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/wrangled_and_combined_internet_data.csv")

# Renaming columns
colnames(address_markers)[1:10] <- c("adsl", 
                                     "adsl_availability",
                                     "cable",
                                     "cable_availability",
                                     "fibre",
                                     "fibre_availability",
                                     "vdsl",
                                     "vdsl_availability",
                                     "wireless",
                                     "wireless_availability") 

write_csv(address_markers,"C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/wrangled_and_combined_internet_data.csv")

adsl <- data.frame(address_markers %>% select(1,2,23,24))
adsl <- filter(adsl, adsl == 1)
write_csv(adsl, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/adsl.csv")

cable <- data.frame(address_markers %>% select(3,4,23,24))
cable <- filter(cable, cable == 1)
write_csv(cable, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/cable.csv")

fibre <- data.frame(address_markers %>% select(5,6,23,24))
fibre <- filter(fibre, fibre == 1)
write_csv(fibre, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/fibre.csv")

vdsl <- data.frame(address_markers %>% select(7,8,23,24))
vdsl <- filter(vdsl, vdsl == 1)
write_csv(vdsl, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/vdsl.csv")

all_connections <- data.frame(address_markers %>% select(23,24))
write_csv(all_connections, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/all_connections.csv")

  
# Adding Markers --------------------------------------

# Using the following tutorial:
# https://rstudio.github.io/leaflet/markers.html?fbclid=IwAR3dfeUjSatI86WNbqI5Owqxj04FRuuiRpHVuV7-EGZkE370nYhAZwYUE6U

# Read wrangled dataset. 
address_markers <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/wrangled_and_combined_internet_data.csv")
wireless <- data.frame(address_markers %>% select(9,10,23,24))
wireless <- filter(wireless, wireless == 1)
write_csv(wireless, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/wireless.csv")view(head(address_markers, 20))
sample_markers <- head(address_markers, 20)

m <- leaflet() %>% 
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  addPolygons(data = nz_regions, color = "#FFFFFF", 
              weight = 1, smoothFactor = 1,
              opacity = 1, fillOpacity = 1,
              fillColor = viridis(nrow(nz_regions@data)), 
              label = nz_regions@data$REGC2018_1) %>%
  addMarkers(data = sample_markers, 
             lat = sample_markers$latitude, 
             lng = sample_markers$longitude,
             clusterOptions = markerClusterOptions()
             )
m



# Attempting leafgl package ---------------------------

devtools::install_github("r-spatial/leafgl")
library(mapview)
library(leaflet)
library(leafgl)
library(sf)
library(colourvalues)

# Load data.
address_markers <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/wrangled_and_combined_internet_data.csv")

# Get a data frame of just lat/lng coords.
coords_df <- address_markers %>% select(20,23,24)

# Remove NA values. 
coords_nas_removed <- na.omit(coords_df)

coords_sf = st_as_sf(coords_nas_removed, 
                     coords = c("longitude", "latitude"), 
                     crs = 4326)

options(viewer = NULL) # view in browser

cols = colour_values_rgb(coords_nas_removed$address_type_id, 
                         include_alpha = FALSE) / 255

m <- leaflet() %>% 
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
  setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
  addPolygons(data = nz_regions, color = "#FFFFFF", 
              weight = 1, smoothFactor = 1, opacity = 1,
              label = nz_regions@data$REGC2018_1) %>%
  # Adding points.
  addGlPoints(data = coords_sf, 
              group = "coords",
              color = cols) 
m


# Wrangling Data Further ------------------------------
colnames(address_markers)[20] <- c("address_type_id")

write_csv(address_markers,"C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/wrangled_and_combined_internet_data.csv")


