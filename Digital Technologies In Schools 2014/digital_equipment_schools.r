# load libraries
library(tidyverse)

# read data into variable.
equipmentData <- read_csv('equipment_data.csv')

# select specific columns.
# Use a vector of column numbers to get specific columns.
# ID, Total School Roll, Total Computers, Decile
selectedData <- equipmentData[c(1, 4, 7, 243)]

# rename selectedData columns.
colnames(selectedData) <- c('respondent_id', 
                             'total_school_roll', 
                             'total_computers',
                             'decile')

# change decile to a factor, so it is categorical.
selectedData$decile <-  factor(selectedData$decile, levels =
                                 c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99)
                               , labels = c('One', 'Two', 
                                            'Three', 'Four',
                                            'Five', 'Six',
                                            'Seven', 'Eight',
                                            'Nine', 'Ten',
                                            'Missing'))

# Show a summary of selectedData to confirm cleaning. 
summary(selectedData)

# convert data to long format. 
data_long <- gather(selectedData[1:4], key = "measure", value = "count", -decile, -respondent_id)

filteredData <- filter(data_long, decile != 'Missing')

# summary of selectedData.
summaryPlot <- Rmisc::summarySE(groupvar = c("decile", "measure"),
                                measurevar = "count",
                                filteredData,
                                na.rm = T
)



# basic visualisation ---------------------------------

summaryPlot %>%
  ggplot() +
  aes(x = decile, y = count, fill = decile) +
  geom_bar(stat = 'identity', position = 'dodge') + 
  geom_errorbar(aes(ymin = count - ci, ymax = count + ci), position = 'dodge') +
  facet_wrap(~ measure) +
  scale_fill_viridis_d() # _d for discrete, _c for continuous
