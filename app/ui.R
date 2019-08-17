
library(shiny)

shinyUI(fluidPage(

  titlePanel("What are you thinking?"),

  
  textInput('text', 'Type something below'),
  actionButton('predict', 'Predict'),
  
  
  tableOutput('prediction')
))
