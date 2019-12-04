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


