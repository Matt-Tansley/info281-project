# Load libraries
library(tidyverse)

# Read data
piaac_data <- read_csv("C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/PIAAC Data Analysis/data/prgnzlp1.csv")

# Selecting specific columns
# 5 = Gender
# 408 = Age (in 5 year bins)
# 10 = Qualification Level
# 108 = Job Situation
# 274 = Have you ever used a computer?
# 275 = Do you use a computer in everyday life outside work?
# 276 = How often do you use email? 
# 277 = Use computer for general knowledge?
# 278 = Use computer to conduct transactions?
# 281 = Use a programming language?
# 282 = Real time discussions on the Internet?
# 289 = Charity/ volunteering in last 12 months
# 290 = Opinion on impact on Government
# 291 = 'You can only trust a few people'
# 292 = 'People will try to take advantage of you'
# 293 = Self-reported health level
selected_columns <- piaac_data[c(5, 408, 10, 108, 274, 275, 
                                 276, 277, 278, 281, 282, 289, 
                                 290, 291, 292, 293)]

colnames(selected_columns) <- c('gender',
                                'age',
                                'qual_level',
                                'job_situation',
                                'used_computer',
                                'uses_a_computer_in_everyday_life_outside_work',
                                'email_use',
                                'using_internet_for_knowledge',
                                'using_internet_for_transactions',
                                'programming_language_use',
                                'participate_in_online_discussions',
                                'contribution_to_charity_or_volunteering',
                                'perception_of_self_impact_on_government',
                                'trust_in_others',
                                'people_are_likely_to_take_advantage_of_you',
                                'self_reported_health_level')

selected_columns$gender <- factor(selected_columns$gender, 
                                  levels = c(1, 2),
                                  labels = c('Male', 'Female'))

selected_columns$age <- factor(selected_columns$age, 
                                  levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 93, 94, 99),
                                  labels = c('16-19', '20-24',
                                             '25-29', '30-34',
                                             '35-39', '40-44',
                                             '45-49', '50-54',
                                             '55-59', '60-65',
                                             '<16', '>65',
                                             'Not stated or inferred'))

selected_columns$qual_level <- factor(selected_columns$qual_level,
                                      levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
                                                 11, 12, 13, 14, 15, 16, 96, 97, 98, 99),
                                      labels = c('No formal qualification or below ISCED 1',
                                                 'ISCED 1',
                                                 'ISCED 2',
                                                 'ISCED 3C shorter than 2 years',
                                                 'ISCED 3C 2 years or more',
                                                 'ISCED 3A-B',
                                                 'ISCED 3 (without distinction A-B-C, 2y+)',
                                                 'ISCED 4C',
                                                 'ISCED 4A-B',
                                                 'ISCED 4 (without distinction A-B-C)',
                                                 'ISCED 5B',
                                                 'ISCED 5A, bachelor degree',
                                                 'ISCED 5A, master degree',
                                                 'ISCED 6',
                                                 'Foreign qualification',
                                                 'ISCED 5A bachelor degree, 5A master degree, and 6 (without distinction)',
                                                 'Valid skip',
                                                 "Don't know",
                                                 'Refused',
                                                 'Not stated or inferred'
))


# Data Wrangling --------------------------------------

selected_columns$used_computer <- factor(selected_columns$used_computer,
                                         levels = c(1,2,6,7,8,9),
                                         labels = c('Yes','No','Valid skip',
                                                    "Don't know",'Refused',
                                                    'Not stated or inferred')
)

selected_columns$uses_a_computer_in_everyday_life_outside_work <- factor(selected_columns$uses_a_computer_in_everyday_life_outside_work,
                                         levels = c(1,2,6,7,8,9),
                                         labels = c('Yes','No','Valid skip',
                                                    "Don't know",'Refused',
                                                    'Not stated or inferred')
)

selected_columns$job_situation <- factor(selected_columns$job_situation,
                                         levels = c(1,2,3,4,5,6,7,8,9,10,96,97,98,99),
                                         labels = c("Full-time employed (self-employed, employee)",
                                                    "Part-time employed (self-employed, employee)",
                                                    "Unemployed",
                                                    "Pupil, student",
                                                    "Apprentice, internship",
                                                    "In retirement or early retirement",
                                                    "Permanently disabled",
                                                    "In compulsory military or community service",
                                                    "Fulfilling domestic tasks or looking after children/family",
                                                    "Other",
                                                    "Valid skip",
                                                    "Don't know",
                                                    "Refused",
                                                    "Not stated or inferred"
))

selected_columns$email_use <- factor(selected_columns$email_use,
                                     levels = c(1,2,3,4,5,6,7,8,9),
                                     labels = c("Never",
                                                "Less than once a month",
                                                "Less than once a week but at least once a month",
                                                "At least once a week but not every day",
                                                "Every day",
                                                "Valid skip",
                                                "Don't know",
                                                "Refused",
                                                "Not stated or inferred"
))

selected_columns$using_internet_for_knowledge <- factor(selected_columns$using_internet_for_knowledge,
                                     levels = c(1,2,3,4,5,6,7,8,9),
                                     labels = c("Never",
                                                "Less than once a month",
                                                "Less than once a week but at least once a month",
                                                "At least once a week but not every day",
                                                "Every day",
                                                "Valid skip",
                                                "Don't know",
                                                "Refused",
                                                "Not stated or inferred"
                                     ))

selected_columns$using_internet_for_transactions <- factor(selected_columns$using_internet_for_transactions,
                                     levels = c(1,2,3,4,5,6,7,8,9),
                                     labels = c("Never",
                                                "Less than once a month",
                                                "Less than once a week but at least once a month",
                                                "At least once a week but not every day",
                                                "Every day",
                                                "Valid skip",
                                                "Don't know",
                                                "Refused",
                                                "Not stated or inferred"
                                     ))

selected_columns$programming_language_use <- factor(selected_columns$programming_language_use,
                                     levels = c(1,2,3,4,5,6,7,8,9),
                                     labels = c("Never",
                                                "Less than once a month",
                                                "Less than once a week but at least once a month",
                                                "At least once a week but not every day",
                                                "Every day",
                                                "Valid skip",
                                                "Don't know",
                                                "Refused",
                                                "Not stated or inferred"
                                     ))

selected_columns$participate_in_online_discussions <- factor(selected_columns$participate_in_online_discussions,
                                     levels = c(1,2,3,4,5,6,7,8,9),
                                     labels = c("Never",
                                                "Less than once a month",
                                                "Less than once a week but at least once a month",
                                                "At least once a week but not every day",
                                                "Every day",
                                                "Valid skip",
                                                "Don't know",
                                                "Refused",
                                                "Not stated or inferred"
                                     ))

selected_columns$contribution_to_charity_or_volunteering <- factor(selected_columns$contribution_to_charity_or_volunteering,
                                     levels = c(1,2,3,4,5,6,7,8,9),
                                     labels = c("Never",
                                                "Less than once a month",
                                                "Less than once a week but at least once a month",
                                                "At least once a week but not every day",
                                                "Every day",
                                                "Valid skip",
                                                "Don't know",
                                                "Refused",
                                                "Not stated or inferred"
                                     ))

selected_columns$perception_of_self_impact_on_government <- factor(selected_columns$perception_of_self_impact_on_government,
                                     levels = c(1,2,3,4,5,6,7,8,9),
                                     labels = c("Strongly agree",
                                                "Agree",
                                                "Neither agree nor disagree",
                                                "Disagree",
                                                "Strongly disagree",
                                                "Valid skip",
                                                "Don't know",
                                                "Refused",
                                                "Not stated or inferred"
                                     ))

selected_columns$trust_in_others <- factor(selected_columns$trust_in_others,
                                                                   levels = c(1,2,3,4,5,6,7,8,9),
                                                                   labels = c("Strongly agree",
                                                                              "Agree",
                                                                              "Neither agree nor disagree",
                                                                              "Disagree",
                                                                              "Strongly disagree",
                                                                              "Valid skip",
                                                                              "Don't know",
                                                                              "Refused",
                                                                              "Not stated or inferred"
                                                                   ))

selected_columns$people_are_likely_to_take_advantage_of_you <- factor(selected_columns$people_are_likely_to_take_advantage_of_you,
                                                                   levels = c(1,2,3,4,5,6,7,8,9),
                                                                   labels = c("Strongly agree",
                                                                              "Agree",
                                                                              "Neither agree nor disagree",
                                                                              "Disagree",
                                                                              "Strongly disagree",
                                                                              "Valid skip",
                                                                              "Don't know",
                                                                              "Refused",
                                                                              "Not stated or inferred"
                                                                   ))

selected_columns$self_reported_health_level <- factor(selected_columns$self_reported_health_level,
                                                                   levels = c(1,2,3,4,5,6,7,8,9),
                                                                   labels = c("Excellent",
                                                                              "Very good",
                                                                              "Good",
                                                                              "Fair",
                                                                              "Poor",
                                                                              "Valid skip",
                                                                              "Don't know",
                                                                              "Refused",
                                                                              "Not stated or inferred"
                                                                   ))

view(head(selected_columns))

piaac_cleaned <- filter(selected_columns, 
                       gender %in% c('Male','Female'),
                       used_computer %in% c('Yes','No')
)

write_csv(piaac_cleaned, "C:/Users/30mat/Documents/VUW/2019/Tri 3/INFO 281 - 391/info281-project/Main_Project/data/wrangled_piaac_data.csv")


# Basic Demographics ----------------------------------
demo_data <- selected_columns[c(1:11)]
demo_cleaned <- filter(demo_data, 
                       gender %in% c('Male','Female'),
                       used_computer %in% c('Yes','No')
                       )

demo_cleaned %>%
  ggplot() +
  aes(x = gender, fill = gender) +
  geom_histogram(stat = 'count') +
  stat_count(binwidth = 1, geom = "text", color = "white",
           size = 3.5, aes(label=..count..), 
           position = position_stack(vjust = 0.5))+
  facet_wrap(~ used_computer)


