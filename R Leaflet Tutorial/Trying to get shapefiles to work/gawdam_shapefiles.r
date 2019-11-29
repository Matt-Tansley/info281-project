library(rgdal)

# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
states <- readOGR("C:/Users/30mat/Documents/cb_2018_us_state_20m (1)/cb_2018_us_state_20m.shp",
                  layer = "cb_2018_us_state_20m", GDAL1_integer64_policy = TRUE)

neStates <- subset(states, states$STUSPS %in% c(
  "CT","ME","MA","NH","RI","VT","NY","NJ","PA"
))

nz_regions <- readOGR("C:/Users/30mat/Documents/statsnz2018-census-usually-resident-population-and-age-groups-by-re-SHP (1)/2018-census-usually-resident-population-and-age-groups-by-re.shp",
                      layer = "2018-census-usually-resident-population-and-age-groups-by-re", 
                      GDAL1_integer64_policy = TRUE)

subRegions <- subset(nz_regions, nz_regions$REGC2018_V1_00
 %in% c(
  1, 2, 3, 4
))

# THIS ONE WORKS ! :)
hawkes <- readOGR("C:/Users/30mat/Documents/lds-hawkes-bay-03m-rural-aerial-photos-index-tiles-2014-2015-SHP/hawkes-bay-03m-rural-aerial-photos-index-tiles-2014-2015.shp")

regional_council <- readOGR("C:/Users/30mat/Documents/statsnzregional-council-2018-generalised-SHP/regional-council-2018-generalised.shp")

digi_boundaries <- readOGR(dsn="C:/Users/30mat/Documents/ESRI_Shapefile_2016_Digital_Boundaries_Generalised_12_Mile/2016 Digital Boundaries Generalised 12 Mile",
                           layer = "REGC2016_GV_Full")

leaflet(hawkes) %>%
  addTiles() %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = 'yellow',
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))

