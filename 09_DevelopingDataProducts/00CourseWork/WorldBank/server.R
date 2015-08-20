require(shiny)
require(ggplot2)

options(scipen = 999)

# load the data
worldBank <- read.csv("./data/WDIDataDashboard.csv", sep = "\t", header = TRUE)


###############################################################################
##
##  bubbleChart function
##
###############################################################################

bubbleChart <- function(X,x,y,radius,colour, alpha = 0.6){
  gp <- ggplot(X,aes_string(x = x, y = y ))
  gp <- gp + geom_point(aes_string(size = radius, colour = colour), alpha = alpha)
  gp <- gp + geom_point(aes_string(size = radius), colour = 'black', alpha = 1, shape = 1 )
  gp <- gp + guides(colour = guide_legend(override.aes = list(alpha = 1, size = 5)))
  gp
}

###############################################################################
##
##  printDescription function
##
###############################################################################

printDescription <- function(name,description){
  s <- name
  s <- paste0(s, "\n", paste(rep("=",nchar(name)),collapse=''))
  s <- paste0(s, "\n", description)
  cat(s)
}

###############################################################################
##
##  ShinyServer...
##
###############################################################################

shinyServer(function(input,output){

  #############################################################################
  ##
  ##  time series of an indicator...
  ##
  #############################################################################

  output$timeSeries <-  renderPlot({
    p <- ggplot(
      worldBank,
      aes_string( x = 'Year', y = input$indicator, colour = "Country"))
    p <- p + theme_wsj() + theme(axis.title=element_text(size=12))
    p <- p + theme(axis.title.y = element_text(angle=90))
    p <- p + geom_line()
    p <- p + geom_point()
    p <- p + ylab(codeToName[input$indicator])
    p <- p + scale_color_brewer(type="qual",palette='Set1')
    p <- p + guides(colour = guide_legend(override.aes = list(alpha = 1, size = 5)))
    if(input$logScale) {
      p <- p + scale_y_log10()
    }
    print(p)
  })

  output$descriptionTab1 <- renderPrint({
    printDescription(codeToName[input$indicator], codeToDescription[input$indicator])
  })

  ###############################################################################
  ##
  ##  Bubble Chart by Year...
  ##
  ###############################################################################

  output$bubbleChart <- renderPlot({
    p <- bubbleChart(
      subset(worldBank, Year == input$year),
      x = input$xAxis,
      y = input$yAxis,
      radius = "SP.POP.TOTL",
      colour = "Country")
    p <- p + theme_wsj() + theme(axis.title=element_text(size=12))
    p <- p + theme(axis.title.y = element_text(angle=90))
    p <- p + scale_color_brewer(type="qual",palette='Set1')
    p <- p + guides(size = guide_legend(title = codeToName['SP.POP.TOTL']))
    p <- p + xlab(codeToName[input$xAxis])
    p <- p + ylab(codeToName[input$yAxis])
    p <- p + scale_size_area(max_size=14)
    p <- p + ggtitle(paste("World Bank Economic Data - Year: ",input$year))
    print(p)
  })

  output$descriptionTab2 <- renderPrint({
    printDescription(codeToName[input$xAxis], codeToDescription[input$xAxis])
    cat("\n\n")
    printDescription(codeToName[input$yAxis], codeToDescription[input$yAxis])
  })

})
