# Load libraries
library(tidyverse)
library(extrafont)
library(scales)

# Read data
pisa_data <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/New Zealand PISA.csv")
pisa_questions <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/questions_to_analyse.csv")

view(head(pisa_data))
view(head(pisa_questions))

# Select specific columns.
# Convert data to long format.
pisa_long <- gather(pisa_data, 
                    key = "q_name", 
                    value = "response",
                    -ST004D01T)
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
colnames(joined_pisa_selected_questions)[1] <- "gender"
joined_pisa_selected_questions$gender[joined_pisa_selected_questions$gender == 1] <- "Female"
joined_pisa_selected_questions$gender[joined_pisa_selected_questions$gender == 2] <- "Male"

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
yes_no_a$response <- factor(yes_no_a$response, 
                            levels = c('1','2','3'),
                            labels = c(1,
                                       2,
                                       3))
age_brackets_a$response <- factor(age_brackets_a$response,
                                  levels = c('1','2','3','4','5'),
                                  labels = c(4,
                                             5,
                                             6,
                                             7,
                                             8
                                  ))
time_spent_a$response <- factor(time_spent_a$response,
                                levels = c('1','2','3','4','5','6','7'),
                                labels = c(9,
                                           10,
                                           11,
                                           12,
                                           13,
                                           14,
                                           15
                                ))
activity_frequency_a$response <- factor(activity_frequency_a$response,
                                        levels = c('1','2','3','4','5'),
                                        labels = c(16,
                                                   17,
                                                   18,
                                                   19,
                                                   20
                                        ))
agree_disagree_a$response <- factor(agree_disagree_a$response,
                                    levels = c('1','2','3','4'),
                                    labels = c(21,
                                               22,
                                               23,
                                               24
                                    ))


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


pisa_ict_questions_wrangled <- rbind(yes_no_a,
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
pisa_agg <- count(nas_removed_pisa_ict_questions_wrangled, q_name, q_label, gender, response)
head(pisa_agg)
question_groups_to_csv(pisa_agg)



# Solving the problem with writing and reading --------
wrangled_data <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/selected_questions_grouped/nas_removed_pisa_ict_questions_wrangled.csv")

# Count number of same rows AND give percentage of each response
pisa_agg_percent <- wrangled_data %>%
  group_by(q_name, q_label, gender, response) %>%
  summarise(count=n()) %>%
  mutate(pct=count/sum(count))
# Convert decimals to percentage
pisa_agg_percent[,6] <- lapply(pisa_agg_percent[,6], scales::percent)
# Make response a factor. 
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

# Write to csv. 
write_csv(pisa_agg_percent, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PISA 2015 Data Analysis/data/pisa_agg_percent.csv")

selected_question <- filter(pisa_agg_percent,
                            q_name == 'IC001Q01TA')

# Bar Chart
selected_question %>%
  ggplot() +
  aes(x = response, y = count, fill = response, label = paste0(count," (",pct,")")) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(stat = "identity", vjust = -1) +
  facet_wrap(~ gender) +
  labs(x = NULL, y = "Count", fill = "Response") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, 
                                   size = 12, face = "bold"))+
  theme(axis.title.y = element_text(face = "bold", size = 16)) +
  scale_fill_viridis_d()

# Waffle Chart
install.packages("waffle", repos = "https://cinc.rud.is")
install.packages('hrbrthemes')
library(waffle)
library(hrbrthemes)
import_roboto_condensed()

parts <- c(80, 30, 20, 10)
waffle(parts, rows = 8)



data.frame(
  parts = factor(rep(month.abb[1:3], 3), levels=month.abb[1:3]),
  vals = c(10, 20, 30, 6, 14, 40, 30, 20, 10),
  col = rep(c("blue", "black", "red"), 3),
  fct = c(rep("Thing 1", 3),
          rep("Thing 2", 3),
          rep("Thing 3", 3))
) -> xdf

xdf %>%
  count(parts, wt = vals) %>%
  ggplot(aes(fill = parts, values = n)) +
  geom_waffle(n_rows = 20, size = 0.33, colour = "white", flip = TRUE) +
  scale_fill_manual(
    name = NULL,
    values = c("#a40000", "#c68958", "#ae6056"),
    labels = c("Fruit", "Sammich", "Pizza")
  ) +
  coord_equal() +
  theme_classic() +
  theme_enhance_waffle()

selected_question <- filter(selected_question, gender == "Male")

selected_question %>%
  count(response, wt = count/10) %>%
  ggplot(aes(fill = response, values = n)) +
  geom_waffle(n_rows = 10, size = 0.33, colour = "white", flip = TRUE) +
  labs(fill = "Response") +
  facet_wrap(~ gender) + 
  scale_fill_viridis_d() +
  coord_equal() +
  theme_void() +
  theme_enhance_waffle()

