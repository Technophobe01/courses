# ---
# title:  "Developing Data Products: Manipulate Function"
# author: "TechnoPhobe01"
# date:   "August 5, 2015"
# ---

setwd("~/Documents/Dropbox/dev/cousera/courses/09_DevelopingDataProducts/00CourseWork/StormDatabase")

requiredPackages <- c("rmarkdown",
                      "knitr",
                      "R.utils",   # Used for unziping the bz2 zip file...
                      "lubridate", # Used for time formatting
                      "ggplot2",   # Used to plot graphics
                      "dplyr",     # Used for data manipulation (very Cool!)
                      "scales",    # Used to scale map data to aesthetics,
                      # and provide methods for automatically
                      # determining breaks and labels for axes
                      # and legends.
                      "reshape2",  # Used to manipulate and reshape the data
                      "gridExtra", # Used to map out plots in Grids
                      "ggthemes",  # Extra themes, scales and geoms for ggplot (Very cool!)
                      "xtable",    # Used to print R objects HTML tables)
                      "manipulate",
                      "shiny")

ipak <- function(pkg)
{
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

ipak(requiredPackages)

options(scipen = 999)

stormData <- read.csv("./data/cleanStormData.csv.bz2")

###############################################################################
##
## Here we first extract the eventImpactdata for a particular eventBeginYear, we
## then use the year data to present the event fatilities and Injuries by event
## type for the year.
##
#################################################################################

manipulate(
  {
    eventImpactSummary <- stormData %>%
      filter(eventBeginYear == SliderYear) %>%
      group_by(eventType) %>%
      summarise(eventFatalities = sum(FATALITIES),
                eventInjuries = sum(INJURIES),
                eventCount = n() ) %>%
      mutate(popImpacted = eventFatalities + eventInjuries) %>%
      mutate(eventFreq = popImpacted / eventCount ) %>%
      arrange(desc(popImpacted))
    gp <- ggplot(head(eventImpactSummary, n = 10),
                 aes(x=eventFatalities,
                     y=eventInjuries,
                     color=eventType,
                     label = eventType,
                     xmin = -50,
                     ymin = -50,
                     ymax = eventInjuries + 1000
                 ))
    gp <- gp + geom_point(aes(size = eventCount))
    gp <- gp + scale_size_area(max_size=20)
    gp <- gp + geom_point(size = 5) + geom_text(size = 4, hjust = .7, vjust = 3 )
    gp <- gp + theme(axis.text=element_text(size=12),
                     axis.title=element_text(size=14,face="bold"),
                     plot.title = element_text(face="bold"))
    gp <- gp + xlab(paste0("\n","Total Injuries"))
    gp <- gp + ylab(paste0("Total Fatalities","\n"))
    gp <- gp + ggtitle(paste("Events most harmful with respect to population - Year: ",SliderYear))
    print(gp)
  }, SliderYear = slider(min = 1951, max = 2011, initial = 2000, ticks=TRUE))


