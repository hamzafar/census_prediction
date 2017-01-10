library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
       
       # Application title
       titlePanel("Predict Census"),
       
       # Sidebar with a slider input for the number of bins
       sidebarLayout(
              sidebarPanel(
                     
                     selectInput("topic", label = h3("Topic"), 
                                 choices = list("House Hold" = 1, "Population" = 2
                                 ), selected = 1
                     ),
                     
                     sliderInput("n", "Next Year:",
                                 min = 1, max = 3,value = 2
                     ),
                     sliderInput('sy', 'Start Year',
                                 min = 2005, max = 2014, value = 2005
                     ),
                     sliderInput('ey', 'End Year',
                                 min = 2005, max = 2014, value = 2013
                     ),
                     #                      selectInput("state", label = h3("State"), 
                     #                                  choices = list("Alabama", "Alaska" ,
                     #                                                 "Arizona"), selected = "Alabama"
                     #                                  ),
                     
                     uiOutput("stateSelector"),
                     
                     radioButtons("method", label = h3("Method"),
                                  choices = list("Exponential" = 'ets', "Moving Average" = 'arima'
                                  ),selected = 'ets'
                     ),
                     
                     numericInput('alpha', label = 'Alpha for Exponential',
                                  value = 0.1, min = 0.1, max = 0.9, step = 0.02)
              ),
              
              # Show a plot of the generated distribution
              mainPanel(
                     tags$h2("Visulization:"),
                     plotOutput("tsTopic"),
                     
                     tags$h3("Forecast Result:"),
                     tableOutput('forecast'),
                     
                     tags$h4("Value @ 2014:"),
                     tableOutput('value')
                     
                     
                     
              )
       )
))