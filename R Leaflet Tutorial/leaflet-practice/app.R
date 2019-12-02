#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Internet Connections NZ Map"),

    sidebarLayout(
        sidebarPanel(
            radioButtons('connection',
                         'Type of Internet Connection',
                         choices = list('ADSL',
                                        'Cable',
                                        'Fibre',
                                        'VDSL',
                                        'Wireless'
                                        ),
                        selected = "ADSL"
                        )    
        ),

        mainPanel(
            leafletOutput("internet_map"),

        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    #output$internet_map <- renderLeaflet({
        
        # Load data based on user input choice. 
        connection_data <- switch(input$connection,
                                  'ADSL' = 
                                  'Cable',
                                  'Fibre',
                                  'VDSL',
                                  'Wireless'
                                  )
        
        leaflet() %>% 
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
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
