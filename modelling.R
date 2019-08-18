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

# Extract ngrams
for (i in 2:4) {
  train_ngrams <- train_corpus %>%
    dfm(tolower = TRUE, remove = stopwords('english'),
        remove_twitter = TRUE, 
        remove_punct = TRUE, stem = FALSE, ngrams = i)
  train_ngrams <- topfeatures(train_ngrams, length(train_ngrams))
  train_ngrams <- data.table(ngram = names(train_ngrams),
                             freq = train_ngrams)
  train_ngrams[, feature := str_trim(gsub('_', ' ', str_extract(ngram, '^.+_')))]
  train_ngrams[, predict := gsub('_', '', str_extract(ngram, '_[^_]+$'))]
  train_ngrams[, ngram := NULL]
  setkey(train_ngrams, feature, predict)
  setorder(train_ngrams, feature, -freq)
  train_ngrams <- train_ngrams[, head(.SD, 5), by=feature]
  saveRDS(train_ngrams, paste0('app/model/', i, 'grams.rds'))
  gc()
}

