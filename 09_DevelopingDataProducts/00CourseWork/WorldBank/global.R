###############################################################################
##
##  lookup tables: indicator code <-> indicator name
##  Both UI.R and server.R will use the lookup tables so we plce them in
##  global.R
##
################################################################################

# from code to name
codeToName <- c(
  AG.LND.AGRI.ZS = "Agricultural land (% of land area)",
  AG.PRD.CREL.MT = "Cereal production (metric tons)",
  AG.YLD.CREL.KG = "Cereal yield (kg per hectare)",
  EG.IMP.CONS.ZS = "Energy imports, net (% of energy use)",
  EG.USE.COMM.FO.ZS = "Fossil fuel energy consumption (% of total)",
  EG.USE.ELEC.KH.PC = "Electric power consumption (kWh per capita)",
  EN.ATM.CO2E.PC = "CO2 emissions (metric tons per capita)",
  EN.URB.LCTY.UR.ZS = "Population in the largest city (% of urban population)",
  FI.RES.TOTL.CD = "Total reserves (includes gold, current US$)",
  GDPPCKD = "GDP per Capita, constant US$, millions",
  MS.MIL.MPRT.KD = "Arms imports (constant 1990 US$)",
  NY.GDP.PCAP.CD = "GDP per capita (current US$)",
  SH.DYN.MORT = "Mortality rate, under-5 (per 1,000 live births)",
  SP.DYN.TFRT.IN = "Fertility rate, total (births per woman)",
  SP.POP.DPND = "Age dependency ratio (% of working-age population)",
  SP.POP.TOTL = "Population, total",
  SP.URB.TOTL.IN.ZS = "Urban population (% of total)",
  TX.VAL.MRCH.CD.WT = "Merchandise exports (current US$)"
)

# from name to code
nameToCode <- names(codeToName)
names(nameToCode) <- codeToName

# code to description
codeToDescription = c(
  AG.LND.AGRI.ZS = "Agricultural land refers to the share of land area that is arable, under permanent crops, and under permanent pastures. Arable land includes land defined by the FAO as land under temporary crops (double-cropped areas are counted once), temporary meadows for mowing or for pasture, land under market or kitchen gardens, and land temporarily fallow. Land abandoned as a result of shifting cultivation is excluded. Land under permanent crops is land cultivated with crops that occupy the land for long periods and need not be replanted after each harvest, such as cocoa, coffee, and rubber. This category includes land under flowering shrubs, fruit trees, nut trees, and vines, but excludes land under trees grown for wood or timber. Permanent pasture is land used for five or more years for forage, including natural and cultivated crops.",
  AG.PRD.CREL.MT = "Production data on cereals relate to crops harvested for dry grain only. Cereal crops harvested for hay or harvested green for food, feed, or silage and those used for grazing are excluded.",
  AG.YLD.CREL.KG = "Cereal yield, measured as kilograms per hectare of harvested land, includes wheat, rice, maize, barley, oats, rye, millet, sorghum, buckwheat, and mixed grains. Production data on cereals relate to crops harvested for dry grain only. Cereal crops harvested for hay or harvested green for food, feed, or silage and those used for grazing are excluded. The FAO allocates production data to the calendar year in which the bulk of the harvest took place. Most of a crop harvested near the end of a year will be used in the following year.",
  EG.IMP.CONS.ZS = "Net energy imports are estimated as energy use less production, both measured in oil equivalents. A negative value indicates that the country is a net exporter. Energy use refers to use of primary energy before transformation to other end-use fuels, which is equal to indigenous production plus imports and stock changes, minus exports and fuels supplied to ships and aircraft engaged in international transport.",
  EG.USE.COMM.FO.ZS = "Fossil fuel comprises coal, oil, petroleum, and natural gas products.",
  EG.USE.ELEC.KH.PC = "Electric power consumption measures the production of power plants and combined heat and power plants less transmission, distribution, and transformation losses and own use by heat and power plants.",
  EN.ATM.CO2E.PC = "Carbon dioxide emissions are those stemming from the burning of fossil fuels and the manufacture of cement. They include carbon dioxide produced during consumption of solid, liquid, and gas fuels and gas flaring.",
  EN.URB.LCTY.UR.ZS = "Population in largest city is the percentage of a country's urban population living in that country's largest metropolitan area.",
  FI.RES.TOTL.CD = "Total reserves comprise holdings of monetary gold, special drawing rights, reserves of IMF members held by the IMF, and holdings of foreign exchange under the control of monetary authorities. The gold component of these reserves is valued at year-end (December 31) London prices. Data are in current U.S. dollars.",
  GDPPCKD = "GDP per capita is gross domestic product divided by midyear population. GDP at purchaser's prices is the sum of gross value added by all resident producers in the economy plus any product taxes and minus any subsidies not included in the value of the products. It is calculated without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in constant US$. The base year is 2005.",
  MS.MIL.MPRT.KD = "Arms transfers cover the supply of military weapons through sales, aid, gifts, and those made through manufacturing licenses. Data cover major conventional weapons such as aircraft, armored vehicles, artillery, radar systems, missiles, and ships designed for military use. Excluded are transfers of other military equipment such as small arms and light weapons, trucks, small artillery, ammunition, support equipment, technology transfers, and other services.",
  NY.GDP.PCAP.CD = "GDP per capita is gross domestic product divided by midyear population. GDP is the sum of gross value added by all resident producers in the economy plus any product taxes and minus any subsidies not included in the value of the products. It is calculated without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in current U.S. dollars.",
  SH.DYN.MORT = "Under-five mortality rate is the probability per 1,000 that a newborn baby will die before reaching age five, if subject to current age-specific mortality rates.",
  SP.DYN.TFRT.IN = "Total fertility rate represents the number of children that would be born to a woman if she were to live to the end of her childbearing years and bear children in accordance with current age-specific fertility rates.",
  SP.POP.DPND = "Age dependency ratio is the ratio of dependents--people younger than 15 or older than 64--to the working-age population--those ages 15-64. Data are shown as the proportion of dependents per 100 working-age population.",
  SP.POP.TOTL = "Population, total refers to the total population.",
  SP.URB.TOTL.IN.ZS = "Urban population refers to people living in urban areas as defined by national statistical offices. It is calculated using World Bank population estimates and urban ratios from the United Nations World Urbanization Prospects.",
  TX.VAL.MRCH.CD.WT = "Merchandise exports show the f.o.b. value of goods provided to the rest of the world valued in current U.S. dollars."
  )
