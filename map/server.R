library(shiny)
library(maps)
library(mapproj)

source("helpers.R")
counties <- readRDS("counties.rds")

popState <- read.csv("predictedPop.csv", sep = ',',
                    stringsAsFactors = F)

plotMap <- function(var, title = "pop", year, color = "darkgreen", min =0, max = 100){
       shades <- colorRampPalette(c("white", color))(100)
       
       # constrain gradient to percents that occur between min and max
       var <- pmax(var, min)
       var <- pmin(var, max)
       percents <- as.integer(cut(var, 100, 
                                  include.lowest = TRUE, ordered = TRUE))
       fills <- shades[percents]
       
       
       map('state', fill = TRUE, col = fills)
       # title(main = paste('Population', year))
       
       
       # map('state', fill = TRUE, col = palette())
       
       #        inc <- (max - min) / 4
       #        legend.text <- c(paste0(min, " % or less"),
       #                         paste0(min + inc, " %"),
       #                         paste0(min + 2 * inc, " %"),
       #                         paste0(min + 3 * inc, " %"),
       #                         paste0(max, " % or more"))
       #        
       #        legend("bottomleft", inset=c(-0.2,0.1), 
       #               legend = legend.text, 
       #               fill = shades[c(1, 25, 50, 75, 100)], 
       #               title = title)
       #        
}

normChange <- function(yr1, yr2){
       
       norm1 <- findNorm(yr1)
       
       norm2 <- findNorm(yr2)
       
       diff <- abs(norm1 - norm2)  
       diff
}

findNorm <- function(yrVal){
       normVal <- (yrVal - min(yrVal)) / (max(yrVal) - min(yrVal))
       normVal
}



colVal <- names(counties)[3:6]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
       
       output$stateSelector <- renderUI({
              selectInput("state", "State:", as.list(colVal))
       })
      
        output$map2 <- renderPlot(
              plotMap(findNorm(popState[[paste0('X',input$sy)]]), year = input$sy)
       )
       
       output$map <- renderPlot(
              plotMap(normChange(popState$X2014,popState[[paste0('X',input$cy)]]),
                      year = input$sy)
       )
       
})