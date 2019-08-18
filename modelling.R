library(quanteda)
library(readtext)
library(data.table)
library(stringr)

# Create model directory
dir.create('app/model', recursive = TRUE)


# Read files and make a corpus
train_corpus <- corpus(readtext("data/training/*.txt", encoding = 'UTF-8'))


# Extract ngrams
test_words <- c('i', 'want', 'to')
for (i in 2:4) {
  # Create ngram DFM
  train_ngrams <-
    dfm(train_corpus,
        tolower = TRUE, 
        remove = stopwords('english'),
        remove_twitter = TRUE, 
        remove_punct = TRUE, stem = FALSE, ngrams = i)
  # Extract ngrams frequencies
  train_ngrams <- topfeatures(train_ngrams, length(train_ngrams))
  # Convert to data.table
  train_ngrams <- data.table(ngram = names(train_ngrams),
                             freq = train_ngrams)
  # Extract (n-1)gram as a feature
  train_ngrams[, feature := str_trim(gsub('_', ' ', str_extract(ngram, '^.+_')))]
  # Extract last word as a prediction
  train_ngrams[, predict := gsub('_', '', str_extract(ngram, '_[^_]+$'))]
  # Remove ngram column
  train_ngrams[, ngram := NULL]
  # Set feature and prediciton as keys
  setkey(train_ngrams, feature, predict)
  # Sort by frequency
  setorder(train_ngrams, feature, -freq)
  # Select only top 5 predictions by features
  train_ngrams <- train_ngrams[, head(.SD, 5), by=feature]
  # Test a prediction
  print(train_ngrams[feature == paste(test_words[1:(i-1)], collapse = ' '),])
  # Save file
  saveRDS(train_ngrams, paste0('app/model/', i, 'grams.rds'))
  # Garbage collection
  gc()
}

