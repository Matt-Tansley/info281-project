A <- function(x) x + 1
df <- data.frame(replicate(9,1:4))
df

data.frame(wifi[1:3], apply(df[4:9],2, A) )

colnames(df) <- c('A','B','C','D','E','F','G','H','I')

# own code.
# For some reason, need to use ifelse for it to work,
# Instead of normal if(){}else{}
B <- function(x) {
  ifelse(x == 1, x + 1, x) 
} 

# Use select to get specific columns in data frame.
# Can selecy by name or column number. 
applied_frame <- lapply(df %>% select('A','B','C'), B)
applied_frame

# Implementing code for project.
data_long <- gather(sample_markers, key = "connection", 
                    value = "availability", 
                    c('adsl','cable','fibre','vdsl','wireless'))
head(data_long)



