


propertyDamageSummary2 <- cleanStormData %>%
  group_by(STATE, eventBeginYear, eventType) %>%
  summarise_each(funs(sum))

# Choice Both, Property or Crop



mutate(stateLong = state.name[match(STATE,state.abb)]) %>%
select(c(STATE, stateLong, eventBeginYear, eventType, PROPDMG, CROPDMG, propExponent, cropExponent))
mutate(acl, limb=ifelse(xor(athlete %in% leftAthletes, limb == 'left'),
                        'uninjured', 'ACLR'))
mutate(propertyDamageSummary2, stateLong = if("AS" %in% STATE) print("American Samoa"))


cleanStormData2 <- stormData %>%
  group_by(eventType) %>%
  select(STATE,
         FATALITIES,INJURIES,
         PROPDMG,
         CROPDMG,
         eventBeginYear,eventType,
         propExponent,cropExponent)

propertyDamageSummary2 <- cleanStormData2 %>%
  filter(eventBeginYear == 2000) %>%
  group_by(eventType) %>%
  summarise(propertyDamage = sum(PROPDMG * propExponent),
            cropDamage = sum(CROPDMG*cropExponent),
            eventCount = n() ) %>%
  mutate(totalDamage = propertyDamage + cropDamage) %>%
  mutate(eventFreq = totalDamage / eventCount ) %>%
  arrange(desc(totalDamage))


propertyDamageSummary3 <- cleanStormData2 %>%
  filter(eventBeginYear == 2000 ) %>%
  group_by(STATE, eventBeginYear) %>%
  summarise(propertyDamage = sum(PROPDMG * propExponent),
            cropDamage = sum(CROPDMG*cropExponent),
            totalDamage = sum(propertyDamage + cropDamage),
            eventCount = n() )

#      mutate(stateLong = state.name[match(STATE,state.abb)]) %>%
#  select(c(STATE, eventBeginYear, eventType, PROPDMG, CROPDMG, propExponent, cropExponent))
