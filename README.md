# John Hopkins/Coursera Data Science Capstone Project


### Introduction

This project is a word prediction app based on n-grams, built for the
Capstone Project for the Data Science Specialization from John Hopkins 
University at Coursera.

- The app is available at https://danielrmt.shinyapps.io/jhucapstone/

- A pitch is available at http://rpubs.com/danielrmt/jhucapstone/

- Source code available at https://github.com/danielrmt/jhucapstone/

The app is very simple. There is only one input, where you can type a text.
When "space" is pressed, the app will suggest words to complete the text, based 
on whatever was typed by the user. 

To run the source code yourself, you need R and the following packages:
data.table, quanteda, readtext, stringr, ggplot2, knitr, shiny



### Dataset and Prediction algorithm

The data used was gathered by SwiftKey, and comes from twitter, blogs and news.
I used the quanteda package to extract the bigrams, trigrams and quadrigrams 
frequencies. Those frequencies are stored in a RDS format, and loaded by the 
app for the predictions.


The suggestions use the following method:

- If input text has 3 or more words, suggest the most frequent quadrigrams
starting with the last 3 words typed

- If input text has 2 words or no quadrigram found, suggest the most frequent
trigrams starting with the last 2 words typed

- If input text has 1 word or no trigram found, suggest the most frequent 
bigrams starting with the last typed word



