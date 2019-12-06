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

# Load data
# Internet Markers
#all_connections <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/all_connections.csv") %>% 
#    na.omit() %>%
#    st_as_sf(coords = c("longitude", "latitude"), 
#             crs = 4326)
#adsl <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/adsl.csv") %>% 
#    na.omit() %>%
#    st_as_sf(coords = c("longitude", "latitude"), 
#             crs = 4326)
#cable <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/cable.csv") %>% 
#    na.omit() %>%
#    st_as_sf(coords = c("longitude", "latitude"), 
#             crs = 4326)
#fibre <-read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/fibre.csv") %>% 
#    na.omit() %>%
#    st_as_sf(coords = c("longitude", "latitude"), 
#             crs = 4326) 
#vdsl <-read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/vdsl.csv") %>% 
#    na.omit() %>%
#    st_as_sf(coords = c("longitude", "latitude"), 
#             crs = 4326)
#wireless <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/wireless.csv") %>% 
#    na.omit() %>%
#    st_as_sf(coords = c("longitude", "latitude"), 
#             crs = 4326)
#
### Shapefile Boundaries
#nz_regions <-
#    st_read(dsn = "data/statsnzregional-council-2018-generalised-SHP (1)/regional-council-2018-generalised.shp")%>% 
#    st_transform(crs="+init=epsg:4326") %>% 
#    ms_simplify(.)
#names(st_geometry(nz_regions)) = NULL 
#    
#nz_urban_rural <- 
#    st_read(dsn = "data/statsnzurban-rural-2018-generalised-SHP/urban-rural-2018-generalised.shp")%>% 
#    st_transform(crs="+init=epsg:4326") %>% 
#    ms_simplify(.)
#names(st_geometry(nz_urban_rural)) = NULL

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
                    h5("Number of Data Points in Each Area")
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

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$selected_var <- renderText({
        paste("You have selected:", input$shapefile)
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
                            'All Connections' = all_connections,
                            'ADSL' = adsl,
                            'Cable' = cable,
                            'Fibre' = fibre,
                            'VDSL' = vdsl,
                            'Wireless' = wireless
                            )
    })
    
   #m_cols <- reactive({
   #    switch(input$connection,
   #           'All Connections' = cbind(0, 0.2, 1),
   #           'ADSL' = cbind(0, 0.2, 1),
   #           'Cable' = cbind(0, 0.2, 1),
   #           'Fibre' = cbind(0, 0.2, 1),
   #           'VDSL' = cbind(0, 0.2, 1),
   #           'Wireless' = cbind(0, 0.2, 1)
   #           )
   #})
    
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


