# Global File for shared data

###############################################################################
##
##  lookup tables: indicator code <-> indicator name
##  Both UI.R and server.R will use the lookup tables so we plce them in
##  global.R
##
################################################################################

# from code to name
codeToName <- c(
  eventEconomicImpact = "Economic Impact (By state)",
  eventPopulationImpact = "Population Impact (By state)"
)

# from name to code
nameToCode <- names(codeToName)
names(nameToCode) <- codeToName

