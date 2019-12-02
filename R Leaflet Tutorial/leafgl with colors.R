library(mapview)
library(leaflet)
library(leafgl)
library(sf)
library(colourvalues)

n = 1e6

df1 = data.frame(id = 1:n,
                 x = rnorm(n, 10, 3),
                 y = rnorm(n, 49, 1.8))

pts = st_as_sf(df1, coords = c("x", "y"), crs = 4326)

cols = colour_values_rgb(pts$id, include_alpha = FALSE) / 255

options(viewer = NULL)

system.time({
  m = leaflet() %>%
    addProviderTiles(provider = providers$CartoDB.DarkMatter) %>%
    addGlPoints(data = pts, color = cols, group = "pts") %>%
    addMouseCoordinates() %>%
    setView(lng = 10.5, lat = 49.5, zoom = 6) %>% 
    addLayersControl(overlayGroups = "pts")
})

m
