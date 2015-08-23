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
##  bubbleChart funtion
##
#################################################################################

bubbleChart <- function(X,x,y,radius,colour, alpha = 0.6){

  p <- ggplot(X,aes_string(x = x, y = y )) +
    geom_point(aes_string(size = radius, colour = colour), alpha = alpha) +
    geom_point(aes_string(size = radius), colour = 'black', alpha = 1, shape = 1 ) +
    guides(colour = guide_legend(override.aes = list(alpha = 1, size = 5)))
  p
}

###############################################################################
##
## Here we wrap the bubble chart function within the manipulate function. We
## use the subset command to allow us to extract the data for a specific year.
## "SliderYear" is defined as a variable to manipulate allowing us to
## manipulate the chart and step through the changes by year.
##
#################################################################################

manipulate(
  {
    propertyDamageSummary <- stormData %>%
      filter(eventBeginYear == SliderYear) %>%
      group_by(eventType) %>%
      summarise(propertyDamage = sum(PROPDMG*propExponent),
                cropDamage = sum(CROPDMG*cropExponent),
                eventCount = n() ) %>%
      mutate(totalDamage = propertyDamage + cropDamage) %>%
      mutate(eventFreq = totalDamage / eventCount ) %>%
      arrange(desc(totalDamage))
  gp <- ggplot(head(propertyDamageSummary, n = 10),
               aes(x=totalDamage,
                   y=eventCount,
                   color=eventType,
                   label = eventType,
                   xmin = -250,
                   ymin = -600,
                   xmax = 120000000,
                   ymax = 1000 ))
  gp <- gp + geom_point(aes(size = totalDamage))
  gp <- gp + scale_size_area(max_size=20)
  gp <- gp + geom_point(size = 5) + geom_text(size = 4, hjust = .5, vjust = 4 )
  gp <- gp + theme(axis.text=element_text(size=12),
                   axis.title=element_text(size=14,face="bold"),
                   plot.title = element_text(face="bold"))
  gp <- gp + xlab(paste0("\n","Total Damage"))
  gp <- gp + ylab(paste0("Weather Events","\n"))
  gp <- gp + ggtitle(paste("Events with the greatest economic consequences - Year: ",SliderYear))
  print(gp)
  }, SliderYear = slider(min = 1951, max = 2011, initial = 1995, ticks=TRUE))


