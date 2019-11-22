# Have to filter out "Upper Class' since there is some data assigned to it
# which is '0'. Can perform summary statistics on this. 
filtered_data <- filter(data_long, class %in% c("Upper middle class", "Lower middle class",
                                            "Working class", "Lower class"))

# Using our data in long format, since this is what the funtion prefers
summary_plot <- Rmisc::summarySE(groupvars = c("entity", "class"),
                                 measurevar = "confidence",
                                 filtered_data,
                                 na.rm = T
)

# ggplot layers
# Layer 1: Data. We have prepared this above. 
# summary_plot is our data which we will make a plot out of.

# Layer 2: Aesthetics. Abbreviated to aes.
# Here we define our x and y axis, and fill. We fill by class,
# because we want a different colour for each class. 
# Catergorical data will have a different colour for each category.
# Continuous data (such as age) should have a shading effect. 

# Layer 3: Geometries. Abbreviated to geom.
# 'identity' just means take the data as it is. Works better when
# we have summaried the data as above.
# 'dodge' makes a different bar for each class. Without it, it is a
# stacked bar chart. 
# Lots of different geoms can be added together. 
# errorbar essentilly adds the variance/ standard error. Makes bar 
# charts infinitely more meaningful. 

# The first 3 layers are essential. 

# 

summary_plot %>%
  ggplot() + # data layer
  aes(x = entity, y = confidence, fill = class) + # aesthetics layer
  geom_bar(stat = "identity", position = "dodge") + 
  geom_errorbar(aes(ymin = confidence - ci, ymax = confidence + ci), position = 'dodge') +
  NULL # NULL 'layer' means there will always be a layer at the end, and 
       # there won't be an 'empty' +. 

# Layer 4: Facets. 
# Below example has a facet_wrap on class. Essentially creates a 
# histogram for each class (splits by class).

filtered_data %>%
  ggplot() +
  aes(x = confidence, fill = entity)  +
  geom_histogram(binwidth = 1) +
  facet_wrap(~ class) + 
  coord_cartesian(xlim = c(1,6))
  NULL
  
# Layer 5: Statistics.

# Layer 6: Coordinates.
# Determines how x and y axis are shown on the plot,
# and therefore the position of elements (e.g bars).
# Most commom use of this is the change the xlim and ylim on x
# and y axes. 
  
  
# Layer 7: Themes. 
# For example, theme_classic(), removes grey grid background.

  summary_plot %>%
    ggplot() + # data layer
    aes(x = entity, y = confidence, fill = class) + # aesthetics layer
    geom_bar(stat = "identity", position = "dodge") + 
    geom_errorbar(aes(ymin = confidence - ci, ymax = confidence + ci), position = 'dodge') +
    geom_hline(yintercept = 2, color='red', size = 2, linetype = 'dashed') +
    labs(x = NULL, y = "Confidence in Instituions", fill = NULL) + 
    theme_classic() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
    NULL  
  