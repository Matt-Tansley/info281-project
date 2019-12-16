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
gender_q <- pisa_questions[1,]
gender_a <- filter(joined_pisa_selected_questions,
                   q_name %in% gender_q$q_name)

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


# Renaming responses from numbers to interpretable words --------
gender_a$response <- factor(gender_a$response,
                            levels = c('1','2'),
                            labels = c("Female",
                                       "Male"))
yes_no_a$response <- factor(yes_no_a$response, 
                            levels = c('1','2','3'),
                            labels = c("Yes, and I use it",
                                       "Yes, but I don't use it",
                                       "No"))
age_brackets_a$response <- factor(age_brackets_a$response,
                                  levels = c('1','2','3','4','5'),
                                  labels = c("6 years old or younger",
                                             "7-9 years old",
                                             "10-12 years old",
                                             "13 years old or older",
                                             "I have never used a digital device until today"
                                  ))
time_spent_a$response <- factor(time_spent_a$response,
                                levels = c('1','2','3','4','5','6','7'),
                                labels = c("No time",
                                           "1-30 minutes per day",
                                           "31-60 minutes per day",
                                           "Between 1 hour and 2 hours per day",
                                           "Between 2 hours and 4 hours per day",
                                           "Between 4 hours and 6 hours per day",
                                           "More than 6 hours per day"
                                ))
activity_frequency_a$response <- factor(activity_frequency_a$response,
                                        levels = c('1','2','3','4','5'),
                                        labels = c("Never or hardly ever",
                                                   "Once or twice a month",
                                                   "Once or twice a week",
                                                   "Almost every day",
                                                   "Every day"
                                        ))
agree_disagree_a$response <- factor(agree_disagree_a$response,
                                    levels = c('1','2','3','4'),
                                    labels = c("Strongly disagree",
                                               "Disagree",
                                               "Agree",
                                               "Strongly agree"
                                    ))


question_groups_to_csv <- function(response_df){
  write_csv(x = response_df, 
            path = paste0("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/selected_questions_grouped/",deparse(substitute(response_df)),".csv")
            ) 
}

question_groups_to_csv(gender_a)
question_groups_to_csv(yes_no_a)
question_groups_to_csv(age_brackets_a)
question_groups_to_csv(time_spent_a)
question_groups_to_csv(activity_frequency_a)
question_groups_to_csv(agree_disagree_a)


pisa_ict_questions_wrangled <- rbind(gender_a, 
                                     yes_no_a,
                                     age_brackets_a,
                                     time_spent_a,
                                     activity_frequency_a,
                                     agree_disagree_a)
question_groups_to_csv(pisa_ict_questions_wrangled)

nas_removed_pisa_ict_questions_wrangled <- na.omit(pisa_ict_questions_wrangled)
question_groups_to_csv(nas_removed_pisa_ict_questions_wrangled)





# Visualising the data --------------------------------
# Help from: https://homepage.divms.uiowa.edu/~luke/classes/STAT4580/catone.html#pie-charts-and-doughnut-charts
# Count number of same rows.
pisa_agg <- count(nas_removed_pisa_ict_questions_wrangled, q_name, response, q_label)
head(agg)
question_groups_to_csv(pisa_agg)

selected_question <- filter(pisa_agg,
                            q_name == 'IC001Q01TA')
