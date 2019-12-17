## app.R ##
library(shinydashboard)
library(leaflet)


# Load data files -------------------------------------
# PISA Data -------------------------------------------
pisa_questions <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/questions_to_analyse.csv")
wrangled_data <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/selected_questions_grouped/nas_removed_pisa_ict_questions_wrangled.csv")
pisa_agg_percent <- wrangled_data %>%
    group_by(q_name, q_label, gender, response) %>%
    summarise(count=n()) %>%
    mutate(pct=count/sum(count))
pisa_agg_percent[,6] <- lapply(pisa_agg_percent[,6], scales::percent)
pisa_agg_percent$response <- factor(pisa_agg_percent$response, 
                                    levels = c(1:24),
                                    labels = c("Yes, and I use it",
                                               "Yes, but I don't use it",
                                               "No",
                                               "6 years old or younger",
                                               "7-9 years old",
                                               "10-12 years old",
                                               "13 years old or older",
                                               "I have never used a digital device until today",
                                               "No time",
                                               "1-30 minutes per day",
                                               "31-60 minutes per day",
                                               "Between 1 hour and 2 hours per day",
                                               "Between 2 hours and 4 hours per day",
                                               "Between 4 hours and 6 hours per day",
                                               "More than 6 hours per day",
                                               "Never or hardly ever",
                                               "Once or twice a month",
                                               "Once or twice a week",
                                               "Almost every day",
                                               "Every day",
                                               "Strongly disagree",
                                               "Disagree",
                                               "Agree",
                                               "Strongly agree"
                                    ))

# InternetNZ / Map data -------------------------------



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
            # Third tab content
            tabItem(tabName = "education",
                    fluidRow(
                        column( width = 6,
                            box(
                                width = NULL,
                                height = '140px',
                                title = "PISA Questions",
                                selectInput("pisa_question",
                                            "Select Question",
                                            choices = pisa_questions[-1,]$q_label),
                            )    
                        ),
                        column( width = 6,
                                box(
                                    width = NULL,
                                    height = '140px',
                                radioButtons("chart_type",
                                             "Type of Chart",
                                             choices = c("Bar",
                                                         "Waffle"),
                                             selected = "Bar"),
                                )
                        ),
                    ),
                    fluidRow(
                        column(width = 12,
                               box(
                                   width = NULL,
                                   height = NULL,
                                   title = textOutput("q"),
                                   plotOutput("pisa_plot")
                               )    
                        )
                    )
                )
        )
    )
)

server <- function(input, output) {
    
    # Currently selected PISA question. 
    selected_question <- reactive({
        input$pisa_question
    })
    
    # Responses based on currently selected question. 
    question_responses <- reactive({
        filter(pisa_agg_percent, q_label == input$pisa_question)
    })
    
    output$q <- renderText(selected_question())
    
    output$pisa_plot <- renderPlot({
        switch(input$chart_type,
               'Bar' = question_responses()%>%
                   ggplot() +
                   aes(x = response, y = count, fill = response, label = paste0(count," (",pct,")")) +
                   geom_bar(stat = "identity", position = "dodge") +
                   geom_text(stat = "identity", vjust = -0.5) +
                   facet_wrap(~ gender, strip.position = "bottom") +
                   labs(x = NULL, y = "Count", fill = "Response") +
                   theme_classic() +
                   theme(axis.text.x = element_text(angle = 45, hjust = 1, 
                                                    size = 12, face = "bold"))+
                   theme(axis.title.y = element_text(face = "bold", size = 16)) +
                   scale_fill_viridis_d(),
               'Waffle' = question_responses()%>%
                   count(response, wt = count/10) %>%
                   ggplot(aes(fill = response, values = n)) +
                   geom_waffle(n_rows = 10, size = 0.33, colour = "white", flip = TRUE) +
                   labs(fill = "Response") +
                   facet_wrap(~ gender) + 
                   scale_fill_viridis_d() +
                   coord_equal() +
                   theme_void() +
                   theme_enhance_waffle()
        )
    })
}

shinyApp(ui, server)