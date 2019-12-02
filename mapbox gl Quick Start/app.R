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
    
    tags$head(
        tags$script(src='https://api.tiles.mapbox.com/mapbox-gl-js/v1.5.0/mapbox-gl.js'),
        tags$link(href='https://api.tiles.mapbox.com/mapbox-gl-js/v1.5.0/mapbox-gl.css', rel='stylesheet'),
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),

    tags$script(src = "script.js"),
    
    tags$div(id = 'map')
    )


server <- function(input, output) {
    
}

# Run the application 
shinyApp(ui = ui, server = server)
