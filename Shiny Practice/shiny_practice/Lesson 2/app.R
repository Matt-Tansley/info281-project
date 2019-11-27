#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI ----
ui <- fluidPage(
    titlePanel("My Shiny App"),
    sidebarLayout(
        sidebarPanel(
            h1("Installation"),
            p("Shiny is available on CRAN so you can install 
              it in the usual way from your R console:"),
            code('install.packages("shiny")'),
            img(src="rstudio.png", height = 60, width = 120),
            p("Shiny is a product of", a("RStudio"))
        ),
        mainPanel(
           
        )
    )
)

# Define server logic ----
server <- function(input, output) {
    
}

# Run the app ----
shinyApp(ui = ui, server = server)

# Run the application 
# runApp("app.r", display.mode = "showcase")
