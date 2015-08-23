
require(dplyr)
require(tidyr)
require(reshape2)

stormData$X <- NULL

propertyDamageSummary <- stormData %>%
  filter(STATE == 'AL') %>%
  group_by(STATE,eventBeginYear, eventType)

propertyDamageSummary2 <- stormData %>%
  group_by(STATE,eventBeginYear, eventType) %>%
  summarise_each(funs(sum))

ggplot(data=propertyDamageSummary2,
       aes(x=eventBeginYear, y=PROPDMG, colour=eventType)) +
  geom_line()

rm(propertyDamageSummary2)

propertyDamageSummary2 <- stormData %>%
  group_by(X,STATE,eventBeginYear, eventType) %>%
  summarise_each(funs(sum),matches("eventType"))

propertyDamageSummary2 <- stormData %>%
  group_by(X, STATE, eventBeginYear, eventType) %>%
  summarise_each(funs(sum))

ggplot(propertyDamageSummary2) +
  geom_line( aes( x = eventBeginYear, y = (PROPDMG * propExponent), colour = eventType)) +
  ggtitle("geom_lines, using group ")




rm(p)
p <- ggplot(  propertyDamageSummary2,
              aes_string( x = PROPDMG * propExponent,
                          y = 'eventBeginYear',
                          colour = eventType))
p <- p + geom_line()
p <- p + geom_point()
p <- p + ylab("Property Damage")
p <- p + xlab("Year")
P <- p + scale_color_brewer(type = "qual", palette = 'Set1')
p <- p + guides(colour = guide_legend(override.aes = list(alpha = 1, size = 5)))
p

p <- ggplot(
  propertyDamageSummary2,
    aes_string( x = 'eventBeginYear', y = PROPDMG*propExponent, colour = "eventType"))
  p <- p + theme_wsj() + theme(axis.title = element_text(size = 12))
  p <- p + theme(axis.title.y = element_text(angle = 90))
  p <- p + geom_line()
  p <- p + geom_point()
  p <- p + ylab("Proprty Damage")
  p <- p + scale_color_brewer(type = "qual",palette = 'Set1')
  p <- p + guides(colour = guide_legend(override.aes = list(alpha = 1, size = 5)))
p




