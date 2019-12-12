shinyUI(fluidPage(
    
    sidebarLayout(
        fluidRow( 
            column(4, wellPanel(
                
                fluidRow(
                    column(5,selectInput("gender",
                                         label = div("Sexe",style = "color:royalblue"),
                                         choices = list("Male", "Female"),
                                         selected = "Female")),
                    
                    # other different widjets..        
                    
                    column(8, plotOutput('simulationChange')),
                    column(4, tableOutput('simulationChangeTable'),
                           tags$style("#simulationChangeTable table {font-size:9pt;background-color: #E5E4E2;font-weight:bold;margin-top: 121px; margin-left:-30px;overflow:hidden; white-space:nowrap;text-align:left;align:left;}", 
                                      media="screen", 
                                      type="text/css"), 
                           fluidRow(
                               column(6, tableOutput('simulationChangeEsperance'),
                                      tags$style("#simulationChangeEsperance table {font-size:9pt;background-color: #E5E4E2;font-weight:bold;margin-top: -10px; margin-left:-30px;overflow:hidden; white-space:wrap;word-break: break-word;width:173px;text-align:left;}"))
                           )
                    )
                )
            )
            )
        ))  
    
    shinyServer(function(input, output, session) {
        # part of my server.R code
        observe({
            
            
            if (input$gender|input$age|input$birthplace|input$education){  
                shinyjs::hide("simulationChange")
                shinyjs::hide("simulationChangeTable")
                shinyjs::hide("simulationChangeEsperance")
            }      
        })