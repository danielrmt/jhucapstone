
library(shiny)
library(stringr)
library(data.table)

ngrams <- list()
for (i in 2:4) {
  ngrams[[paste0('ngram', i)]] <- readRDS(paste0('model/', i, 'grams.rds'))
  setDT(ngrams[[paste0('ngram', i)]])
}


predict_word <- function(str) {
  clean_str <- str_to_lower(str_trim(str))
  words <- str_split(clean_str, ' ')[[1]]
  
  result <- character()
  for (i in 4:2) {
    if (length(words) >= (i-1) && length(result) == 0) {
      typed_feature <- paste(words[length(words)-(i-1):1+1], collapse = ' ')
      result <- ngrams[[paste0('ngram', i)]][feature == typed_feature,]$predict
    }
  }
  result
}


shinyServer(function(input, output) {


  output$prediction <- renderTable({
    if (substr(input$text, nchar(input$text), nchar(input$text)) == ' ') {
      predict_word(tolower(input$text))
    } else {
      'press space to get suggestions'
    }
  }, colnames = FALSE)

})
