
library(shiny)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  titlePanel("What are you thinking?"),

  
  textInput('text', 'Type something below'),
  
  
  tableOutput('prediction')
))
