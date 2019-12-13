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
library(shinyjs)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # NEED THIS LINE TO ACTULLY ENABLE SHINYJS
    useShinyjs(),

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            radioButtons("demographic",
                               label = "Select Demographic",
                               choices = list("Gender",
                                              "Age",
                                              "Job Situation",
                                              "Qualification"),
                               selected = "Gender"),
            
            radioButtons("comp_use",
                         label = "Computer Use",
                         choices = list("Has used a computer" = 1,
                                        "Uses a computer in every life outside of work" = 2,
                                        "Uses email" = 3,
                                        "Uses Internet to understand things/ general knowledge" = 4,
                                        "Uses the Internet for online transactions (e.g banking, online shopping" = 5,
                                        "Uses a programming language/ writes computer code" = 6,
                                        "Participates in online discussions (e.g chat rooms, online conferences)" = 7
                                        ),
                         selected = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("computer_users"),
            
            box(id = "myBox", title = "Tree Output", width = '800px',
                radioButtons(inputId = "myInput", label = "my input", choices = c("a", "b", "c"))
            ),
            conditionalPanel(condition = "input.myInput == 'a'",
                             box(id = "box_a", title = "AAA", width = '800px')),
            conditionalPanel(condition = "input.myInput == 'b'",
                             box(id = "box_b", title = "BBB", width = '800px'))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    ## observe the button being pressed
    observeEvent(input$myInput,{
        
        if(input$myInput == "a"){
            shinyjs::toggle(id = "box_a")
            shinyjs::toggle(id = "box_b")
        }else if(input$myInput == "b"){
            shinyjs::show(id = "box_b")
            shinyjs::hide(id = "box_a")
        }else{
            shinyjs::hide(id = "box_b")
            shinyjs::hide(id = "box_a")   
        }
    })
    
    demographics <- reactive({
        switch(input$demographic,
               "Gender" = demo_cleaned$gender,
               "Age" = demo_cleaned$age,
               "Job Situation" = demo_cleaned$job_situation,
               "Qualification" = demo_cleaned$qual_level
        )
    })
    
    computer_use <- reactive({
        switch(input$comp_use,
               '1' = demo_cleaned$used_computer,
               '2' = demo_cleaned$uses_a_computer_in_everyday_life_outside_work,
               '3' = demo_cleaned$email_use,
               '4' = demo_cleaned$using_internet_for_knowledge,
               '5' = demo_cleaned$using_internet_for_transactions,
               '6' = demo_cleaned$programming_language_use,
               '7' = demo_cleaned$participate_in_online_discussions
        )    
    })
    
    output$computer_users <- renderPlot({
        demo_cleaned %>%
            ggplot() +
            aes(x = demographics(), fill = demographics()) +
            geom_histogram(stat = 'count') +
            stat_count(binwidth = 1, geom = "text", color = "white",
                     size = 3.5, aes(label=..count..), 
                     position = position_stack(vjust = 0.5)
                     )+
            facet_wrap(~ computer_use())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
