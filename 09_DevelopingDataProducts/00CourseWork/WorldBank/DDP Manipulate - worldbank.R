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

worldBank <- read.csv("./data/WDIDataDashboard.csv", sep = "\t", header = TRUE)

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
    gp <- bubbleChart(subset(worldBank, Year == SliderYear),
                      "SP.DYN.TFRT.IN",
                      "SH.DYN.MORT",
                      radius = "SP.POP.TOTL",
                      colour = "Country",
                      alpha = 0.6)
    # By default wsj_theme sets axis.title=element_blank() to reenable
    # ylab / xlab we set axix.title... Now ylab / xlab work...
    # Ref: http://stackoverflow.com/questions/14379737/how-can-i-make-xlab-and-ylab-visible-when-using-theme-wsj-ggthemes
    gp <- gp + theme_wsj() + theme(axis.title=element_text(size=12))
    gp <- gp + scale_color_brewer(type="qual",palette='Set1')
    gp <- gp + guides(size = guide_legend(title = codeToName['SP.POP.TOTL']))
    gp <- gp + xlab("Fertility rate, total (births per woman)")
    gp <- gp + ylab("Life expectancy at birth, total (years)")
    # Rotate Ylab by 90 degrees...
    gp <- gp + theme(axis.title.y = element_text(angle=90))
    gp <- gp + scale_size_area(max_size=14)
    gp <- gp + ggtitle(paste("World Bank Economic Data - Year: ",SliderYear))

    print(gp)
  }, SliderYear = slider(min = 1961, max = 2011, initial = 2000, ticks=TRUE))


