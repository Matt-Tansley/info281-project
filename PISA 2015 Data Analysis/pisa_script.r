# Load libraries
library(tidyverse)

# Read data
pisa_data <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/New Zealand PISA.csv")
pisa_questions <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/questions_to_analyse.csv")

view(head(pisa_data))
view(head(pisa_questions))

# Select specific columns.
# Convert data to long format.
pisa_long <- gather(pisa_data, 
                    key = "q_name", 
                    value = "response"
                    )
view(head(pisa_long, 10))

# Select rows where question is in the specific pisa questions.
# Uses double brackets [[]] to get the 'q_name' column as a vector.
pisa_selected_questions <- filter(pisa_long, 
                        q_name %in% pisa_questions$q_name)
view(head(pisa_selected_questions))

joined_pisa_selected_questions <- left_join(pisa_selected_questions,
                                            pisa_questions, 
                                            by = 'q_name')
view(head(joined_pisa_selected_questions))


# Grouping ICT questions by same response sets --------
yes_no_q <- pisa_questions[2:21, ]
yes_no_a <- filter(joined_pisa_selected_questions,
                 q_name %in% yes_no_q$q_name)

age_brackets_q <- pisa_questions[22:24,]
age_brackets_a <- filter(joined_pisa_selected_questions,
                         q_name %in% age_brackets_q$q_name)

time_spent_q <- pisa_questions[25:27,]
time_spent_a <- filter(joined_pisa_selected_questions,
                       q_name %in% time_spent_q$q_name)

activity_frequency_q <- pisa_questions[28:60,]
activity_frequency_a <- filter(joined_pisa_selected_questions,
                               q_name %in% activity_frequency_q$q_name)

agree_disagree_q <- pisa_questions[61:80,]
agree_disagree_a <- filter(joined_pisa_selected_questions,
                           q_name %in% agree_disagree_q$q_name)

question_groups_to_csv <- function(response_df){
  write_csv(x = response_df, 
            path = paste0("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/selected_questions_grouped/",deparse(substitute(response_df)),".csv")
            ) 
}

question_groups_to_csv(yes_no_a)
question_groups_to_csv(age_brackets_a)
question_groups_to_csv(time_spent_a)
question_groups_to_csv(activity_frequency_a)
question_groups_to_csv(agree_disagree_a)


