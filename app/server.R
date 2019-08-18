
library(shiny)
library(tidyverse)

train_words <- readRDS('model/train_words.rds')
train_bigrams <- readRDS('model/train_bigrams.rds')
train_trigrams <- readRDS('model/train_trigrams.rds')
train_quadrigrams <- readRDS('model/train_quadrigrams.rds')



predict_word <- function(str) {
  words <- str %>%
    str_trim() %>%
    str_to_lower() %>%
    str_split(' ')
  words <- words[[1]]
  
  result <- character()
  if (length(words) >= 3) {
    query_pattern <- paste0('^',
                words[length(words)-2],
                '_',
                words[length(words)-1],
                '_',
                words[length(words)],
                '_')
    result <- head(train_quadrigrams[grep(query_pattern, names(train_quadrigrams))])
  }
  if (length(words) >= 2 && length(result) == 0) {
    query_pattern <- paste0('^',
                words[length(words)-1],
                '_',
                words[length(words)],
                '_')
    result <- head(train_trigrams[grep(query_pattern, names(train_trigrams))])
  }
  if (length(words) >= 1 && length(result) == 0) {
    query_pattern <- paste0('^',
                words[length(words)],
                '_')
    result <- head(train_bigrams[grep(query_pattern, names(train_bigrams))])
  } 
  if (length(result) == 0) {
    result <- train_words
  }
  if (length(result) > 0) {
    names(result) <- str_extract(names(result), '_[^_]+$')
  }
  result
}


shinyServer(function(input, output) {


  output$prediction <- renderTable({
    x <- names(predict_word(tolower(input$text)))
    x <- substr(x, 2, nchar(x))
    data.frame(Suggestions = x)
  }, colnames = TRUE)

})
