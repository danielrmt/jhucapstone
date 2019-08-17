# 

dir.create('data', recursive = TRUE)

if (!file.exists('data/Coursera-SwiftKey.zip')) {
  download.file(
    'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip',
    'data/Coursera-SwiftKey.zip', mode='wb'
  )
  unzip('data/Coursera-SwiftKey.zip', exdir='data')
}



dir.create('data/training', recursive = TRUE)
dir.create('data/testing', recursive = TRUE)
set.seed(12345)
sample_size <- .10
for (fn in Sys.glob('data/final/en_US/*.txt')) {
  data <- readLines(fn)
  
  training_sample <- sample(data, length(data) * sample_size)
  writeLines(training_sample, file.path('data', 'training', basename(fn)))
  
  data <- data[rownames(data)!=rownames(training_sample)]
  testing_sample <- sample(data, length(data) * sample_size)
  writeLines(testing_sample, file.path('data', 'testing', basename(fn)))
  gc()
  rm(data, training_sample, testing_sample)
}
