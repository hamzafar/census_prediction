library(shiny)
shinyUI(fluidPage(
       
       # Application title
       titlePanel("Predict Census"),
       
       # Sidebar with a slider input for the number of bins
       sidebarLayout(
              sidebarPanel(
                     selectInput("topic", label = h3("Topic"), 
                                 choices = list("House Hold" = 1, "Population" = 2
                                 ), selected = 2
                     ),
                     
                     numericInput('sy', label = 'Year',
                                  value = 2014, min = 2014, max = 2017, step = 1
                                  ),
                     
                     sliderInput('cy', 'Compare Year',
                                 min = 2015, max = 2017, value = 2014
                     )
                     
              ),
              
              # Show a plot of the generated distribution
              mainPanel(
                     
                     tags$h2("Population 2014:"),
                     plotOutput("map2"),
                     
                     tags$h2("Change Population:"),
                     plotOutput("map")
              )
       )
))