# UI for full dashboard

library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Analysis of [NOAA] Storm Database and Weather Events"),

  sidebarPanel(
    helpText(
      "Data derived from the National Oceanic and Atmospheric Administration ([NOAA])"
    ),

    conditionalPanel(
      condition = "input.theTabs == '3Tab' ",
      h3('Economic Impact'),
      sliderInput(
        "EconImpactSliderYear", "Select a year:",min = 1950, max = 2011, step = 1, value = 2000, animate = TRUE, sep = ""
      )
    ),

    conditionalPanel(
      condition = "input.theTabs == '4Tab' ",
      h3('Population Impact'),
      sliderInput(
        "EventImpactSliderYear", "Select a year:",min = 1950, max = 2011, step = 1, value = 2000, animate = TRUE, sep = ""
      )
    ),

    conditionalPanel(
      condition = "input.theTabs == '5Tab' ",
      h3('Geographic Impact'),
      sliderInput("GeographicImpactSliderYear", "Select a year:", min = 1950, max = 2011, value = 2000,  step = 1, animate = TRUE, sep = ""),
      radioButtons("economicCategoryButton","Select Impact category:",
                   c("Both" = "both", "Property damage" = "property", "Crops damage" = "crops")
      )
    )

  ),

  mainPanel(
    tabsetPanel(
      tabPanel("About",includeMarkdown("ReadMe.md")),
      tabPanel(
        "Economic Impact", plotOutput("EconomicImpact"),
        verbatimTextOutput("descriptionTab3"), value = "3Tab"
      ),
      tabPanel(
        "Population Impact", plotOutput("PopulationImpact"),
        verbatimTextOutput("descriptionTab4"), value = "4Tab"
      ),
      tabPanel(
        "Geographic Impact",
        h3(textOutput("GeographicImpactYear")),
        htmlOutput("GeographicImpact"),
        verbatimTextOutput("descriptionTab5"), value = "5Tab"
      ),
      id = "theTabs"
    )
  )
))
