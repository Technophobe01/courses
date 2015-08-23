# server for full dashboard

requiredPackages <- c(
  "shiny",
  "rmarkdown",
  "RCurl",
  "ggplot2",   # Used to plot graphics
  "dplyr",     # Used for data manipulation (very Cool!)
  "scales",    # Used to scale map data to aesthetics,
  # and provide methods for automatically
  # determining breaks and labels for axes
  # and legends.
  "knitr",
  "R.utils",   # Used for unziping the bz2 zip file...
  "lubridate", # Used for time formatting
  "reshape2",  # Used to manipulate and reshape the data
  "gridExtra", # Used to map out plots in Grids
  "ggthemes",  # Extra themes, scales and geoms for ggplot (Very cool!)
  "xtable",    # Used to print R objects HTML tables)
  "maps",
  "rCharts",
  "reshape2",
  "data.table",
  "mapproj",
  "googleVis"
)

ipak <- function(pkg)
{
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

ipak(requiredPackages)

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
        xmin = -250,
        ymin = -600,
        xmax = 120000000,
        ymax = 1000
      )
    )
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
        ymin = -250,
        ymax = eventInjuries + 1000
      )
    )
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
