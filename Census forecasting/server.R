library(shiny)

library(forecast)

set.seed(1300)

# setwd("F:/Census/data set/state-wise data/aff_B25001")
setwd("aff_B25001")

dataFiles <- list.files(path = ".", pattern = "_with_ann.csv")

m <- as.data.frame(matrix(nrow=0,ncol = 52))

for(i in dataFiles){
       dataState <- read.csv(i, sep = ',', stringsAsFactors = F, skip = 1)
       
       colVal <- dataState$Geography
       rowVal <- dataState$Estimate..Total
       yr <- regmatches(i,regexpr('[0-9][0-9]',i))
       
       rowVal <- as.integer(c(yr, rowVal))
       m <- rbind(m, rowVal)
}

names(m) <- c('year', colVal)



nextYear <- function(n, sy, ey, state, fun, alp){
       # temp <- m$Arkansas
       
       temp <- m[[state]]
       
       myts <- ts(temp, start = sy, end = ey)
       
       if(fun == 'ets'){
              fit <- ets(myts, alpha = alp)
       }
       if(fun == 'arima'){
              fit <- auto.arima(myts)
       }
       
       forecast(fit, n)
       #   
       #   points(2014, temp[length(temp)], col = 'red')
       
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
       
       output$stateSelector <- renderUI({
              selectInput("state", "State:", as.list(colVal))
       })
       
       output$tsTopic <- renderPlot({
              plot(nextYear(input$n, input$sy, input$ey, input$state, input$method, input$alpha),
                   main = paste('House unit of', input$state), xlab = 'year') 
              points(input$ey + 1, m[[input$state]][length(m[[input$state]])],
                     col = 'red')
       })
       
       output$value <- renderText(
              m[[input$state]][length(m[[input$state]])]
       )
       
       output$forecast <- renderTable({
              as.data.frame(
                     nextYear(input$n, input$sy, input$ey, input$state, input$method, input$alpha)
              )
       })
       
})