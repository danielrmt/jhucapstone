# 

dir.create('data', recursive = TRUE)

if (!file.exists('data/Coursera-SwiftKey.zip')) {
  download.file(
    'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip',
    'data/Coursera-SwiftKey.zip', mode='wb'
  )
  unzip('data/Coursera-SwiftKey.zip', exdir='data')
}
