# Install and load packages
install.packages('tidyverse')
library(tidyverse)

# Read csv file
wvs <- read_csv("wvs6.csv")

# Get dimensions of dataset
dim(wvs)

# Select specific columns in dataset
selected_data <- wvs[c(4, 307, 113, 117, 118, 119, 120, 121)]

# Replace column names of dataset.
# Basically, the column names are a vector, so we can replace
    # this with a vector of the same length.
colnames(selected_data) <- c("id", "class", "armed_forces", "police",
                             "courts", "government", "political_parties",
                             "parliament")
head(selected_data)

# Get a statistical summary of the dataset.
summary(selected_data)

# Turn class data into a factor.
# Because class is represented by numbers 1, 2, ... , 5, r thinks
  # it is numerical/ continuous data, when in fact it is catergorical.
# Turning it into a factor fixes this. 
selected_data$class <-  factor(selected_data$class, levels = c(1, 2, 3, 4, 5)
                               , labels = c("Upper class", "Upper middle class", "Lower middle class",
                                            "Working class", "Lower class"))

# First, create a vector called 'recode'.
# These are the column names essentially. 
to_recode <- c("class", "police", "courts", "government", "political_parties", "parliament", "armed_forces")

# Then, iterate through columns, replacing negative numbers with NAs
selected_data[,to_recode] <- lapply(selected_data[,to_recode], function(x){
  car::recode(x," -2 = NA; -1 = NA; 4 = 1; 3 = 2; 2 = 3; 1 = 4") 
})

# Gives us a visualisation which shows 'missingness' in the dataset. 
aggr_plot <- VIM::aggr(selected_data, col=c('navyblue','red'), numbers = TRUE, sortVars = TRUE,
                       labels = names(data), cex.axis = .7, gap = 3,
                       ylab = c("Histogram of missing data","Pattern"))
