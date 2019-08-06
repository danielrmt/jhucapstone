
# 1. The en_US.blogs.txt file is how many megabytes?
file.size('data/final/en_US/en_US.blogs.txt')


# 2. The en_US.twitter.txt has how many lines of text?
length(readLines('data/final/en_US/en_US.twitter.txt'))

# 3. What is the length of the longest line seen in any of the three en_US data
# sets?
for (fn in Sys.glob('data/final/en_US/*.txt')) {
  print(fn)
  print(max(nchar(readLines(fn)), na.rm = TRUE))
}

# 4. In the en_US twitter data set, if you divide the number of lines where the
# word "love" (all lowercase) occurs by the number of lines the word "hate" (all
# lowercase) occurs, about what do you get?
twitter <- readLines('data/final/en_US/en_US.twitter.txt')
love <- grepl('love', twitter)
hate <- grepl('hate', twitter)
sum(love) / sum(hate)

# 5. The one tweet in the en_US twitter data set that matches the word
# "biostats" says what?
twitter[grep('biostats', twitter)]


# 6. How many tweets have the exact characters "A computer once beat me at
# chess, but it was no match for me at kickboxing". (I.e. the line matches those
# characters exactly.)
sum(grepl('computer once beat me at chess, but it was no match for me at kickboxing',
          twitter))
