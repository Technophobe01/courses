require(shiny)

###############################################################################
##
##  shinyUI function
##
###############################################################################
shinyUI(
  pageWithSidebar(
    headerPanel("World Bank Economic Indicators"),

    sidebarPanel(
      helpText("Data from the World Bank."),


      conditionalPanel(
        condition = "input.theTabs == 'firstTab' ",

        h3('Time series of an indicator'),
        selectInput("indicator","Select an indicator:", choices = nameToCode, selected = "Fertility rate, total (births per woman)"),
        checkboxInput("logScale","Log scale",value = FALSE)
      ),

      conditionalPanel(
        condition = "input.theTabs == 'secondTab' ",
        h3('Bubble Chart'),
        sliderInput("year","Select a year:",min = 1961, max = 2010, step = 1, value = 2000, format = "####",animate=TRUE, sep = ""),
        selectInput("xAxis","Select the first variable:", choices = nameToCode, selected = "Fertility rate, total (births per woman)"),
        selectInput("yAxis","Select the second variable:", choices = nameToCode, selected = "Life expectancy at birth, total (years)")

      )

    ),

    mainPanel(
      tabsetPanel(
        tabPanel( "Time series", plotOutput("timeSeries"),
                  verbatimTextOutput("descriptionTab1"), value = "firstTab"),
        tabPanel( "Bubble Chart", plotOutput("bubbleChart"),
                  verbatimTextOutput("descriptionTab2"), value = "secondTab"),
        id = "theTabs"
      )
    )
  )

)
