# Count number of data points that fall within a polygon.
# Following this link: 
# https://gis.stackexchange.com/questions/110117/counting-number-of-points-in-polygon-using-r

library("raster")
library("sp")

x <- getData('GADM', country='ITA', level=1)
class(x)

set.seed(1)
# sample random points
p <- spsample(x, n=300, type="random")
p <- SpatialPointsDataFrame(p, data.frame(id=1:300))

proj4string(x)
proj4string(p)

plot(x)
plot(p, col="red" , add=TRUE)

res <- over(p, x)
table(res$NAME_1)



# Trying with own example -----------------------------

# Need two objects essentially.
# The coordinates (spatial points)
# Our current points
view(head(coords_nas_removed,10))
xy <- coords_nas_removed[,c(1,2)]

# Need to convert this to spatial points data frame
# Help from: https://stackoverflow.com/questions/29736577/how-to-convert-data-frame-to-spatial-coordinates
sp_dataframe <- SpatialPointsDataFrame(coords = xy,
                                       data = coords_nas_removed)

# The map/polygons (spatial polygons)
# We already have spatial polygons
view(head(nz_regions,10))

# Plot out points and polygons
# Region polygons
plot(nz_regions)

# Try with a few points first. 
a_few_points <- SpatialPointsDataFrame(coords = head(sp_dataframe,10),
                                       data = data.frame(id = 1:10),
                                       proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84")) 

# All data points
sp_dataframe <- SpatialPointsDataFrame(coords = xy,
                                       data = coords_nas_removed,
                                       proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))


plot(a_few_points, col="red" , add=TRUE)


# Check which region each data point is over
which_region <- over(a_few_points, nz_regions)
table(which_region$REGC2018_1)

which_region_v2 <- over(sp_dataframe, nz_regions)
table(which_region_v2$REGC2018_1)



# Using new wrangled individual CSV files, 9/12/2019 ------
view(head(all_connections,10))
xy <- select(all_connections, longitude, latitude)

sp_dataframe <- SpatialPointsDataFrame(coords = xy,
                                       data = all_connections,
                                       proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84"))

a_few_points <- SpatialPointsDataFrame(coords = head(sp_dataframe,10),
                                       data = data.frame(id = 1:10),
                                       proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84")) 

polys <- readOGR("data/statsnzregional-council-2018-generalised-SHP (1)/regional-council-2018-generalised.shp")

# Convert sf_dataframe to a SpatialPolygonsDataFrame
polys_2 <- as(nz_regions, 'Spatial')

spatial_nz_regions <- as(nz_regions, 'Spatial')
spatial_nz_urban_rural <- as(nz_urban_rural, 'Spatial')

# a few points
which_region <- over(a_few_points, spatial_nz_regions)
table(which_region$REGC2018_1)

# all points for regions
which_region <- over(sp_dataframe, spatial_nz_regions)
a_table <- as.data.frame(table(which_region$REGC2018_1)) 
view(a_table)

# all points for urban_rural
which_area_type <- over(sp_dataframe, spatial_nz_urban_rural)
table(which_area_type$IUR2018__1)


# Writing to csvs -------------------------------------
# REMEMBER, deparse(substitute()) returns variable name as a string

# for regions
write_region_connections <- function(marker_df){
  xy <- select(marker_df, longitude, latitude)
  print("coords selected")
  sp_dataframe <- SpatialPointsDataFrame(coords = xy,
                                         data = marker_df,
                                         proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84"))
  print("converted to sp_dataframe")
  which_region <- over(sp_dataframe, spatial_nz_regions)
  print("performed over function")
  a_table <- as.data.frame(table(which_region$REGC2018_1))
  print("created table")
  write_csv(x = a_table, 
            path = paste0("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/regions_count/regions_",deparse(substitute(marker_df)),".csv")) 
  print("wrote csv file")
}

# for urban/rural areas
write_urban_rural_connections <- function(marker_df){
  xy <- select(marker_df, longitude, latitude)
  print("coords selected")
  sp_dataframe <- SpatialPointsDataFrame(coords = xy,
                                         data = marker_df,
                                         proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84"))
  print("converted to sp_dataframe")
  which_area_type <- over(sp_dataframe, spatial_nz_urban_rural)
  print("performed over function")
  a_table <- as.data.frame(table(which_area_type$IUR2018__1))
  print("created table")
  write_csv(x = a_table, 
            path = paste0("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/urban_rurals_count/urban_rurals_",deparse(substitute(marker_df)),".csv")) 
  print("wrote csv file")
}

write_region_connections(all_connections)
write_region_connections(adsl)
write_region_connections(cable)
write_region_connections(fibre)
write_region_connections(vdsl)
write_region_connections(wireless)
write_urban_rural_connections(all_connections)
write_urban_rural_connections(adsl)
write_urban_rural_connections(cable)
write_urban_rural_connections(fibre)
write_urban_rural_connections(vdsl)
write_urban_rural_connections(wireless)






