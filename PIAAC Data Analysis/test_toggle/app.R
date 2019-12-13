library(shiny)
library(shinydashboard)
library(shinyjs)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            useShinyjs()
        ),
        mainPanel(
            box(id = "myBox", title = "Tree Output", width = '800px',
                selectInput(inputId = "myInput", label = "my input", choices = c(letters))
            ),
            actionButton(inputId = "a_button", label = "show / hide")
        )
    )
)

server <- function(input, output){
    
    ## observe the button being pressed
    observeEvent(input$myInput, {
        
        if(input$a_button %in% c("a")){
            shinyjs::hide(id = "myBox")
        }else{
            shinyjs::show(id = "myBox")
        }
    })
}

shinyApp(ui, server)