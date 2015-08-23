# ---
# title:  "Developing Data Products: Manipulate Function"
# author: "TechnoPhobe01"
# date:   "August 5, 2015"
# ---

setwd(
  "~/Documents/Dropbox/dev/cousera/courses/09_DevelopingDataProducts/00CourseWork/StormDatabase"
)

requiredPackages <- c(
  "rmarkdown",
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
  "shiny",
  "maps",
  "mapdata",
  "maptools",
  "RGraphics",
  "sp",
  "rgdal",
  "raster",
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

stormData <- read.csv("./data/cleanStormData.csv.bz2")
stormData$X <- NULL

# -----------------------------------------------------------------------------

propertyDamageSummary <- aggregate(cbind(FATALITIES, INJURIES, PROPDMG, CROPDMG, propExponent, cropExponent) ~ STATE + eventBeginYear + eventType, data = stormData, sum)

propertyDamageSummary2 <- stormData %>%
  group_by(STATE, eventBeginYear, eventType) %>%
  summarise_each(funs(sum))


manipulate({
  propertyDamageSummary <- stormData %>%
    filter(eventBeginYear == SliderYear) %>%
    group_by(eventType) %>%
    summarise(
      propertyDamage = sum(PROPDMG * propExponent),
      cropDamage = sum(CROPDMG * cropExponent),
      eventCount = n()
    ) %>%
    mutate(totalDamage = propertyDamage + cropDamage) %>%
    mutate(eventFreq = totalDamage / eventCount) %>%
    arrange(desc(totalDamage))

  map(regions = "Brazil", fill = TRUE, col = "gray")

  brazil <-
    readShapeSpatial(system.file("extra", "10m-brazil.shp",
                                 package = "RGraphics"))
  plot(brazil, col = "gray")

  spplot(brazil, "Regions", col.regions = gray(5:1 / 6))

  brazilRegions <-
    readShapeSpatial(system.file("extra",
                                 "10m_brazil_regions.shp",
                                 package = "RGraphics"))

  brazilCapitals <-
    readShapeSpatial(system.file("extra",
                                 "10m_brazil_capitals.shp",
                                 package = "RGraphics"))

  spplot(
    brazil, "Regions",
    col.regions = gray.colors(5, 0.8, 0.3),
    col = "white",
    panel = function(...) {
      panel.polygonsplot(...)
      sp.lines(brazilRegions, col = "gray40")
      labels <- brazilCapitals$Name
      w <- stringWidth(labels)
      h <- stringHeight(labels)
      locs <- coordinates(brazilCapitals)
      grid.rect(
        unit(locs[, 1], "native"),
        unit(locs[, 2], "native"),
        w, h, just = c("right", "top"),
        gp = gpar(col = NA, fill = rgb(1, 1, 1, .5))
      )
      sp.text(locs, labels, adj = c(1, 1))
      sp.points(brazilCapitals, pch = 21,
                col = "black", fill = "white")
    }
  )

  marajo <-
    readShapeSpatial(system.file("extra", "marajo.shp",
                                 package = "RGraphics"))

  plot(marajo, col = "gray", pbg = "white")

  iceland <-
    readShapeSpatial(system.file("extra", "10m-iceland.shp",
                                 package="RGraphics"))
  plot(iceland, col="gray")

  proj4string(iceland) <- CRS("+proj=longlat +ellps=WGS84")
  plot(iceland, col="gray")

  icelandMercator <- spTransform(iceland,
                                 CRS("+proj=merc +ellps=GRS80"))

  plot(icelandMercator)

  proj4string(brazil) <- CRS("+proj=longlat +ellps=WGS84")
  brazilOrtho <- spTransform(brazil, CRS("+proj=ortho"))
  plot(brazilOrtho, col="gray")

  library(maptools)
  library(rgdal)

  brazil <-
    readShapeSpatial(system.file("extra", "10m-brazil.shp",
                                 package = "RGraphics"))

  proj4string(brazil) <- CRS("+proj=longlat +ellps=WGS84")
  glines <- gridlines(brazil)
  glinesOrtho <- spTransform(glines, CRS("+proj=ortho"))
  par(mar = rep(0, 4))
  brazilOrtho <- spTransform(brazil, CRS("+proj=ortho"))
  sp::plot(brazilOrtho, col = "gray")
  sp::plot(glinesOrtho, lty = "dashed", add = TRUE)

  #---

  library(maptools)
  library(raster)
  brazil <-
    readShapeSpatial(system.file("extra", "10m-brazil.shp",
                                 package = "RGraphics"))
  # Read in prepared raster
  brazilRelief <- raster(system.file("extra", "brazilRelief.tif",
                                     package = "RGraphics"))

  # Make PNG version for this one because otherwise it's TOO big
  png("Figures/maps-brazilraster.png",
      width = 900, height = 900)
  par(mar = rep(0, 4))
  raster::image(brazilRelief, col = gray(0:255 / 255), maxpixels = 1e6)
  sp::plot(brazil, add = TRUE)
  box(lwd = 4)
  dev.off()
  system("cp Figures/maps-brazilraster.png Web/")


}, SliderYear = slider(
  min = 1951, max = 2011, initial = 1995, ticks = TRUE
))
