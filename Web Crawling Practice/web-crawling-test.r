# General-purpose data wrangling
library(tidyverse)  

# Parsing of HTML/XML files  
library(rvest)    

# String manipulation
library(stringr)   

# Verbose regular expressions
library(rebus)     

# Eases DateTime manipulation
library(lubridate)

# 'Index' url page to get articles from
url <- html('https://www.nngroup.com/articles/?page=1')


# function to get titles of articles
get_titles <- function(html){
  html %>% 
    # The relevant tag
    html_nodes('#recentTab h3') %>%      
    html_text() %>% 
    # Trim additional white space
    str_trim() %>%                       
    # Convert the list into a vector
    unlist()                             
}


# Algorithm: Read through articles page and store titles in a vector.
    #Read initial URL.
    url <- html('https://www.nngroup.com/articles/?page=1')
    
    # Read list of page numbers. 
    page_nums <- url %>%
      html_nodes(".article-pager a") %>%
      html_text(trim = TRUE)
    
    # Get last element in vector. 
    last_element <- tail(page_nums, n=1)
    
    # Initialise vector
    article_titles <- get_titles(url)
    
    while(last_element == "» Next"){
      
      # Get current page.
      current_page <- url %>%
        html_node('.currentpage') %>%
        html_text(trim = TRUE) %>%
        as.numeric()
      
      # Get next page.
      next_page <- current_page + 1
      
      # Update url.
      url <- html(paste0('https://www.nngroup.com/articles/?page=', next_page))
      
      # Read article titles, using bespoke function. 
      article_titles <- append(article_titles, get_titles(url))
      
      # Read list of page numbers. 
      page_nums <- url %>%
        html_nodes(".article-pager a") %>%
        html_text(trim = TRUE)
      
      # Get last element in vector. 
      last_element <- tail(page_nums, n=1)
    }
