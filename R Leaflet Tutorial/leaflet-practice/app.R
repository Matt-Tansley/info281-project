#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(leafgl)
library(sf)
library(rmapshaper)
library(viridis)

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
                                 choices = list('ADSL',
                                                'Cable',
                                                'Fibre',
                                                'VDSL',
                                                'Wireless'
                                 ),
                                 selected = "ADSL"
                    )
                ),
                
                box(width = NULL,
                    selectInput('shapefile',
                                "Shapefile",
                                choices = list('Regions',
                                               'Rural/Urban'),
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
               "Rural/Urban" = shapename
        )        
    })
    
    m_label <- reactive({
        switch(input$shapefile,
               "Regions" = nz_regions@data$REGC2018_1, 
               "Rural/Urban" = shapename$IUR2018__1
        )
    })
    
    output$internet_map <- renderLeaflet({
        
        # Load data based on user input choice. 
        #connection_data <- switch(input$connection,
        #                          'ADSL' = 
        #                          'Cable',
        #                          'Fibre',
        #                          'VDSL',
        #                          'Wireless'
        #                          )
        
        leaflet() %>% 
        addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
        setView(lat = -40.9006, lng = 174.8860, zoom = 4) %>%
        addPolygons(color = "#FFFFFF", 
                    weight = 1, 
                    smoothFactor = 1, 
                    opacity = 1,
                    data = m_data(),
                    label = m_label()
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)


