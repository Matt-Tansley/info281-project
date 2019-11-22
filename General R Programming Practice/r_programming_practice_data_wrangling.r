head(selected_data)

# Convert data to a long format. 
# Needs a key and value (the names for which we make up).
# -id and -class omits these columns from the function. 
data_long <- gather(selected_data, key = "entity", value = "confidence", -id, -class)

head(data_long)

# Convert data to a wide format. 
data_wide <- spread(data_long, key = "entity", value = "confidence")

head(data_wide)


# Using time data. 
time_df_long <- tibble(id = 1:10,
                       measure1_1 = rnorm(1:10),
                       measure1_2 = rnorm(1:10),
                       measure2_1 = rnorm(1:10),
                       measure2_2 = rnorm(1:10))

time_gathered <- gather(time_df_long, key = measure_time, value = value, -id)

head(time_gathered)

# Separating data.
# In this case splits at the underscore e.g measure1_1 is split
# into measure1 and 1. 
time_split <- separate(time_gathered, col = "measure_time", into = c("measure", "time"))


# Selecting data from a data frame using conditionals. 
# 'na.rm = T' means the function will skip over/ ignore NAs.
filter(data_wide, class == "Working class" & government > mean(government, na.rm = T))

# %in% works very much like IN for SQL
filter(data_wide, class %in% c("Working class", "Upper middle class"))
