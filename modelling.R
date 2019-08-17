library(quanteda)
library(readtext)
library(data.table)
library(tidyverse)

dir.create('app/model', recursive = TRUE)

params <- list(tolower = TRUE, 
               remove_stopwords = 'english',
               remove_punct = TRUE,
               stem = FALSE)

# Read files and make a corpus
train_corpus <- readtext("data/training/*.txt", encoding = 'UTF-8') %>%
  corpus()

# Extract top 3 words
train_words <- train_corpus %>%
  dfm(tolower = params$tolower, remove = stopwords(params$remove_stopwords),
      remove_punct = params$remove_punct, stem = params$stem) %>%
  topfeatures(3)
saveRDS(train_words, 'app/model/train_words.rds')
gc()

# Extract bigrams
train_bigrams <- train_corpus %>%
  dfm(tolower = params$tolower, remove = stopwords(params$remove_stopwords),
      remove_punct = params$remove_punct, stem = params$stem, ngrams = 2)
train_bigrams <- topfeatures(train_bigrams, length(train_bigrams))
saveRDS(train_bigrams, 'app/model/train_bigrams.rds')
gc()


# Extract trigrams
train_trigrams <- train_corpus %>%
  dfm(tolower = params$tolower, remove = stopwords(params$remove_stopwords),
      remove_punct = params$remove_punct, stem = params$stem, ngrams = 3)
train_trigrams <- topfeatures(train_trigrams, length(train_trigrams))
saveRDS(train_trigrams, 'app/model/train_trigrams.rds')
gc()

# Extract quadrigrams
train_quadrigrams <- train_corpus %>%
  dfm(tolower = params$tolower, remove = stopwords(params$remove_stopwords),
      remove_punct = params$remove_punct, stem = params$stem, ngrams = 4)
train_quadrigrams <- topfeatures(train_quadrigrams, length(train_quadrigrams))
saveRDS(train_quadrigrams, 'app/model/train_quadrigrams.rds')
gc()


# Prediction function
predict_word <- function(str) {
  words <- str %>%
    str_trim() %>%
    str_to_lower() %>%
    str_split(' ')
  words <- words[[1]]
  
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
  result
}
