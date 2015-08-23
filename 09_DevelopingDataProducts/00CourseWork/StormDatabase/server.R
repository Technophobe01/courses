# server for full dashboard

require(shiny)
require(shinyapps)
require(ggplot2)
require(dplyr)
require(ggthemes)
require(R.utils)
require(googleVis)

options(scipen = 999)

# load the data

cleanStormData <- read.csv("./data/cleanStormData.csv.bz2")
# cleanStormData$X <- NULL

# Helper function to print the tab descriptions
printDescription <- function(name,description) {
  s <- name
  s <- paste0(s, "\n", paste(rep("=",nchar(name)),collapse = ''))
  s <- paste0(s, "\n", description)
  cat(s)
}

shinyServer(function(input,output) {
  # bubble chart: Greatest Economic Impact by Year for Weather Events
  #
  output$EconomicImpact <- renderPlot({
    propertyDamageSummary <- cleanStormData %>%
      filter(eventBeginYear == input$EconImpactSliderYear) %>%
      group_by(eventType) %>%
      summarise(
        propertyDamage = sum(PROPDMG * propExponent),
        cropDamage = sum(CROPDMG * cropExponent),
        eventCount = n()
      ) %>%
      mutate(totalDamage = propertyDamage + cropDamage) %>%
      mutate(eventFreq = totalDamage / eventCount) %>%
      arrange(desc(totalDamage))
    gp <- ggplot(
      head(propertyDamageSummary, n = 10),
      aes(
        x = totalDamage,
        y = eventCount,
        color = eventType,
        label = eventType,
        xmin = -500,
        ymin = -5000,
        xmax = 120000000,
        ymax = (eventCount + 5000)
      )
    )
    gp <- gp + theme_wsj() + theme(axis.title = element_text(size = 12))
    gp <- gp + theme(axis.title.y = element_text(angle = 90))
    gp <- gp + geom_point(aes(size = totalDamage))
    gp <- gp + scale_size_area(max_size = 20)
    gp <-
      gp + geom_point(size = 5) + geom_text(size = 4, hjust = .5, vjust = 4)
    gp <- gp + theme(
      axis.text = element_text(size = 12),
      axis.title = element_text(size = 14,face = "bold"),
      plot.title = element_text(face = "bold")
    )
    gp <- gp + xlab(paste0("\n","Total Damage"))
    gp <- gp + ylab(paste0("Weather Events","\n"))
    gp <-
      gp + ggtitle(
        paste(
          "Events with the greatest economic consequences - Year: ", input$EconImpactSliderYear, "\n"
        )
      )
    print(gp)
  })

  # Print Description of Economic Data
  #
  output$descriptionTab3 <- renderPrint({
    printDescription(
      "Events most harmful with respect to property",
      "The events most harmful to property based on the data are Floods, Huricanes and Tornados. Floods and Hurricanes whilst at lower incidence have tremendous capacity to impart large scale economic damage on property."
    )
  })

  # bubble chart: Greatest Population Impact by Year for Weather Events
  #
  output$PopulationImpact <- renderPlot({
    eventImpactSummary <- cleanStormData %>%
      filter(eventBeginYear == input$EventImpactSliderYear) %>%
      group_by(eventType) %>%
      summarise(
        eventFatalities = sum(FATALITIES),
        eventInjuries = sum(INJURIES),
        eventCount = n()
      ) %>%
      mutate(popImpacted = eventFatalities + eventInjuries) %>%
      mutate(eventFreq = popImpacted / eventCount) %>%
      arrange(desc(popImpacted))

    gp <- ggplot(
      head(eventImpactSummary, n = 10),
      aes(
        x = eventFatalities,
        y = eventInjuries,
        color = eventType,
        label = eventType,
        xmin = -250,
        ymin = -500,
        ymax = eventInjuries + 2000
      )
    )
    gp <- gp + theme_wsj() + theme(axis.title = element_text(size = 12))
    gp <- gp + theme(axis.title.y = element_text(angle = 90))
    gp <- gp + geom_point(aes(size = eventCount))
    gp <- gp + scale_size_area(max_size = 20)
    gp <-
      gp + geom_point(size = 5) + geom_text(size = 4, hjust = .7, vjust = 3)
    gp <- gp + theme(
      axis.text = element_text(size = 12),
      axis.title = element_text(size = 14,face = "bold"),
      plot.title = element_text(face = "bold")
    )
    gp <- gp + xlab(paste0("\n","Total Injuries"))
    gp <- gp + ylab(paste0("Total Fatalities","\n"))
    gp <-
      gp + ggtitle(
        paste(
          "Events most harmful with respect to population - Year: ", input$EventImpactSliderYear, "\n"
        )
      )
    print(gp)
  })

  # Print Description of Economic Data
  #
  output$descriptionTab4 <- renderPrint({
    printDescription(
      "Events most harmful with respect to population",
      "The events most harmful to health based on the data and review period are Tornados, Heat and Wind Storms. Tornadoes and Heat are by far and away the most impactful on human health."
    )
  })

  # Geographic chart: Population / Economic Impact by Year for Weather Events
  #

  output$GeographicImpact <- renderGvis({
    myYear <- reactive({
      input$GeographicImpactSliderYear
    })

    output$GeographicImpactYear <- renderText({
      paste("Geographic impact of Weather Events in Year: ", myYear())
    })



    propertyDamageSummary2 <- cleanStormData %>%
      filter(eventBeginYear == myYear() ) %>%
      group_by(STATE, eventBeginYear) %>%
      summarise(propertyDamage = sum(PROPDMG * propExponent),
                cropDamage = sum(CROPDMG*cropExponent),
                totalDamage = sum(propertyDamage + cropDamage),
                eventCount = n() )

    if (input$economicCategoryButton == 'both') {
      colorvarChoice <- "totalDamage"
    } else if (input$economicCategoryButton == 'property') {
      colorvarChoice <- "propertyDamage"
    } else {
      colorvarChoice <- "cropDamage"
    }

    gvisGeoChart( propertyDamageSummary2,
      locationvar = "STATE", colorvar = colorvarChoice,
      options = list(
        region = "US", displayMode = "regions",
        resolution = "provinces",
        width = 500, height = 400,
        colorAxis = "{colors:['#FFFFFF', '#0000FF']}"
      )
    )
  })

  # Print Description of Economic Data
  #
  output$descriptionTab5 <- renderPrint({
    printDescription(
      "Events most harmful with respect to population or property by state",
      "The events most harmful to health and property in the US principally occur in the central and mid states based on the data and review period analysed"
    )})

})
