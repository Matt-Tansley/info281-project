## app.R ##
library(shinydashboard)
library(leaflet)

ui <- dashboardPage(skin = 'purple',
    dashboardHeader(title = "Digital Inclusion Dashboard",
                    titleWidth = '300px'),
    ## Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Home", tabName = "home", icon = icon("home")),
            menuItem("Map", tabName = "map", icon = icon("globe-americas")),
            menuItem("PIAAC", tabName = "piaac", icon = icon("chart-bar")),
            menuItem("PISA", tabName = "education", icon = icon("laptop"))
        )
    ),
    ## Body content
    dashboardBody(
        tabItems(
            tabItem(tabName = "home",
                    fluidRow(
                        h3("hello world")
                    )
            ),
            # Map tab
            tabItem(tabName = "map",
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
                                leafgl::leafglOutput("internet_map")    
                            )    
                        )
                    )
            ),
            
            # Second tab content
            tabItem(tabName = "piaac",
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
            ),
            tabItem(tabName = "education",
                    fluidRow(
                        column(
                            width = 5,
                            box(
                                width = NULL,
                                title = "PISA Questions",
                                height = "400px",
                                selectInput("pisa_question",
                                            "Select Question",
                                            choices = pisa_questions$q_label),
                                radioButtons("chart_type",
                                             "Type of Chart",
                                             choices = c("Pie",
                                                         "Histogram",
                                                         "Waffle",
                                                         "Lollipop")),
                                textOutput("q"),
                                uiOutput("a")
                            )
                        ),
                        column(
                            width = 7,
                            box(
                                width = NULL
                            )
                        )
                    ))
        )
    )
)

server <- function(input, output) {

    # Load data files -------------------------------------
    pisa_questions <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/questions_to_analyse.csv")
    
    selected_question <- reactive({
        input$pisa_question
    })
    
    question_responses <- reactive({
        filter(pisa_agg, q_name == 'IC001Q01TA')
    })
    
    output$q <- renderText(selected_question())
    output$a <- renderTable({question_responses()})
}

shinyApp(ui, server)