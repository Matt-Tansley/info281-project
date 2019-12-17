## app.R ##
library(shiny)
library(shinydashboard)
library(shinyjs)
library(sf)
library(leaflet)
library(tidyverse)
library(waffle)


# Load data files -------------------------------------
# PISA Data -------------------------------------------
pisa_questions <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/questions_to_analyse.csv")
wrangled_data <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/selected_questions_grouped/nas_removed_pisa_ict_questions_wrangled.csv")
# Need to do some wrangling at this stage since writing then 
# reading from csv would cause errors (e.g loss of the factor).
pisa_agg_percent <- wrangled_data %>%
    group_by(q_name, q_label, gender, response) %>%
    summarise(count=n()) %>%
    mutate(prop=count/sum(count))
decimal_to_percent <- lapply(pisa_agg_percent[,6], scales::percent)
names(decimal_to_percent) <- "pct"
pisa_agg_percent[,6] <- lapply(pisa_agg_percent[,6], function(x) round(x,2))
pisa_agg_percent <- cbind(pisa_agg_percent, decimal_to_percent)
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
## Internet Markers.
## Two types of dataframes:
## Just a standard data.frame with NA values removed, used to,
## get a count of markers inside a polygon.
## And sf_frame, which is used to plot markers on the map.
#all_connections <-  read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/all_connections.csv") %>% 
#    na.omit()
#sf_all_connections <- st_as_sf(all_connections, 
#                               coords = c("longitude", "latitude"), 
#                               crs = 4326)

#adsl <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/adsl.csv") %>% 
#    na.omit()
#sf_adsl <- st_as_sf(adsl,
#                    coords = c("longitude", "latitude"), 
#                    crs = 4326)

#cable <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/cable.csv") %>% 
#    na.omit()
#sf_cable <- st_as_sf(cable,
#                     coords = c("longitude", "latitude"), 
#                     crs = 4326)

#fibre <-read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/fibre.csv") %>% 
#    na.omit()
#sf_fibre <-  st_as_sf(fibre,
#                      coords = c("longitude", "latitude"), 
#                      crs = 4326) 

#vdsl <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/vdsl.csv") %>% 
#    na.omit()
#sf_vdsl <- st_as_sf(vdsl,
#                    coords = c("longitude", "latitude"), 
#                    crs = 4326)

#wireless <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/wireless.csv") %>% 
#    na.omit()
#sf_wireless <- st_as_sf(wireless,
#                        coords = c("longitude", "latitude"), 
#                        crs = 4326)

## Shapefile Boundaries
## Two files:
## sf_dataframe for rendering the polygons on a map.
## SpatialPolygonsDataFrame for checking if a marker is 
## inside a polygon. 
#nz_regions <-
#    st_read(dsn = "data/statsnzregional-council-2018-generalised-SHP (1)/regional-council-2018-generalised.shp")%>% 
#    st_transform(crs="+init=epsg:4326") %>% 
#    rmapshaper::ms_simplify(.)
#names(st_geometry(nz_regions)) = NULL 

#nz_urban_rural <- 
#    st_read(dsn = "data/statsnzurban-rural-2018-generalised-SHP/urban-rural-2018-generalised.shp")%>% 
#    st_transform(crs="+init=epsg:4326") %>% 
#    rmapshaper::ms_simplify(.)
#names(st_geometry(nz_urban_rural)) = NULL




# PIAAC Data ------------------------------------------
wrangled_piaac_data <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/Main_Project/data/wrangled_piaac_data.csv") 

# UI Code ---------------------------------------------
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
                        h1("Welcome"),
                        h3("Introduction"),
                        h3("Description/ Purpose"),
                        h3("Data Sources"),
                        h3("Smaller data set visualisations here")
                    )
            ),
            # Map tab
            tabItem(tabName = "map",
                    fluidRow(
                        h1("Internet Connections NZ Map"),
                        h3("Lorem ipsum")
                    ),
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
                            )
                        ),   
                        
                        column(
                            width = 8,
                            box(
                                width = NULL,
                                title = 'Map',
                                height = NULL,
                                leafgl::leafglOutput("internet_map")    
                            )    
                        )
                    ),
                    fluidRow(
                        column(width = 12,
                            box(width = NULL,
                                collapsible = TRUE,
                                collapsed = TRUE,
                                title = "Number of Data Points in Each Area",
                                tableOutput("data_point_counts")
                            )
                        )
                    )
            ),
            
            # PIAAC Tab
            tabItem(tabName = "piaac",
                    fluidRow(
                        h1("PIAAC Data Visualisation"),
                        h3("Lorem ipsum")
                    ),
                    fluidRow(
                        column( width = 6,
                                box(title = "Choose Demographic or Wellbeing Indicators",
                                    width = NULL,
                                    selectInput("demo_well",
                                                "Demographic/ Wellbeing Indicators",
                                                choices = c("Demographic",
                                                            "Wellbeing")),
                                    
                                    conditionalPanel(condition = "input.demo_well == 'Demographic'",
                                                     radioButtons("demographic",
                                                                  label = "Select Demographic",
                                                                  choices = list("Gender",
                                                                                 "Age",
                                                                                 "Job Situation",
                                                                                 "Qualification"),
                                                                  selected = "Gender"),
                                    ),
                                    conditionalPanel(condition = "input.demo_well == 'Wellbeing'",
                                                     radioButtons("wellbeing",
                                                                  label = "Select Wellbeing",
                                                                  choices = list("Contribution to Charity/ Volunteering",
                                                                                 '"I have no say about what the government does"',
                                                                                 '"There are only a few people you can trust completely"',
                                                                                 '"Other people will take advantage of you"',
                                                                                 "Self-Reported Health Level"),
                                                                  selected = "Contribution to Charity/ Volunteering"),
                                    )
                                )            
                        ),
                        column( width = 6,
                                box( width = NULL,
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
                                )        
                        ),
                    ),
                    fluidRow(
                        column(width = 12,
                               box( width = NULL,
                                    height = NULL,
                                   plotOutput("computer_users"),
                               )           
                        )
                    )
            ),
            # PISA tab content
            tabItem(tabName = "education",
                    fluidRow(
                        h1("PISA Data Visualisation"),
                        h3("Lorem ipsum")
                    ),
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


# Server Code -----------------------------------------


server <- function(input, output) {
    

# Map server code -------------------------------------
    # Test function/ tells user which shapefile they have 
    # selected. 
    output$selected_var <- renderText({
        paste("You have selected:", input$shapefile)
    })  
    
    # Updates output for count of data points in each 
    # polygon.
    data_point_region_connection <- reactive({
        switch(input$connection,
               'All Connections' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/all_connections.csv"),
               'ADSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/adsl.csv"),
               'Cable' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/cable.csv"),
               'Fibre' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/fibre.csv"),
               'VDSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/vdsl.csv"),
               'Wireless' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_regions/wireless.csv")
        )  
    })
    
    data_point_area_connection <- reactive({
        switch(input$connection,
               'All Connections' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/all_connections.csv"),
               'ADSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/adsl.csv"),
               'Cable' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/cable.csv"),
               'Fibre' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/fibre.csv"),
               'VDSL' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/vdsl.csv"),
               'Wireless' = read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/InternetNZ Data/connections_data/count_nz_urban_rural/wireless.csv")
        )  
    })
    
    output$data_point_counts <- renderTable({
        if(input$shapefile == "Regions"){
            data_point_region_connection()      
        }else if(input$shapefile == "Urban/Rural"){
            data_point_area_connection()
        }    
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
               'All Connections' = sf_all_connections,
               'ADSL' = sf_adsl,
               'Cable' = sf_cable,
               'Fibre' = sf_fibre,
               'VDSL' = sf_vdsl,
               'Wireless' = sf_wireless
        )
    })
    
    m_cols <- reactive({
        switch(input$connection,
               'All Connections' = cbind(0, 0.2, 1),
               'ADSL' = cbind(0, 0.2, 1),
               'Cable' = cbind(0, 0.2, 1),
               'Fibre' = cbind(0, 0.2, 1),
               'VDSL' = cbind(0, 0.2, 1),
               'Wireless' = cbind(0, 0.2, 1)
        )
    })
    
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
            leafgl::addGlPoints(data = m_connection(), 
                        group = "coords",
                        color = m_cols()
            ) 
    })
    

# PISA server code ------------------------------------

    
    
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
                   count(response, wt = prop*100) %>%
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

# PIAAC Server Code -----------------------------------
    demographics <- reactive({
        switch(input$demographic,
               "Gender" = wrangled_piaac_data$gender,
               "Age" = wrangled_piaac_data$age,
               "Job Situation" = wrangled_piaac_data$job_situation,
               "Qualification" = wrangled_piaac_data$qual_level
        )
    })
    
    wellbeing_indics <- reactive({
        switch(input$wellbeing,
               "Contribution to Charity/ Volunteering" = wrangled_piaac_data$contribution_to_charity_or_volunteering,
               '"I have no say about what the government does"' = wrangled_piaac_data$perception_of_self_impact_on_government,
               '"There are only a few people you can trust completely"' = wrangled_piaac_data$trust_in_others,
               '"Other people will take advantage of you"' = wrangled_piaac_data$people_are_likely_to_take_advantage_of_you,
               "Self-Reported Health Level" = wrangled_piaac_data$self_reported_health_level
        )
    })
    
    computer_use <- reactive({
        switch(input$comp_use,
               '1' = wrangled_piaac_data$used_computer,
               '2' = wrangled_piaac_data$uses_a_computer_in_everyday_life_outside_work,
               '3' = wrangled_piaac_data$email_use,
               '4' = wrangled_piaac_data$using_internet_for_knowledge,
               '5' = wrangled_piaac_data$using_internet_for_transactions,
               '6' = wrangled_piaac_data$programming_language_use,
               '7' = wrangled_piaac_data$participate_in_online_discussions
        )    
    })
    
    output$computer_users <- renderPlot({
        switch(input$demo_well,
               "Demographic"= wrangled_piaac_data %>%
                   ggplot() +
                   aes(x = demographics(), fill = demographics()) +
                   geom_histogram(stat = 'count') +
                   stat_count(binwidth = 1, geom = "text", color = "black",
                              size = 3.5, aes(label=..count..), 
                              position = position_stack(vjust = 0.5)
                   )+
                   facet_wrap(~ computer_use(), strip.position = "bottom") +
                   labs(x = NULL, y = "Count", fill = "Response") +
                   theme_classic() +
                   theme(axis.text.x = element_text(angle = 90, hjust = 1, 
                                                    size = 10, face = "bold")) +
                   theme(axis.title.y = element_text(face = "bold", size = 16)) +
                   scale_fill_viridis_d(),
               
               "Wellbeing" = wrangled_piaac_data %>%
                   ggplot() +
                   aes(x = wellbeing_indics(), fill = wellbeing_indics()) +
                   geom_histogram(stat = 'count') +
                   stat_count(binwidth = 1, geom = "text", color = "black",
                              size = 3.5, aes(label=..count..), 
                              position = position_stack(vjust = 0.5)
                   ) +
                   facet_wrap(~ computer_use() , strip.position = "bottom") +
                   labs(x = NULL, y = "Count", fill = "Response") +
                   theme_classic() +
                   theme(axis.text.x = element_text(angle = 90, hjust = 1, 
                                                    size = 10, face = "bold")) +
                   theme(axis.title.y = element_text(face = "bold", size = 16)) +
                   scale_fill_viridis_d()
        )
    })

}

shinyApp(ui, server)