
library(shiny)

shinyUI(fluidPage(

  titlePanel("What are you thinking?"),

  
  textInput('text', 'Type something below'),
  
  
  tableOutput('prediction')
))
