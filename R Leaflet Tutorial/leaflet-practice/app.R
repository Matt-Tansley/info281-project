#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load libraries
library(shiny)
library(shinydashboard)
library(leaflet)
library(leafgl)
library(sf)
library(rmapshaper)
library(viridis)
library(tidyverse)
library(rgdal)


# Loading data files ----------------------------------
# Load data.
# Internet Markers.
# Two types of dataframes:
# Just a standard data.frame with NA values removed, used to,
# get a count of markers inside a polygon.
# And sf_frame, which is used to plot markers on the map.
all_connections <-  read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/all_connections.csv") %>% 
    na.omit()
sf_all_connections <- st_as_sf(all_connections, 
                               coords = c("longitude", "latitude"), 
                               crs = 4326)

adsl <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/adsl.csv") %>% 
    na.omit()
sf_adsl <- st_as_sf(adsl,
                    coords = c("longitude", "latitude"), 
                    crs = 4326)

cable <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/cable.csv") %>% 
    na.omit()
sf_cable <- st_as_sf(cable,
                     coords = c("longitude", "latitude"), 
                     crs = 4326)

fibre <-read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/fibre.csv") %>% 
    na.omit()
sf_fibre <-  st_as_sf(fibre,
                      coords = c("longitude", "latitude"), 
                      crs = 4326) 

vdsl <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/vdsl.csv") %>% 
    na.omit()
sf_vdsl <- st_as_sf(vdsl,
                    coords = c("longitude", "latitude"), 
                    crs = 4326)

wireless <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/wireless.csv") %>% 
    na.omit()
sf_wireless <- st_as_sf(wireless,
                        coords = c("longitude", "latitude"), 
                        crs = 4326)

# Shapefile Boundaries
# Two files:
# sf_dataframe for rendering the polygons on a map.
# SpatialPolygonsDataFrame for checking if a marker is 
# inside a polygon. 
nz_regions <-
    st_read(dsn = "data/statsnzregional-council-2018-generalised-SHP (1)/regional-council-2018-generalised.shp")%>% 
    st_transform(crs="+init=epsg:4326") %>% 
    ms_simplify(.)
names(st_geometry(nz_regions)) = NULL 

spatial_nz_regions <- as(nz_regions, 'Spatial')


nz_urban_rural <- 
    st_read(dsn = "data/statsnzurban-rural-2018-generalised-SHP/urban-rural-2018-generalised.shp")%>% 
    st_transform(crs="+init=epsg:4326") %>% 
    ms_simplify(.)
names(st_geometry(nz_urban_rural)) = NULL

spatial_nz_urban_rural <- as(nz_urban_rural, 'Spatial')


# Actual Shiny App ------------------------------------
# Define UI for application
ui <- dashboardPage(
    dashboardHeader(title = "Internet Connections NZ Map"),
    dashboardSidebar(),
    dashboardBody(
        fluidRow(
            column(
                width = 4,
                box(width = NULL,
                    radioButtons('connection',
                                 'Type of Internet Connection',
                                 choices = list('All Connections',
                                                'ADSL',
                                                'Cable',
                                                'Fibre',
                                                'VDSL',
                                                'Wireless'
                                 ),
                                 selected = "All Connections"
                    )
                ),
                
                box(width = NULL,
                    selectInput('shapefile',
                                "Shapefile",
                                choices = list('Regions',
                                               'Urban/Rural'),
                                selected = 'Regions'
                    ),
                    
                    textOutput("selected_var")
                ),
                
                box(width = NULL,
                    h5("Number of Data Points in Each Area"),
                    tableOutput("data_point_counts")
                )
            ),   
            
            column(
                width = 8,
                box(
                    width = NULL,
                    title = 'Map',
                    height = '400px',
                    leafglOutput("internet_map")    
                )    
            )
        )
    )
)

# Define server logic 
server <- function(input, output) {
    
    # Test function/ tells user which shapefile they have 
    # selected. 
    output$selected_var <- renderText({
        paste("You have selected:", input$shapefile)
    })
    
    # Updates output for count of data points in each 
    # polygon.
    
    data_point_region_connection <- reactive({
        switch(input$connection,
            'All Connections' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/all_connections.csv"),
            'ADSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/adsl.csv"),
            'Cable' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/cable.csv"),
            'Fibre' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/fibre.csv"),
            'VDSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/vdsl.csv"),
            'Wireless' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/wireless.csv")
        )  
    })
    
    data_point_area_connection <- reactive({
        switch(input$connection,
               'All Connections' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/all_connections.csv"),
               'ADSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/adsl.csv"),
               'Cable' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/cable.csv"),
               'Fibre' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/fibre.csv"),
               'VDSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/vdsl.csv"),
               'Wireless' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/wireless.csv")
        )  
    })
    
    output$data_point_counts <- renderTable({
        if(input$shapefile == "Regions"){
            data_point_region_connection()      
        }else if(input$shapefile == "Urban/Rural"){
             data_point_area_connection()
        }    
    })
    
    
    
    m_data <- reactive({
        switch(input$shapefile,
               "Regions" = nz_regions, 
               "Urban/Rural" = nz_urban_rural
        )        
    })
    
    m_label <- reactive({
        switch(input$shapefile,
               "Regions" = nz_regions$REGC2018_1, 
               "Urban/Rural" = nz_urban_rural$IUR2018__1
        )
    })
    
    m_connection <- reactive({
        switch(input$connection,
               'All Connections' = sf_all_connections,
               'ADSL' = sf_adsl,
               'Cable' = sf_cable,
               'Fibre' = sf_fibre,
               'VDSL' = sf_vdsl,
               'Wireless' = sf_wireless
        )
    })
    
    m_cols <- reactive({
        switch(input$connection,
               'All Connections' = cbind(0, 0.2, 1),
               'ADSL' = cbind(0, 0.2, 1),
               'Cable' = cbind(0, 0.2, 1),
               'Fibre' = cbind(0, 0.2, 1),
               'VDSL' = cbind(0, 0.2, 1),
               'Wireless' = cbind(0, 0.2, 1)
               )
    })
  
    output$internet_map <- renderLeaflet({
        
        leaflet() %>% 
            addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
            setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
            addPolygons(color = "#FFFFFF", 
                        weight = 1, 
                        smoothFactor = 1, 
                        opacity = 1,
                        data = m_data(),
                        label = m_label()
            ) %>%
            # Adding points.
            addGlPoints(data = m_connection(), 
                        group = "coords",
                        color = cbind(0, 0.2, 1)
            ) 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)




